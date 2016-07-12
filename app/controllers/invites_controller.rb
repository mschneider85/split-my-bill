class InvitesController < AuthenticateController
  before_action :load_invite, only: [:accept, :decline]

  def index
    @invites = current_user.invitations.pending
  end

  def show
  end

  def create
    @invite = Invite.new(invite_params)
    @invite.sender_id = current_user.id
    if @invite.save
      if @invite.recipient.present?
        InvitationMailer.existing_user_invite(@invite).deliver_now
      else
        InvitationMailer.new_user_invite(@invite, new_user_registration_path(invite_token: @invite.token, invite_email: @invite.email)).deliver_now
      end
      @flash = { "notice" => "Einladung verschickt." }
      @invite.create_activity key: 'invite.create', owner: current_user
    else
      redirect_to group_path(@invite.group), alert: t('messages.not_found', model: Group.model_name.human(count: 1))
    end
  end

  def accept
    @invite.accept!
    if @invite.recipient.group_ids.exclude? @invite.group.id
      @invite.recipient.groups.push(@invite.group)
      @invite.create_activity key: 'invite.accept', owner: current_user
    end
  end

  def decline
    @invite.decline!
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
end
