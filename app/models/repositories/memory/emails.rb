module Repositories
  module Memory

    class Emails
      def initialize
        @records = {}
      end

      def save(email)
        @records[email.email_id] = email
        email.email_id
      end

      def each
        @records.each do |key, value|
          yield value
        end
      end

      def outdated_emails(older_date)
        @records.select do |key, email|
          email.date <= older_date
        end.values
      end

      def delete(email)
        @records.delete(email.email_id)
      end

      def find_by_id(id)
        @records[id]
      end
    end

  end
end
