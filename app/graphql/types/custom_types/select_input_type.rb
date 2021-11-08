module Types
  module CustomTypes
    class SelectInputType < Types::BaseInputObject
      argument :id, ID, 'ID', required: true
      argument :name, String, 'Name', required: false
    end
  end
end
