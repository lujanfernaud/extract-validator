# Upcase Refactoring Trail

## Extract Validator

Refactoring exercise extracting a [custom validator](http://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations) for the [Upcase Refactoring Trail](https://thoughtbot.com/upcase/refactoring).

### Before

```ruby
# person.rb

class Person
  include ActiveModel::Validations
  PHONE_REGEX = /^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/

  validates :phone_number, format: { with: PHONE_REGEX, multiline: true, message: 'invalid phone number formatting' }

  attr_accessor :phone_number

  def initialize(attributes = {})
    @phone_number = attributes[:phone_number]
  end
end
```

### After

```ruby
# person.rb

class Person
  include ActiveModel::Validations

  validates :phone_number, presence: true, phone_number_format: true

  attr_accessor :phone_number

  def initialize(attributes = {})
    @phone_number = attributes[:phone_number]
  end
end
```

```ruby
# phone_number_format_validator.rb

class PhoneNumberFormatValidator < ActiveModel::EachValidator
  PHONE_REGEX = /^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/

  def validate_each(record, attribute, value)
    unless value =~ PHONE_REGEX
      record.errors[attribute] << error_message
    end
  end

  private

  def error_message
    options[:message] || 'invalid phone number formatting'
  end
end
```
