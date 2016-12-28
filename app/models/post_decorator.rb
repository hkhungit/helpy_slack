Post.class_eval do

  after_commit :ping_slack

#  protected

  def ping_slack
    # return false unless self.kind == 'first' # Only ping for new topics

    # Actually fire the ping, split for private/public topics
    options = {
      topic_id: topic.id,
      keymono_chat_id: topic.keymono_chat_id,
      keymono_message_id: topic.keymono_message_id
    }

    if self.topic.forum.private?
      send_ping(self, options) if AppSettings['slack.ping_private_topics'] == '1'
    else
      send_ping(self, options) if AppSettings['slack.ping_public_topics'] == '1'
    end
  end

  def send_ping(post, options = {})
    SlackJob.perform_later post, options
  end

end
