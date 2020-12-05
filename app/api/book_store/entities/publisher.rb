module BookStore
    module Entities
        class Publisher < Grape::Entity
            expose :id
            expose :name
        end
    end
end