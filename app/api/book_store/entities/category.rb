module BookStore
    module Entities
        class Category < Grape::Entity
            expose :id
            expose :name
        end
    end
end
