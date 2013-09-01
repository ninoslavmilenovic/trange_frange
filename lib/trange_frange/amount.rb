# -*- coding: utf-8 -*-

module TrangeFrange
  class Amount
    attr_reader :amount

    MAX_AMOUNT_SIZE = 12
    BASES     = [TrangeFrange::Hundred, TrangeFrange::Ten, TrangeFrange::One]
    SUFFIXES  = [TrangeFrange::Thousand, TrangeFrange::Milion, TrangeFrange::Bilion]

    def initialize(amount)
      unless amount.is_a?(Fixnum) || amount.is_a?(Float)
        raise TypeError, 'Amount must be of type Fixnum or Float.'
      end

      if max_amount_size?(amount)
        raise NotImplementedError, 'I can only work with amounts up to 999 bilions.'
      end

      @amount = amount
    end

    def spell!(options={})
      TrangeFrange::Shaper.new(generate_words!, fraction, options).shape!
    end

    private

      def max_amount_size?(amount)
        amount.to_s.split('.')[0].size > MAX_AMOUNT_SIZE
      end

      def split!
        @splitted ||= ('%.2f' % amount).split('.')
      end

      def whole_number
        @whole_number ||= split![0]
      end

      def fraction
        @fraction ||= split![1]
      end

      def members
        @members ||= whole_number.reverse.scan(/.{1,3}/).reverse.map(&:reverse)
      end

      def generate_base!(member, magnitude)
        BASES.map do |base|
          base == One ? base.new(member, magnitude).word : base.new(member).word
        end.join(' ').strip.squeeze
      end

      def generate_suffix!(member, magnitude)
        magnitude > 0 ? SUFFIXES[magnitude.pred].new(member).word : String.new
      end

      def generate_words!
        magnitude = members.size.pred
        Array.new.tap do |words|
          members.map do |member|
            words << generate_base!(member, magnitude)
            words << generate_suffix!(member, magnitude) unless words.last.empty?
            magnitude -= 1
          end
        end.join(' ').strip.squeeze
      end
  end
end
