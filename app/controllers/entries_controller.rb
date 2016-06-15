class EntriesController < AuthenticateController
  before_action :load_group
  def index
    @entries = @group.entries.all.order(created_at: :desc)
  end

  def new
    @entry = @group.entries.new
  end

  def create
    @entry = @group.entries.new(entry_params)
    @users = User.where(id: params[:entry][:user_ids].reject(&:blank?))
    @quotient = @users.count

    splitted_amount = 0

    @users.without(current_user).each do |user|
      current_amount = ((100.0*@entry.amount.to_i/@quotient).ceil)/100.0
      @entry.transactions.build(amount: current_amount, creditor: current_user, debtor: user)
      splitted_amount += current_amount
    end

    if @users.find_by(id: current_user)
      @entry.transactions.build(amount: (@entry.amount.to_i)-splitted_amount, creditor: current_user, debtor: current_user)
    end

    if @entry.save
      redirect_to group_path(@entry.group), notice: t('messages.created', model: Entry.model_name.human(count: 1))
    else
      redirect_to group_path(@entry.group), alert: t('messages.not_found', model: Entry.model_name.human(count: 1))
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:name, :type, :amount, :currency, user_ids: [], transactions_attributes: [:amount, :creditor, :debtor])
  end

  def load_group
    @group = Group.find_by(id: params[:group_id])
  end
end
