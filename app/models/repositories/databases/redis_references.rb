module Repositories
  module Databases
    class RedisReferences
      def initialize
        @client = Redis.new
      end

      def save(email, reference)
        @client.rpush(email, reference)
      end

      def update(email, reference)
        @client.rpush(email, reference)
      end

      def delete_reference(email, reference)
        @client.lrem email, 1, reference
      end

      def delete(email)
        @client.del(email)
      end

      def find_by_email(email)
        list_length = @client.llen(email)
        @client.lrange(email, 0, list_length - 1).map{ |id| BSON::ObjectId(id) }
      end
    end
  end
end
