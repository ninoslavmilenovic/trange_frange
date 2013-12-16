# encoding: utf-8

module TrangeFrange
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
end