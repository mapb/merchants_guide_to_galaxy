require './lib/matcher'
require './roman_number'

class Converter
  PARSE_ERROR_MESSAGE = 'I have no idea what you are talking about'

  def initialize
    @roman_digit_aliases = {} # something like { 'glob' => 'I', 'prok' => 'V' }
    @good_values = {} # something like { 'Silver' => 17 }
  end

  def parse(input)
    parse_roman_number_input(input) || parse_credit_input(input) ||
    parse_number_calculation(input) || parse_credit_calculation(input) ||
    PARSE_ERROR_MESSAGE
  end

  def parse_roman_number_input(input)
    roman_number_input = Matcher::ROMAN_NUMBER_MATCHER.match(input)

    if roman_number_input # 'glob is I'
      number_alias = roman_number_input[1] # 'glob'
      number = roman_number_input[2] # 'I'
      learn_roman_number(number_alias: number_alias, number: number)
      return true
    end

    return false
  end

  def parse_credit_input(input)
    credit_input = Matcher::CREDIT_MATCHER.match(input)

    if credit_input # 'glob glob Silver is 34 Credits'
      amount = credit_input[1] # 'glob glob'
      good = credit_input[2] # 'Silver'
      credit_amount = credit_input[3].to_i # 34

      value = get_value_from_alias_string(amount)
      good_value = credit_amount / value.to_f
      learn_good_value(good: good, value: good_value)
      return true
    end

    return false
  end

  def parse_number_calculation(input)
    number_calculation = Matcher::NUMBER_CALCULATION_MATCHER.match(input)

    if number_calculation # 'how much is pish tegj glob glob ?'
      amount = number_calculation[1] # 'pish tegj glob glob'
      value = get_value_from_alias_string(amount)
      return "#{amount} is #{value}"
    end

    return false
  end

  def parse_credit_calculation(input)
    credit_calculation = Matcher::CREDIT_CALCULATION_MATCHER.match(input)

    if credit_calculation # 'how many Credits is glob prok Silver ?'
      amount = credit_calculation[1] # 'glob prok'
      good = credit_calculation[2] # 'Silver'

      value = get_value_from_alias_string(amount)
      good_value = get_good_value(good)
      total = (value * good_value).to_i
      return "#{amount} #{good} is #{total} Credits"
    end

    return false
  end

  def get_value_from_alias_string(alias_string)
    get_roman_number_from_alias(alias_string).to_decimal
  end

  def get_roman_number_from_alias(alias_amount)
    amount_array = alias_amount.split(' ')

    roman_number_string = amount_array.map do |amount_alias|
      raise 'Amount not defined' unless @roman_digit_aliases.has_key?(amount_alias)
      @roman_digit_aliases[amount_alias]
    end.join

    RomanNumber.new(roman_number_string)
  end

  def get_good_value(good)
    raise 'Unknown good' unless @good_values.has_key?(good)
    @good_values[good]
  end

  def learn_roman_number(number_alias:, number:)
    raise 'Alias already defined' if @roman_digit_aliases.has_key?(number_alias)
    @roman_digit_aliases[number_alias] = number
  end

  def learn_good_value(good:, value:)
    raise "Good value already defined" if @good_values.has_key?(good)
    @good_values[good] = value
  end
end
