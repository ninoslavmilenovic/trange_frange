# -*- coding: utf-8 -*-

module TrangeFrange
  class Hundred < Struct.new :base
    include TrangeFrange::BaseHelper

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
      order_condition.add { HUNDREDS[object_base.member.hundred] }
      order_condition.match!
    end
  end
end