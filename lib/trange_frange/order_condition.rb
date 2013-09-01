# -*- coding: utf-8 -*-

module TrangeFrange
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
end