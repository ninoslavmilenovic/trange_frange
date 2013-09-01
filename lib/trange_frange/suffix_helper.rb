# -*- coding: utf-8 -*-

module TrangeFrange
  module SuffixHelper
    private

      def suffix
        @suffix ||= TrangeFrange::Suffix.new base
      end

      def order_condition
        @order_condition ||= TrangeFrange::OrderCondition.new
      end
  end
end