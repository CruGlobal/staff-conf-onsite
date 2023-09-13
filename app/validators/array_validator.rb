class ArrayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    return if values.blank?
    
    return record.errors.add(:attribute, 'is not an array') unless values.is_a?(Array)

    invalid_values = values.reject { |value| options[:collection].include?(value) }

    return if invalid_values.empty?

    record.errors.add(:attribute, "does not accept #{invalid_values.to_sentence}")
  end
end
