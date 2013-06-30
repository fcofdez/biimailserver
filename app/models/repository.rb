class Repository

  def initialize
    @repositories ||= {}
  end

  def register(type, repository)
    repositories[type] = repository
  end

  def repositories
    @repositories ||= {}
  end

  def for(type)
    repositories[type]
  end
end
