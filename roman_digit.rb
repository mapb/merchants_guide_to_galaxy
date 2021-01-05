require 'yaml'

class RomanDigit
  attr_reader :digit_string, :value, :repetitions, :substractable_from

  ROMAN_DIGITS = YAML.load_file('./lib/roman_digits.yml')

  def initialize(digit_string)
    roman_digit = ROMAN_DIGITS[digit_string]
    raise 'Unknown Roman digit' unless roman_digit

    @digit_string = digit_string
    @value, @repetitions, @substractable_from = roman_digit[:value], roman_digit[:repetitions], roman_digit[:substractable_from]
  end

  def repetition_allowed?(current_repetitions:, preceeding_digit:)
    return false if current_repetitions > @repetitions && preceeding_digit.digit_string == @digit_string
    return false if current_repetitions > @repetitions + 1
    return true
  end

  def substractable_from?(preceeding_digit)
    return true unless preceeding_digit
    return true if preceeding_digit.digit_string == @digit_string
    @substractable_from.include?(preceeding_digit.digit_string) ? true : false
  end
end
