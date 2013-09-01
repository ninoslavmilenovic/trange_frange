# -*- coding: utf-8 -*-

module TrangeFrange
  class Ten < Struct.new :base
    include TrangeFrange::BaseHelper
    
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
      order_condition.add { TENS[teen_base_member] if object_base.teen? }
      order_condition.add { TENS[object_base.member.ten] }
      order_condition.match!
    end

    private

      def teen_base_member
        object_base.member.ten + object_base.member.one
      end
  end
end