# encoding: utf-8

module TrangeFrange
  class Bilion < Struct.new :base
    include TrangeFrange::SuffixHelper
    
    BILIONS = %w[milijarda milijarde milijardi]

    def word
      order_condition.add { BILIONS[0] if suffix.one? and !suffix.suffix_base.teen? }
      order_condition.add { BILIONS[1] if suffix.gender? and !suffix.suffix_base.teen? }
      order_condition.add { BILIONS[2] }
      order_condition.match!
    end
  end
end