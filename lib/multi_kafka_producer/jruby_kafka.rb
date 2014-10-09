module MultiKafkaProducer
  class Kafka < AbstractAdapter
    adapter_name :jruby-kafka

    def connected?
      !!@connection
    end

    def connect(client_id, *brokers)
      @connection = Kafka::Producer.new({broker_list: brokers,
                                         client_id: client_id})
      @connection.connect
      @connection
    end

    def publish(topic, msgs_and_keys)
      msgs.each do |msg|
        key, msg = split_msg_pair(msg)
        @connection.send_msg(topic, key, msg)
      end
    rescue FailedToSendMessageException
      raise KafkaNotConnected.new(self)
    end
  end
end
