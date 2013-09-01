# -*- coding: utf-8 -*-

module TrangeFrange
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
end