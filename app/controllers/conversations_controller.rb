class ConversationsController < AuthenticateController
  authorize_resource

  def index
    @users = current_user.friends
    @conversations = Conversation.where.any_of(sender: current_user, recipient: current_user)
  end

  def create
    sender = params[:sender_id]
    recipient = params[:recipient_id]

    if Conversation.between(sender, recipient).present?
      @conversation = Conversation.between(sender, recipient).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    redirect_to conversation_messages_path(@conversation)
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
