class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  has_many :invites

  accepts_nested_attributes_for :invites, allow_destroy: true
end
