# encoding: utf-8

module TrangeFrange
  class Milion < Struct.new :base
    include TrangeFrange::SuffixHelper

    MILIONS = %w[milion miliona]

    def word
      order_condition.add { MILIONS[0] if suffix.one? and !suffix.suffix_base.teen? }
      order_condition.add { MILIONS[1] }
      order_condition.match!
    end
  end
end