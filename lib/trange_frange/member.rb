# encoding: utf-8

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
end