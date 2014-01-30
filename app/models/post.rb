class Post < ActiveRecord::Base
  validates :body, :presence => true
  validates :title, :presence => true

  has_many :relations
  has_many :tags, through: :relations


end
