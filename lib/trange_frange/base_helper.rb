# -*- coding: utf-8 -*-

module TrangeFrange
  module BaseHelper
    private

      def object_base
        @object_base ||= TrangeFrange::Base.new base
      end

      def order_condition
        @order_condition ||= TrangeFrange::OrderCondition.new
      end
  end
end