class ConversationsController < AuthenticateController
  authorize_resource

  def index
    @users = current_user.friends
    @conversations = Conversation.where.any_of(sender: current_user, recipient: current_user)
  end

  def create
    @conversation = FindOrCreateConversation.call(params[:sender_id], params[:recipient_id])
    redirect_to conversation_messages_path(@conversation)
  end
end
