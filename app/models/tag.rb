class Tag < ActiveRecord::Base
  # validates :name, :presence => true

  has_many :relations
  has_many :posts, through: :relations
end
