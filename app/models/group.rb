class Group < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :invites
  has_many :entries

  accepts_nested_attributes_for :invites, allow_destroy: true

  validates :name, presence: true

  def to_param
    [id, name.parameterize].join("-")
  end
end
