class InviteUser
  def self.call(invite, sender)
    invite.sender_id = sender.id
    if invite.save
      if invite.recipient.present?
        InvitationMailer.existing_user_invite(invite).deliver_now
      else
        InvitationMailer.new_user_invite(invite, Rails.application.routes.url_helpers.new_user_registration_path(invite_token: invite.token, invite_email: invite.email)).deliver_now
      end
      invite.create_activity key: 'invite.create', owner: sender
    end
    invite
  end
end
