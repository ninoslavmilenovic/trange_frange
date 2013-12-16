# encoding: utf-8

module TrangeFrange
  class One < Struct.new :base, :magnitude
    include TrangeFrange::BaseHelper
    
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
      order_condition.add { String.new if object_base.teen? }
      order_condition.add { ONES[object_base.member.one][gender] if object_base.gender? }
      order_condition.add { ONES[object_base.member.one] }
      order_condition.match!
    end

    private

      def gender
        magnitude.odd? ? :f : :m
      end
  end
end