class Group < ActiveRecord::Base
  include PublicActivity::Common
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :invites, dependent: :destroy
  has_many :entries, dependent: :destroy

  accepts_nested_attributes_for :invites, allow_destroy: true

  validates :name, presence: true

  def to_param
    [id, name.parameterize].join("-")
  end

  def report
    GroupReport.new(self)
  end
end
