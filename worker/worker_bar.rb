class WorkerBar
  include Shoryuken::Worker

  shoryuken_options queue: 'queue_bar', auto_delete: true
  # shoryuken_options queue: ->{ "#{ENV['environment']}_default" }
  # shoryuken_options body_parser: :json
  # shoryuken_options body_parser: ->(sqs_msg){ REXML::Document.new(sqs_msg.body) }
  # shoryuken_options body_parser: JSON

  def perform(sqs_msg, body)
    puts "Worker BAR - got message => #{body}"
  end
end