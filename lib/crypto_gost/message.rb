require 'pathname'
require 'matrix'

module CryptoGost
  # Message
  #
  # @author WildDima
  class Message
    attr_accessor :message, :message_vector

    def initialize(message)
      @message = message_type message
    end

    def to_vector
      Vector.elements message.bytes
    end

    def to_bits(byteorder: :big)
      case byteorder
      when :big
        message.unpack('B*')
      when :small
        message.unpack('b*')
      else
        raise ArgumentError,
              "byteorder must be equal to :big or :small, not: #{byteorder}"
      end
    end

    def to_array_of_bits(byteorder: :big)
      to_bits(byteorder).chars
    end

    private

    def message_type(message)
      case message.class
      when Pathname
        File.read(message)
      when String
        message
      else
        message.to_s
      end
    end
  end
end
