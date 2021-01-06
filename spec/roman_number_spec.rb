require_relative '../roman_number'

describe RomanNumber do
  describe '#to_decimal' do
    it 'converts example MMVI correctly' do
      roman_number = RomanNumber.new('MMVI')
      expect(roman_number.to_decimal).to eq(2006)
    end

    it 'converts example MCMXLIV correctly' do
      roman_number = RomanNumber.new('MCMXLIV')
      expect(roman_number.to_decimal).to eq(1944)
    end

    it 'parses example MCMIII correctly' do
      roman_number = RomanNumber.new('MCMIII')
      expect(roman_number.to_decimal).to eq(1903)
    end

    it 'raises an exception for too many repetitions' do
      roman_number = RomanNumber.new('MCMIIII')
      expect { roman_number.to_decimal }.to raise_error('I cannot be repeated more than 3 times')
    end

    it 'raises an exception if preceeding number cannot be substracted' do
      roman_number = RomanNumber.new('MLMIII')
      expect { roman_number.to_decimal }.to raise_error('L cannot be substracted from M')
    end

    it 'returns 0 for an empty string' do
      roman_number = RomanNumber.new('')
      expect(roman_number.to_decimal).to eq(0)
    end
  end
end
