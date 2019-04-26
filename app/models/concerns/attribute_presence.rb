module AttributePresence
  extend ActiveSupport::Concern

  def any_attribute_present?
    attribute_names_for_presence.any? do |attribute_name|
      send(attribute_name).present?
    end
  end

  private

  def attribute_names_for_presence
    (attribute_names - %w[id type created_at updated_at]).reject do |name|
      name.ends_with?('_id')
    end
  end
end
