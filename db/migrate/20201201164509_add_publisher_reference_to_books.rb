class AddPublisherReferenceToBooks < ActiveRecord::Migration[6.0]
  def change
    add_reference :books, :publisher, null: true, foreign_key: true
  end
end
