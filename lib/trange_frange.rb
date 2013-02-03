# -*- coding: utf-8 -*-

require 'trange_frange/version'

module TrangeFrange
  class Member < Struct.new :base
    def one
      base[-1]
    end

    def ten
      base.size >= 2 ? base[-2] : '0'
    end

    def hundred
      base.size == 3 ? base[-3] : '0'
    end
  end

  class OrderCondition
    def initialize
      @conditions = []
    end

    def add
      @conditions << Proc.new
    end

    def match!
      @conditions.map(&:call).map do |condition| 
        return condition if condition
      end
    end

    private
      attr_reader :conditions
  end

  class Base < Struct.new :base
    # range [10-19]
    def teen?
      member.ten == '1'
    end

    def gender?
      %w[1 2].include? member.one
    end

    def member
      @member ||= TrangeFrange::Member.new base
    end
  end

  class Suffix < Struct.new :base
    def gender?
      ('2'..'4').include? suffix_base.member.one
    end

    def one?
      suffix_base.member.one == '1'
    end

    def suffix_base
      @suffix_base ||= TrangeFrange::Base.new base
    end
  end

  class One < Struct.new :base, :magnitude
    ONES = {
      '0' => '',        # not printed
      '1' => {
        :m => 'jedan',  # male gender
        :f => 'jedna'   # female gender
      },
      '2' => {
        :m => 'dva',
        :f => 'dve'
      },
      '3' => 'tri',
      '4' => 'četiri',
      '5' => 'pet',
      '6' => 'šest',
      '7' => 'sedam',
      '8' => 'osam',
      '9' => 'devet'
    }

    def word
      order_condition.add { String.new if one_base.teen? }
      order_condition.add { ONES[one_base.member.one][gender] if one_base.gender? }
      order_condition.add { ONES[one_base.member.one] }
      order_condition.match!
    end

    private

      def one_base
        @one_base ||= TrangeFrange::Base.new base
      end

      def order_condition
        @order_condition ||= TrangeFrange::OrderCondition.new
      end

      def gender
        magnitude.odd? ? :f : :m
      end
 end

  class Ten < Struct.new :base
    TENS = {
      '0' => '',
      '10' => 'deset',
      '11' => 'jedanaest',
      '12' => 'dvanaest',
      '13' => 'trinaest',
      '14' => 'četrnaest',
      '15' => 'petnaest',
      '16' => 'šesnaest',
      '17' => 'sedamnaest',
      '18' => 'osamnaest',
      '19' => 'devetnaest',
      '2' => 'dvadeset',
      '3' => 'trideset',
      '4' => 'četrdeset',
      '5' => 'pedeset',
      '6' => 'šezdeset',
      '7' => 'sedamdeset',
      '8' => 'osamdeset',
      '9' => 'devedeset'
    }

    def word
      order_condition.add { TENS[teen_base_member] if ten_base.teen? }
      order_condition.add { TENS[ten_base.member.ten] }
      order_condition.match!
    end

    private

      def ten_base
        @ten_base ||= TrangeFrange::Base.new base
      end

      def order_condition
        @order_condition ||= TrangeFrange::OrderCondition.new
      end

      def teen_base_member
        ten_base.member.ten + ten_base.member.one
      end
  end

  class Hundred < Struct.new :base
    HUNDREDS = {
      '0' => '',
      '1' => 'jedna stotina',
      '2' => 'dve stotine',
      '3' => 'tri stotine',
      '4' => 'četiri stotine',
      '5' => 'pet stotina',
      '6' => 'šest stotina',
      '7' => 'sedam stotina',
      '8' => 'osam stotina',
      '9' => 'devet stotina'
    }

    def word
      order_condition.add { HUNDREDS[hundred_base.member.hundred] }
      order_condition.match!
    end

    private

      def hundred_base
        @hundred_base ||= TrangeFrange::Base.new base
      end

      def order_condition
        @order_condition ||= TrangeFrange::OrderCondition.new
      end
  end

  class Thousand < Struct.new :base
    THOUSANDS = %w[hiljada hiljade]

    def word
      order_condition.add { THOUSANDS[1] if suffix.gender? and !suffix.suffix_base.teen? }
      order_condition.add { THOUSANDS[0] }
      order_condition.match!
    end

    private

      def suffix
        @suffix ||= TrangeFrange::Suffix.new base
      end

      def order_condition
        @order_condition ||= TrangeFrange::OrderCondition.new
      end
  end

  class Milion < Struct.new :base
    MILIONS = %w[milion miliona]

    def word
      order_condition.add { MILIONS[0] if suffix.one? and !suffix.suffix_base.teen? }
      order_condition.add { MILIONS[1] }
      order_condition.match!
    end

    private

      def suffix
        @suffix ||= TrangeFrange::Suffix.new base
      end

      def order_condition
        @order_condition ||= TrangeFrange::OrderCondition.new
      end
  end

  class Bilion < Struct.new :base
    BILIONS = %w[milijarda milijarde milijardi]

    def word
      order_condition.add { BILIONS[0] if suffix.one? and !suffix.suffix_base.teen? }
      order_condition.add { BILIONS[1] if suffix.gender? and !suffix.suffix_base.teen? }
      order_condition.add { BILIONS[2] }
      order_condition.match!
    end

    private

      def suffix
        @suffix ||= TrangeFrange::Suffix.new base
      end

      def order_condition
        @order_condition ||= TrangeFrange::OrderCondition.new
      end
  end

  class Shaper < Struct.new :words, :fraction, :options
    OPTIONS = [:bald, :squeeze, :show_fraction]

    def shape!
      OPTIONS.each { |option| send(option) if options[option] } and return words
    end

    private

      def show_fraction
        words << " i #{fraction}/100"
      end

      def squeeze
        words.delete!(' ')
      end

      def bald
        words.tr!('čćšđž', 'ccsdz')
      end
  end

  class Amount
    attr_reader :amount

    MAX_AMOUNT_SIZE = 12
    BASES     = [Hundred, Ten, One]
    SUFFIXES  = [Thousand, Milion, Bilion]

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
