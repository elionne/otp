require_relative 'base32.rb'
require_relative 'hotp.rb'

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
  
  it ".encode" do
    inputs.each_pair{ |s, b32| expect(Base32.encode(s)).to eq(b32)}
  end
  
  it ".decode" do
    inputs.each_pair{ |s, b32| expect(Base32.decode(b32)).to eq(s)}
  end    
end

describe Otp do
  inputs = [
   755224,
   287082,
   359152,
   969429,
   338314,
   254676,
   287922,
   162583,
   399871,
   520489
  ]
  
  key = 0x3132333435363738393031323334353637383930

  it ".hotp" do
    inputs.each_with_index{ |hotp, i| expect(Otp.hotp(key, i, 6)).to eq(hotp.to_s) }
  end
  
  it ".totp" do
    
  end
end