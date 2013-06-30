require 'mongo'
module Repositories
  module Databases

    class Documents
      def initialize(db = "emails", collection = "emails")
        @client = Mongo::MongoClient.new
        get_connection
        @records = @db_connection.db(db).collection(collection)
      end

      def get_connection
        return @db_connection if @db_connection
        db = URI.parse(ENV['MONGOHQ_URL'])
        db_name = db.path.gsub(/^\//, '')
        @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
        @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
        @db_connection
      end

      def save(email)
        @records.insert(email.to_hash)
      end

      def each
        @records.find.each do |value|
          yield Email.new_from_hash(value)
        end
      end

      def outdated_emails(date)
        @records.find("date" => {"$lte" => date}).to_a.map { |email| Email.new_from_hash(email) }
      end

      def delete(email)
        @records.remove("_id" => email.email_id)
      end

      def update_counter(email)
        counter = { "downloaded_times" => email.downloaded_times}
        @records.update({"_id" => email.email_id}, {"$set" => counter})
      end

      def find_by_id(id)
        Email.new_from_hash(@records.find("_id" => id).to_a[0])
      end
    end

  end
end
