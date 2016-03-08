module ApplicationRecordTest
  Models = [Authorization, Client, User]

  def self.setup_last_created
    Models.each do |klass|
      klass.class_eval do
        cattr_accessor :last_created
        after_create do
          self.class.last_created = self
        end
      end
    end
  end

  def self.clear_last_created
    Models.each do |klass|
      klass.last_created = nil
    end
  end

  setup_last_created
end
