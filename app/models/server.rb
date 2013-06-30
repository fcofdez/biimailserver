class Server

  def initialize
    Repository.register(:emails, Repositories::Databases::Documents.new)
    Repository.register(:user_email_references, Repositories::Databases::RedisReferences.new)
  end

  def send(email)
    id = Repository.for(:emails).save(email)
    email.email_id = id

    email.receivers.each do |receiver|
      Repository.for(:user_email_references).update(receiver, email.email_id)
    end
  end

  def delete_old_mails
    older_date = Time.new(Date.today.year, Date.today.month - 3, Date.today.day)
    Repository.for(:emails).outdated_emails(older_date).each do |email|
      delete_email(email)
    end
  end

  def fetch(receiver, email_id)
    email = Repository.for(:emails).find_by_id(email_id)
    Repository.for(:user_email_references).delete_reference(receiver, email_id)
    email.download!
    Repository.for(:emails).update_counter(email)
    Repository.for(:emails).delete(email) if email.all_users_downloaded?
    email
  end

  def has_new_mail?(receiver)
    Repository.for(:user_email_references).find_by_email(receiver).length > 0
  end

  def new_mails(receiver)
    Repository.for(:user_email_references).find_by_email(receiver)
  end

  private

  def delete_email(email)
    email.receivers.each do |receiver|
      Repository.for(:user_email_references).delete_reference(receiver, email.email_id)
    end
    Repository.for(:emails).delete(email)
  end
end
