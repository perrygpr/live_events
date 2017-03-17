module GuidPrimaryKey

  GUID_REGEX = /^[0-9a-f]{32}$/

  def self.included(model)
    model.class_eval do
      validates :id, :presence => true, :uniqueness => true
      validate :id_cannot_change, :on => :update

      after_initialize :set_primary_key
      self.primary_key = :id
    end
  end

private

  def set_primary_key
    self.id = UUIDTools::UUID.random_create.hexdigest unless id =~ GUID_REGEX
    true
  end

  def id_cannot_change
    errors.add(:id, "cannot change") if id_was != id
  end

end
