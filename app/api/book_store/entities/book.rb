module BookStore
    module Entities
        class Book < Grape::Entity
            expose :id
            expose :title
            expose :description
            expose :page_count
            expose :publisher_id
            expose :created_at
            expose :updated_at
            expose :publisher, with: BookStore::Entities::Publisher
            expose :category, with: BookStore::Entities::Category, as: :categories
        end
    end
end
