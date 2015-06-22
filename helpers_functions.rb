# Helpers functions

# Returns bignumber into the binary representation of this number.
#
# Use reverse twice to avoid a non-odd size for hexdecimal number. With this
# method the non-signifant 0 are placed at the begining instead of the end.

def to_binary(num, padding=0, max_length=nil)
  bin = [num.to_s(16).reverse].pack("h*").reverse.rjust(padding, "\0")
  bin[0, max_length||bin.length]
end

def to_number(bin)
  bin.unpack("H*").first.to_i 16
end

