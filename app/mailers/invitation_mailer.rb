class InvitationMailer < ApplicationMailer
  def new_user_invite(invite, invite_url)
    @invite = invite
    @invite_url = invite_url
    mail(to: @invite.email, subject: "SplitMyBill Gruppeneinladung")
  end

  def existing_user_invite(invite)
    @invite = invite
    mail(to: @invite.email, subject: "SplitMyBill Gruppeneinladung")
  end
end
