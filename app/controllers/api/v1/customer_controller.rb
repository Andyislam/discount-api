# frozen_string_literal: true

module Api
  module V1
    class CustomerController < ApplicationController
      def transaction_total
        run Api::V1::Customer::Operation::TransactionTotal
    	render json: {customer: result['model'], charges: result['charges'], discounts: result['discounts']}
      end
    end
  end
end
