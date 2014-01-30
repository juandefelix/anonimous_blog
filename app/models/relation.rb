class Relation < ActiveRecord::Base
  validates :name, uniqueness: true
end
