require 'openssl'
require_relative 'helpers_functions'

class Otp
  class << self
    # OTP functions
    def hotp(key, counter, digits, digester='sha1')
      digester = OpenSSL::Digest.new(digester)
      hmac = OpenSSL::HMAC.digest(digester, to_binary(key), to_binary(counter, 8))

      code = dynamic_trunc(hmac) % 10**digits
      code.to_s.rjust(digits, '0')
    end

    def totp(key, time = Time.now.utc, window = 30,  digits = 6, digester = 'sha1')
      hotp(key, time.to_i.fdiv(window).truncate, digits, digester)
    end

  private
    def dynamic_trunc(hmac)
      offset = hmac[-1].unpack("C").first & 0x0f
      hmac[offset, 4].unpack("L>").first & 0x7fffffff
    end

  end
end
# 
# srand 120002765818364931371353969670647940910
# 
# key = rand 2**80
# counter = rand 2**64
# 
# p key.to_s(16)
# a = Base32.encode key
# p a
# p Base32.decode(a).to_s 16
# 
# puts Otp.totp(key)
