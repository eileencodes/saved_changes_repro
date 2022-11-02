class Post < ApplicationRecord
  after_update :read_attribute

  typed_store(:field) do |f|
    f.boolean :active, default: false, null: false
  end

  def read_attribute
    active
  end
end
