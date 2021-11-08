module Types
  module CustomTypes
    class BinaryType < Types::BaseScalar
      description "A valid Binary, transported as a string"

      def self.coerce_result(ruby_value, context)
        ruby_value.force_encoding("UTF-8")
      end
    end
  end
end
