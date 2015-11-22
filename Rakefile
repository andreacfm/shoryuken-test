require 'aws-sdk'
require 'pry'

namespace :sqs do
  desc 'Craete an sqs queue'
  task :create, [:queue] do |_task, args|
    queue = sqs_client.create_queue(queue_name: args[:queue])
    puts ' >> Created queue'
    puts " - #{queue.queue_url}"
  end

  desc 'List sqs queues'
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

  desc 'Drop an sqs queue'
  task :drop, [:queue] do |_task, args|
    puts " >> Deleting queue #{args[:queue]} [#{queue_url(queue)}]"
    sqs_client.delete_queue({ queue_url: queue_url(queue) })
    puts ' - Done!'
  end

  desc 'Send a messag to a sqs queue'
  task :send_message, [:queue, :message] do |_task, args|
    puts " >> Sending message to queue #{args[:queue]} [#{queue_url(args[:queue])}]"
    resp = sqs_client.send_message({
                                     queue_url: queue_url(args[:queue]), # required
                                     message_body: args[:message]
                                   })
    puts " - #{resp.message_id}"
  end
end

namespace :sns do
  desc 'Craete an sns topic'
  task :create, [:topic] do |_task, args|
    resp = sns_client.create_topic({ name: args[:topic] })
    puts ' >> Created topic'
    puts " - #{resp.topic_arn}"
  end

  desc 'Drop an sns topic'
  task :drop, [:topic] do |_task, args|
    resp = sns_client.delete_topic({ topic_arn: topic_arn(args[:topic]) })
    puts " >> Deleted topic [#{args[:topic]}]"
  end

  desc 'List sns topics'
  task :list do
    resp = sns_client.list_topics
    puts ' >> Listing topics'
    resp.topics.each_with_index { |topic, index| puts " #{index + 1} - #{topic.topic_arn}" }
  end

  desc 'Subscribe to topic'
  task :subscribe, [:topic, :queue] do |_task, args|
    resp = sns_client.subscribe({
                                  topic_arn: topic_arn(args[:topic]),
                                  protocol: 'sqs',
                                  endpoint: queue_arn(args[:queue])
                                })
    puts " >> Subscribtion ARN - #{resp.subscription_arn}"

    policy =  <<-POLICY
      {
        "Version":"2012-10-17",
        "Statement":[
          {
            "Sid":"MySQSPolicy001",
            "Effect":"Allow",
            "Principal":"*",
            "Action":"sqs:SendMessage",
            "Resource":"#{queue_arn(args[:queue])}",
            "Condition":{
              "ArnEquals":{
                "aws:SourceArn":"#{topic_arn(args[:topic])}"
              }
            }
          }
        ]
      }
    POLICY
    resp = sqs_client.set_queue_attributes({
                                             queue_url: queue_url(args[:queue]), # required
                                             attributes: {
                                               'Policy' => policy.strip
                                             }
                                           })
  end

  desc 'Publish an sns topic message'
  task :publish, [:topic, :message] do |_task, args|
    resp = sns_client.publish({
                                topic_arn: topic_arn(args[:topic]),
                                message: args[:message], # required
                                message_structure: 'messageStructure'
                              })
    puts " >> Message - #{resp.message_id}"
  end
end

def sqs_client
  @_sqs_client ||= Aws::SQS::Client.new(
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_REGION']
  )
end

def sns_client
  @_sns_client ||= Aws::SNS::Client.new(
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_REGION']
  )
end

def queue_url(queue)
  "https://sqs.#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['ACCOUNT_ID']}/#{queue}"
end

def queue_arn(queue)
  "arn:aws:sqs:#{ENV['AWS_REGION']}:#{ENV['ACCOUNT_ID']}:#{queue}"
end

def topic_arn(topic)
  "arn:aws:sns:#{ENV['AWS_REGION']}:#{ENV['ACCOUNT_ID']}:#{topic}"
end
