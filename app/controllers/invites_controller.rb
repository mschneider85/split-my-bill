class InvitesController < AuthenticateController
  before_action :load_invite, only: [:accept, :decline]
  before_action :load_invites, only: [:index, :accept, :decline]
  authorize_resource

  def index
  end

  def show
  end

  def new
    @group = Group.find_by(id: params[:group_id])
    @invite = @group.invites.new
    render layout: false
  end

  def create
    @group = Group.find_by(id: params[:invite][:group_id])
    @invite = InviteUser.call(@group.invites.new(invite_params), current_user)
    if @invite.valid?
      @flash = { "notice" => "Einladung verschickt." }
    end
  end

  def accept
    @invites.where(group: @invite.group).map(&:accept!)
    if @invite.recipient.group_ids.exclude? @invite.group_id
      @invite.recipient.groups.push(@invite.group)
      @invite.create_activity key: 'invite.accept', owner: current_user
    end
  end

  def decline
    @invites.where(group: @invite.group).map(&:decline!)
    if @invite.recipient.group_ids.exclude? @invite.group.id
      @invite.create_activity key: 'invite.decline', owner: current_user
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:email, :group_id)
  end

  def load_invite
    @invite = Invite.find(params[:id])
  end

  def load_invites
    @invites = current_user.invitations.pending
  end
end
