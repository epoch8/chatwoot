class SearchService
  pattr_initialize [:current_user!, :current_account!, :params!, :search_type!]

  def perform
    case search_type
    when 'Message'
      { messages: filter_messages, messages_count:  count_filter_messages }
    when 'Conversation'
      { conversations: filter_conversations, conversations_count: count_filter_conversation }
    when 'Contact'
      { contacts: filter_contacts, contacts_count: count_filter_contacts }
    else
      {
        contacts: filter_contacts,
        messages: filter_messages,
        conversations: filter_conversations,
        messages_count:  count_filter_messages,
        conversations_count: count_filter_conversation,
        contacts_count: count_filter_contacts
      }
    end
  end

  private

  def accessable_inbox_ids
    @accessable_inbox_ids ||= @current_user.assigned_inboxes.pluck(:id)
  end

  def search_query
    @search_query ||= params[:q].to_s.strip
  end

  def count_filter_conversation
    @conversations_count = current_account.conversations.where(inbox_id: accessable_inbox_ids)
                                    .joins('INNER JOIN contacts ON conversations.contact_id = contacts.id')
                                    .where("cast(conversations.display_id as text) ILIKE :search OR contacts.name ILIKE :search OR contacts.email
                            ILIKE :search OR contacts.phone_number ILIKE :search OR contacts.identifier ILIKE :search", search: "%#{search_query}%").count
  end

  def filter_conversations
    offset = params[:offset].to_i - 10
    @conversations = current_account.conversations.where(inbox_id: accessable_inbox_ids)
                                    .joins('INNER JOIN contacts ON conversations.contact_id = contacts.id')
                                    .where("cast(conversations.display_id as text) ILIKE :search OR contacts.name ILIKE :search OR contacts.email
                            ILIKE :search OR contacts.phone_number ILIKE :search OR contacts.identifier ILIKE :search", search: "%#{search_query}%")
                                    .order('conversations.created_at DESC')
                                    .offset(offset)
                                    .limit(10)
  end

  def count_filter_messages
    @messages_count = current_account.messages.where(inbox_id: accessable_inbox_ids)
                              .where('messages.content ILIKE :search', search: "%#{search_query}%")
                              .where('created_at >= ?', 3.months.ago).count
  end

  def filter_messages
    offset = params[:offset].to_i - 10
    @messages = current_account.messages.where(inbox_id: accessable_inbox_ids)
                               .where('messages.content ILIKE :search', search: "%#{search_query}%")
                               .where('created_at >= ?', 3.months.ago)
                               .reorder('created_at DESC')
                               .offset(offset)
                               .limit(10)
  end

  def count_filter_contacts
    @contacts_count = current_account.contacts.where(
      "name ILIKE :search OR email ILIKE :search OR phone_number
      ILIKE :search OR identifier ILIKE :search", search: "%#{search_query}%"
    ).count
  end

  def filter_contacts
    offset = params[:offset].to_i - 10

    @contacts = current_account.contacts.where(
      "name ILIKE :search OR email ILIKE :search OR phone_number
      ILIKE :search OR identifier ILIKE :search", search: "%#{search_query}%"
    ).resolved_contacts.order_on_last_activity_at('desc').offset(offset).limit(10)
  end
end
