class EntriesController < AuthenticateController
  before_action :load_group, except: :destroy
  def index
    @entries = @group.entries.all.order(created_at: :desc)
  end

  def new
    @entry = @group.entries.new(entry_type: params[:entry_type], user_ids: params[:user_ids], amount: params[:amount])
    render layout: false
  end

  def create
    @entry = @group.entries.new(entry_params)
    @users = User.where(id: params[:entry][:user_ids].reject(&:blank?))
    @quotient = @users.count

    splitted_amount = 0.0

    @users.without(current_user).each do |user|
      current_amount = ((100.0*@entry.amount.to_d/@quotient).to_f.ceil)/100.0
      @entry.transactions.build(amount: current_amount, creditor: current_user, debtor: user)
      splitted_amount += current_amount
    end

    if @users.find_by(id: current_user)
      @entry.transactions.build(amount: (@entry.amount.to_f)-splitted_amount, creditor: current_user, debtor: current_user)
    end
    if @entry.save
      @flash = { "notice" => "Buchung erstellt." }
      case @entry.entry_type
      when 'redemption'
        @entry.create_activity key: 'entry.create_redemption', owner: current_user
      else
        @entry.create_activity key: 'entry.create', owner: current_user
      end
    end
  end

  def destroy
    @entry = Entry.find_by(id: params[:id])
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to group_path(@entry.group), notice: t('messages.deleted', model: @entry.name) }
      format.json { head :no_content }
      format.js   { render layout: false }
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:name, :entry_type, :amount, :currency, user_ids: [], transactions_attributes: [:amount, :creditor, :debtor])
  end

  def load_group
    @group = Group.find_by(id: params[:group_id])
  end
end
