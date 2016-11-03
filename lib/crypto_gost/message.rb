require 'pathname'
require 'matrix'

module CryptoGost
  # Message
  #
  # @author Topornin Dmitry
  class Message
    attr_accessor :message, :message_vector

    def initialize(message)
      @message = message_type message
      @message_vector = to_vector @message
    end

    def [](index)
      @message_vector[index]
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

    def to_vector(message)
      Vector.elements message.bytes
    end
  end
end
