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
    resp.queue_urls.each_with_index do |url, index|
      resp = sqs_client.get_queue_attributes({
        queue_url: url,
        attribute_names: ['QueueArn']
      })
      puts " #{index + 1} - URL -> #{url}"
      puts "     ARN -> #{resp.attributes['QueueArn']}"
    end
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

  task :drop, [:topic_arn] do |task, args|
    resp = sns_client.delete_topic({ topic_arn: args[:topic_arn] })
    puts " >> Deleted topic [#{args[:topic_arn]}]"
  end

  task :list do
    resp = sns_client.list_topics
    puts ' >> Listing topics'
    resp.topics.each_with_index { |topic, index| puts " #{index + 1} - #{topic.topic_arn}" }
  end

  task :subscribe, [:topic_arn, :queue_arn] do |task,args|
    resp = sns_client.subscribe({
      topic_arn: args[:topic_arn],
      protocol: "sqs",
      endpoint: args[:queue_arn],
    })
    puts " >> Subscribtion ARN - #{resp.subscription_arn}"
  end

end
