# -*- coding: utf-8 -*-

module TrangeFrange
  class Thousand < Struct.new :base
    include TrangeFrange::SuffixHelper

    THOUSANDS = %w[hiljada hiljade]

    def word
      order_condition.add { THOUSANDS[1] if suffix.gender? and !suffix.suffix_base.teen? }
      order_condition.add { THOUSANDS[0] }
      order_condition.match!
    end
  end
end