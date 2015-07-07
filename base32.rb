require_relative 'helpers_functions'

class Base32
  BASE32_ALPHABET = "abcdefghijklmnopqrstuvwxyz234567"

  class << self

    #
    #  MSB
    # 40    35     30    25     20     15    10     5     0
    #  -----------------------------------------------------
    #  |     |   -  |     | -    |    - |     |  -   |     |
    #  -----------------------------------------------------
    #
    #
    #  -----------------------------------------------------
    #  |     -   |  -     - |    -    | -     -  |   -     |
    #  -----------------------------------------------------
    # 40        32         24        16         8         0
    #

    def encode_block(block)
      bits_size = block.size*8

      # Transform to binary and add non-signifants bits to ensure bits numbering
      block = to_number(block).to_s(2).rjust(bits_size, "0")

      # Group bits by 5...
      b32_block = 0.step(bits_size-1, 5).map do |b|
        BASE32_ALPHABET[
          # ...and select corresponding letter. Adjust if the final block is
          # less than 5 bits.
          block[b, 5].ljust(5, "0").to_i(2)
        ]
      end

      # join all segments and add padding if necessary
      b32_block.join.ljust(8, "=")
    end

    def encode(bin)
      bin = to_binary(bin) if bin.kind_of? Integer
      0.step(bin.length-1, 5).map do |b|

        # Try to transform an 5 bytes to 8 block of 5 bits. One block of 5 bits
        # is a letter from BASE32_ALPHABET.
        encode_block(bin[b, 5])
      end.join
    end

    def decode(num)
      return num if num.empty?
      to_binary(decode_block(num))
    end

    def decode_block(block)
      bin_block = block.delete("=").each_char.map do |c|
        BASE32_ALPHABET.index(c).to_s(2).rjust(5, "0")
      end.join
      bin_block.slice(0, bin_block.length - bin_block.length % 8).to_i(2)
    end

  end
end

