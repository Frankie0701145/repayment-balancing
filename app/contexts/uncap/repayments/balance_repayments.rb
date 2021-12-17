# frozen_string_literal: true

module Uncap
  module Repayment
    module UseCases
      class BalanceRepayments
        # NOTE: This method MUTATES the repayments objects!
        def call(repayments:, date_received:, amount_received_from_payment:)
          balance_repayments!(repayments, date_received, amount_received_from_payment)
        end

        private

        def balance_repayments!(repayments, date_received, amount_received_from_payment)
          # YOUR CODE HERE
          balancing_amount = amount_received_from_payment
          # return the repayments
          repayments.map.with_index do |repayment, index|
            # return the repayment unchanged if the balancing amount is zero
            return repayment if balancing_amount.zero?

            # if it is the last repayment
            if index + 1 == repayments.size
              # add the whole of the balancing amount to the last
              repayment[:amount_received] += balancing_amount
            else
              # if it is not the last repayment
              # get the difference between the amount and amount_received to determine the differential
              # if the amount is more than the amount_received the balance will be positive.
              # This is the repayment balance.
              balance = repayment[:amount] - repayment[:amount_received]
              # minus the balance amount from the balancing_amount and then add the balance
              # to the amount_received.
              # When the balance is positive that means the amount_received is short so we will
              # reduce the balancing_amount and add the reduced amount to the amount_received
              # When the balance is negative that means the amount_received is more so we will
              # increase the balancing_amount and reduce the amount_receive
              # minus the balance from the balancing_amount
              balancing_amount -= balance
              # add the balance to the amount_received
              repayment[:amount_received] += balance
              # repayment[:date_received] = date_received # I am not sure if I am supposed to change the date_received
              # return the repayment
              repayment
            end
          end
        end
      end
    end
  end
end
