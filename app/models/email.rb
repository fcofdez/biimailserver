require 'date'
require 'digest'

class Email

  attr_reader :subject, :content, :receivers, :date, :downloaded_times, :from
  attr_accessor :email_id

  def initialize(from, receivers, subject, content, date = Time.now, email_id = nil, downloaded_times = 0)
    @from = from
    @receivers = receivers
    @subject = subject
    @content = content
    @date = date
    @downloaded_times = downloaded_times
    @email_id = email_id || generate_hash
  end

  def self.new_from_hash(hash)
    receivers = hash["receivers"]
    from = hash["from"]
    subject = hash["subject"]
    content = hash["content"]
    date = hash["date"]
    downloaded_times = hash["downloaded_times"]
    email_id = hash["_id"]
    Email.new(from, receivers, subject, content, date, email_id, downloaded_times)
  end

  def all_users_downloaded?
    @downloaded_times == @receivers.length
  end

  def download!
    @downloaded_times += 1
  end

  def to_hash
    Hash[instance_variables.map { |var| [var[1..-1].to_sym, instance_variable_get(var)] }]
  end

  private

  def generate_hash
    Digest::SHA1.base64digest(@subject + DateTime.now.to_s)
  end
end
