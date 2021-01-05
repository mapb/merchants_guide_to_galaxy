require_relative '../roman_digit'
require 'pry'

describe RomanDigit do
  let(:roman_digit) { RomanDigit.new('I') }

  describe '#initialize' do
    it 'sets up values from rules' do
      expect(roman_digit.value).to eq(1)
      expect(roman_digit.repetitions).to eq(3)
      expect(roman_digit.substractable_from).to eq(['V', 'X'])
      expect(roman_digit.digit_string).to eq('I')
    end

    it 'raises an exception if roman digit is unknown' do
      expect { RomanDigit.new('A') }.to raise_error('Unknown Roman digit')
    end
  end
end
