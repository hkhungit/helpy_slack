class SlackJob < ActiveJob::Base
  
  def perform(post, options = {})
    # Assemble message
    url = "#{AppSettings['settings.site_url']}#{Rails.application.routes.url_helpers.admin_topic_path(post.topic.id)}"
    title = "New Topic started by #{post.topic.user.name}"
    message = {
      title: "<#{url}|#{post.topic.name}>",
      text: post.body,
      color: '#eee'
    }
    message.merge!(options) if options.is_a?(::Hash)

    # Send Ping
    notifier = Slack::Notifier.new AppSettings['slack.post_url']
    notifier.username = "HelpyBot"
    notifier.ping title, attachments: [message], channel: AppSettings['slack.default_channel']
  end
end
