class Book < ApplicationRecord
    has_and_belongs_to_many :category
    belongs_to :publisher
end
