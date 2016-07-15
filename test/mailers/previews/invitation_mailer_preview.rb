# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview
  def new_user_invite
    invite = Invite.first
    invite_url = "das_ist_ein_test_pfad"
    InvitationMailer.new_user_invite(invite, invite_url)
  end

  def existing_user_invite
    invite = Invite.new(group: Group.first, sender: User.first, recipient: User.last)
    InvitationMailer.existing_user_invite(invite)
  end
end
