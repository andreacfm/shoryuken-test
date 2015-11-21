require 'aws-sdk'

namespace :sqs do
  def sqs_client
    @sqs ||= Aws::SQS::Client.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION']
    )
  end

  task :create, [:queue] do |_task, args|
    queue = sqs_client.create_queue(queue_name: args[:queue])
    puts ' >> Created queue'
    puts " - #{queue.queue_url}"
  end

  task :list do
    resp = sqs_client.list_queues
    puts ' >> Listing queues'
    resp.queue_urls.each_with_index { |url, index| puts " #{index + 1} - #{url}" }
  end

  task :drop, [:queue] do |_task, args|
    queue = sqs_client.get_queue_url({ queue_name: args[:queue] })
    puts " >> Deleting queue #{args[:queue]} [#{queue.queue_url}]"
    sqs_client.delete_queue({ queue_url: queue.queue_url })
    puts ' - Done!'
  end

  task :send_message, [:queue, :message] do |_task, args|
    queue = sqs_client.get_queue_url({ queue_name: args[:queue] })
    puts " >> Sending message to queue #{args[:queue]} [#{queue.queue_url}]"
    resp = sqs_client.send_message({
      queue_url: queue.queue_url, # required
      message_body: args[:message]
    })
    puts " - #{resp.message_id}"
  end

end

namespace :sns do
  def sns_client
    @sqs ||= Aws::SNS::Client.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION']
    )
  end

  task :create, [:topic] do |task, args|
    resp = sns_client.create_topic({ name: args[:topic] })
    puts ' >> Created topic'
    puts " - #{resp.topic_arn}"
  end

end
