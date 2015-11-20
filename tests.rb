require_relative 'base32.rb'
require_relative 'hotp.rb'

# Tests values from rfc4648 chapter 10
describe Base32 do
  inputs = {
    "" => "",
    "f" => "my======",
    "fo" => "mzxq====",
    "foo" => "mzxw6===",
    "foob" => "mzxw6yq=",
    "fooba"  => "mzxw6ytb",
    "foobar" => "mzxw6ytboi======"
  }

  context ".encode" do
    inputs.each_pair do |s, b32|
      it "#{s.inspect} should eq #{b32.inspect}" do expect(Base32.encode s).to eq b32 end
    end
  end

  context ".decode" do
    inputs.each_pair do |s, b32|
      it "#{b32.inspect} should eq #{s.inspect}" do expect(Base32.decode b32).to eq s end
    end
  end
end


key_sha1 = 0x3132333435363738393031323334353637383930
key_sha256 = 0x3132333435363738393031323334353637383930313233343536373839303132
key_sha512 = 0x31323334353637383930313233343536373839303132333435363738393031323334353637383930313233343536373839303132333435363738393031323334

# Tests values from rfc4226 appendix D
describe Otp, ".hotp" do
  hotp_inputs = %w(84755224 94287082 37359152 26969429 40338314 68254676 18287922 82162583 73399871 45520489 72403154)

  shared_examples ".hotp" do |size, digits|
    digits.each_with_index do |hotp, counter|
      it "and counter #{counter} should eq #{hotp}" do
        expect(Otp.hotp(key_sha1, counter, size)).to eq(hotp)
      end
    end
  end

  context "with key 0x#{key_sha1.to_s 16}" do
    context "6 digits" do
      include_examples ".hotp", 6, hotp_inputs.map{ |digits| digits.slice(2, 6)}
    end

    context "7 digits" do
      include_examples ".hotp", 7, hotp_inputs.map{ |digits| digits.slice(1, 7)}
    end

    context "8 digits" do
      include_examples ".hotp", 8, hotp_inputs
    end
  end
end

describe Otp, ".totp" do
  totp_times = [59, 1111111109, 1111111111, 1234567890, 2000000000, 20000000000]
  totp_digits_sha1   = %w(94287082 07081804 14050471 89005924 69279037 65353130)
  totp_digits_sha256 = %w(46119246 68084774 67062674 91819424 90698825 77737706)
  totp_digits_sha512 = %w(90693936 25091201 99943326 93441116 38618901 47863826)

  totp_sha1   = { :key => key_sha1,   :times => totp_times, :digits => totp_digits_sha1,   :digester => "sha1"}
  totp_sha256 = { :key => key_sha256, :times => totp_times, :digits => totp_digits_sha256, :digester => "sha256"}
  totp_sha512 = { :key => key_sha512, :times => totp_times, :digits => totp_digits_sha512, :digester => "sha512"}

  shared_examples ".totp" do |data|
    pair = [data[:times], data[:digits]].transpose
    pair.each do |time, digit|
    it do
        expect(Otp.totp(data[:key], time, 30, 8, data[:digester])).to eq(digit)
      end
    end
  end

  context "with sha1" do
    include_examples ".totp", totp_sha1
  end

  context "with sha256" do
    include_examples ".totp", totp_sha256
  end

  context "with sha512" do
    include_examples ".totp", totp_sha512
  end
end
