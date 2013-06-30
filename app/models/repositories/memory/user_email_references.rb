module Repositories
  module Memory
    class UserEmailReferences
      def initialize
        @records = Hash.new([])
      end

      def save(email, reference)
        @records[email] = reference
        email
      end

      def update(email, new_reference)
        @records[email] = [] if @records[email] == []
        @records[email] << new_reference
      end

      def delete_reference(email, reference)
        @records[email].delete(reference)
      end

      def delete(email)
        @records.delete email
      end

      def find_by_email(email)
        @records[email]
      end
    end
  end
end
