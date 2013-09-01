# -*- coding: utf-8 -*-

module TrangeFrange
  class Shaper < Struct.new :words, :fraction, :options
    OPTIONS = [:bald, :squeeze, :show_fraction]

    def shape!
      OPTIONS.each { |option| send(option) if options[option] } and return words
    end

    private

      def show_fraction
        words << " i #{fraction}/100"
      end

      def squeeze
        words.delete!(' ')
      end

      def bald
        words.tr!('čćšđž', 'ccsdz')
      end
  end
end