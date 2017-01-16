class Entry < ActiveRecord::Base
  include PublicActivity::Common
  has_many :transactions, dependent: :destroy
  belongs_to :group, touch: true

  TYPES = %w(expense redemption).freeze
  accepts_nested_attributes_for :transactions
  attr_accessor :user_ids

  validate :validate_user_ids
  validates :entry_type, inclusion: { in: TYPES }
  validates :name, presence: true
  monetize :amount_cents, numericality: { greater_than: 0 }

  def beneficiary
    User.find_by(id: user_ids) if user_ids && entry_type == 'redemption' && user_ids.size == 1
  end

  def creditor
    transactions.take.creditor
  end

  def creditor_names
    transactions.select(:creditor_id).distinct.map { |transaction| transaction.creditor.name }
  end

  def debtor_names
    transactions.select(:debtor_id).distinct.map { |transaction| transaction.debtor.name }
  end

  private

  def validate_user_ids
    errors.add :user_ids, I18n.t('errors.messages.blank') if !user_ids || user_ids.reject(&:blank?).blank?
  end
end
