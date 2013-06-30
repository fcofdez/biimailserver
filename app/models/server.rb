class Server

  def initialize
    $repository.register(:emails, Repositories::Databases::Documents.new)
    $repository.register(:user_email_references, Repositories::Databases::RedisReferences.new)
  end

  def send(email)
    id = $repository.for(:emails).save(email)
    email.email_id = id

    email.receivers.each do |receiver|
      $repository.for(:user_email_references).update(receiver, email.email_id)
    end
  end

  def delete_old_mails
    older_date = Time.new(Date.today.year, Date.today.month - 3, Date.today.day)
    $repository.for(:emails).outdated_emails(older_date).each do |email|
      delete_email(email)
    end
  end

  def fetch(receiver, email_id)
    email = $repository.for(:emails).find_by_id(email_id)
    $repository.for(:user_email_references).delete_reference(receiver, email_id)
    email.download!
    $repository.for(:emails).update_counter(email)
    $repository.for(:emails).delete(email) if email.all_users_downloaded?
    email
  end

  def has_new_mail?(receiver)
    $repository.for(:user_email_references).find_by_email(receiver).length > 0
  end

  def new_mails(receiver)
    $repository.for(:user_email_references).find_by_email(receiver)
  end

  private

  def delete_email(email)
    email.receivers.each do |receiver|
      $repository.for(:user_email_references).delete_reference(receiver, email.email_id)
    end
    $repository.for(:emails).delete(email)
  end
end
