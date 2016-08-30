class EntriesController < AuthenticateController
  before_action :load_group, except: :destroy
  authorize_resource

  def index
    @entries = @group.entries.all.order(created_at: :desc)
  end

  def new
    @entry = @group.entries.new(entry_type: params[:entry_type], user_ids: params[:user_ids], amount: params[:amount])
    render layout: false
  end

  def create
    @entry = CreateEntry.call(current_user, params[:entry][:user_ids], @group.entries.new(entry_params))
    if @entry.valid?
      @flash = { "notice" => "Buchung erstellt." }
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
