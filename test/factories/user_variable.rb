FactoryBot.define do
  factory :user_variable do
    value_type { UserVariable.value_types.keys.sample }
    sequence(:short_name) { |n| format('%s_%d', Faker::File.extension, n) }
    code { Faker::Code.asin }
    description { Faker::Lorem.paragraph(sentence_count: rand(1..3)) }

    value do
      case value_type
      when 'string'
        Faker::Lorem.sentence
      when 'money'
        Money.new(Faker::Number.between(from: 0, to: 1000_00))
      when 'date'
        Faker::Date.between(from: 10.years.ago, to: 10.years.from_now)
      when 'number'
        if Faker::Boolean.boolean
          Faker::Number.between(from: -1000, to: 1000)
        else
          Faker::Number.between(from: -1000.0, to: 1000.0)
        end
      else
        raise "no factory for value_type, #{value_type}"
      end
    end
  end
end
