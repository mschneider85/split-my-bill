class InvitesController < AuthenticateController
  def create
    @invite = Invite.new(invite_params)
    @invite.sender_id = current_user.id
    if @invite.save
      if @invite.recipient.present?
        InvitationMailer.existing_user_invite(@invite).deliver_now
        @invite.recipient.groups.push(@invite.group)
      else
        InvitationMailer.new_user_invite(@invite, new_user_registration_path(invite_token: @invite.token, invite_email: @invite.email)).deliver_now
      end
    else
      redirect_to group_path(@invite.group), alert: t('messages.not_found', model: Group.model_name.human(count: 1))
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:email, :group_id)
  end
end
