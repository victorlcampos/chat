class StreamSubscriptionService
  def initialize
    @redis = Redis.new
  end

  def subscribe(sse, channel)
    @redis.subscribe(channel) do |on|
      on.message do |event, data|
        sse.write(data, event: channel)
      end
    end
  end

  def publish(channel, json)
    @redis.publish(channel, json)
    @redis.quit
  end

  def quit
    @redis.quit
  end
end