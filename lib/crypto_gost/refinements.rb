module CryptoGost
  # Refinements module, for legal monkey-pathing some classes
  #
  # @author WildDima
  module Refinements
    require 'matrix'

    # Binary operation to Vector class
    # rubocop:disable BlockLength
    refine Vector do
      def xor(v)
        raise_binary_error(v)
        els = collect2(v) do |v1, v2|
          v1 ^ v2
        end

        self.class.elements(els, false)
      end

      def and(v)
        raise_binary_error(v)
        els = collect2(v) do |v1, v2|
          v1 * v2
        end

        self.class.elements(els, false)
      end

      def or(v)
        raise_binary_error(v)
        els = collect2(v) do |v1, v2|
          v1 | v2
        end

        self.class.elements(els, false)
      end

      def to_i
        raise_binary_error(v)
        @elements.to_a.map(&:to_s).join.to_i(2)
      end

      private

      def binary?(v)
        v.to_a.any? { |el| [0, 1].include? el }
      end

      def raise_binary_error(v)
        Vector.Raise ErrDimensionMismatch unless (size == v.size) &&
                                                 binary?(v) &&
                                                 binary?(@elements)
      end
    end
    # rubocop:enable Metrics/LineLength
  end
end
