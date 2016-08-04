class Group < ActiveRecord::Base
  include PublicActivity::Common
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :invites, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :transactions, through: :entries
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :invites, allow_destroy: true

  validates :name, presence: true

  def to_param
    [id, name.parameterize].join("-")
  end

  def admin
    users.order(:created_at).first
  end

  def report
    @group_report ||= GroupReport.new(self)
  end

  def related_activities
    PublicActivity::Activity.where.any_of(
      { trackable_id: comments.ids, trackable_type: 'Comment' },
      { trackable_id: invites.ids, trackable_type: 'Invite' },
      { trackable_id: entries.ids, trackable_type: 'Entry' },
      { trackable_id: id, trackable_type: self.class.name })
      .order(created_at: :desc)
  end
end
