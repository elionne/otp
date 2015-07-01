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
      hotp(key, time.to_i.fdiv(window).floor, digits, digester)
    end

  private
    def dynamic_trunc(hmac)
      offset = hmac[-1].unpack("C").first & 0x0f
      hmac[offset, 4].unpack("L>").first & 0x7fffffff
    end

  end
end
