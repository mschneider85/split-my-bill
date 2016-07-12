class Entry < ActiveRecord::Base
  include PublicActivity::Common
  has_many :transactions, dependent: :destroy
  belongs_to :group

  TYPES = %w(expense balance).freeze
  accepts_nested_attributes_for :transactions
  attr_accessor :user_ids

  validate :validate_user_ids
  validates :entry_type, inclusion: { in: TYPES }
  validates :name, presence: true
  monetize :amount_cents, numericality: { greater_than: 0 }

  private

  def validate_user_ids
    errors.add :user_ids, I18n.t('errors.messages.blank') if user_ids.reject(&:blank?).blank?
  end
end
