[User, Client].each do |klass|
  klass.class_eval do
    cattr_accessor :last_created
    after_create do
      self.class.last_created = self
    end
  end
end
