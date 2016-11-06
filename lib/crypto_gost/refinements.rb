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
        Vector.Raise ErrDimensionMismatch unless (size == v.size) &&
                                                 binary?(v) &&
                                                 binary?(@elements)
        els = collect2(v) do |v1, v2|
          v1 ^ v2
        end

        self.class.elements(els, false)
      end

      def and(v)
        Vector.Raise ErrDimensionMismatch unless (size == v.size) &&
                                                 binary?(v) &&
                                                 binary?(@elements)
        els = collect2(v) do |v1, v2|
          v1 * v2
        end

        self.class.elements(els, false)
      end

      def or(v)
        Vector.Raise ErrDimensionMismatch unless (size == v.size) &&
                                                 binary?(v) &&
                                                 binary?(@elements)
        els = collect2(v) do |v1, v2|
          v1 | v2
        end

        self.class.elements(els, false)
      end

      private

      def binary?(v)
        v.to_a.any? { |el| [0, 1].include? el }
      end
    end
    # rubocop:enable Metrics/LineLength
  end
end
