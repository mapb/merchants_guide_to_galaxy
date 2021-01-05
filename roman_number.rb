require './roman_digit'

class RomanNumber
  def initialize(number)
    @digits = number.split('').map { |roman_digit| RomanDigit.new(roman_digit) }
  end

  def to_decimal
    repetitions, preceeding_digit = Hash.new(0), nil

    @digits.reduce(0) do |sum, digit|
      repetitions[digit.digit_string] += 1

      raise "#{digit.digit_string} cannot be repeated more than #{digit.repetitions} times" unless
        digit.repetition_allowed?(current_repetitions: repetitions[digit.digit_string], preceeding_digit: preceeding_digit)

      raise "#{preceeding_digit.digit_string} cannot be substracted from #{digit.digit_string}" if
        (preceeding_digit && preceeding_digit.value < digit.value) && !preceeding_digit.substractable_from?(digit)

      subtractor = preceeding_digit && preceeding_digit.value < digit.value && preceeding_digit.value * 2 || 0
      preceeding_digit = digit

      sum += digit.value - subtractor
    end
  end
end
