class FindOrCreateConversation
  def self.call(sender_id, recipient_id)
    if Conversation.between(sender_id, recipient_id).present?
      @conversation = Conversation.between(sender_id, recipient_id).take
    else
      @conversation = Conversation.create!(sender_id: sender_id, recipient_id: recipient_id)
    end
  end
end
