class WorkerZap
  include Shoryuken::Worker

  shoryuken_options queue: 'queue_zap', auto_delete: true
  # shoryuken_options queue: ->{ "#{ENV['environment']}_default" }
  # shoryuken_options body_parser: :json
  # shoryuken_options body_parser: ->(sqs_msg){ REXML::Document.new(sqs_msg.body) }
  # shoryuken_options body_parser: JSON

  def perform(sqs_msg, body)
    puts "Worker ZAP - got message => #{body}"
  end
end