class MessagesController < ApplicationController
  before_action :load_conversation_and_messages

  def index
    @message = @conversation.messages.new
  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation), notice: t('messages.sent', model: Message.model_name.human)
    else
      render :index
    end
  end

  private

  def load_conversation_and_messages
    @conversation = Conversation.find_by(id: params[:conversation_id])

    @messages = @conversation.messages.order(created_at: :desc)
    if @messages.length > 10
      @over_ten = true
      @messages = @messages.limit(10)
    end
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages.where.not(body: nil)
    end
    if @messages
      @messages.where.not(user: current_user).update_all(read: true)
    end
  end

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
