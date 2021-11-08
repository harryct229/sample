# frozen_string_literal: true

module Resolvers
  module PromotionCodes
    class PromotionCode < Resolvers::BaseResolver
      type Types::BaseGenericType, null: true
      description 'Returns promotion code'

      argument :promotion_code, ID, required: true

      def resolve(promotion_code:)
        if promotion_code.present?
          begin
            promotion_codes = Stripe::PromotionCode.list({
              code: promotion_code,
            })
            return {
              errors: [],
              success: true,
              data: promotion_codes.data[0],
            }
          rescue Exception => e
            return {
              errors: [
                { 
                  message: e.message,
                }
              ],
              success: false,
              data: nil,
            }
          end
        end

        return {
          errors: [
            { 
              message: "Invalid promotion code!",
            }
          ],
          success: false,
          data: nil,
        }
      end
    end
  end
end
