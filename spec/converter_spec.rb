require_relative '../converter'

RSpec.describe Converter do
  let(:converter) { Converter.new }

  describe '#get_roman_number_from_alias' do
    it 'returns a roman number for an alias' do
      converter.instance_variable_set('@roman_digit_aliases', { 'glob' => 'I', 'prok' => 'V' })
      result = converter.get_roman_number_from_alias('glob prok')
      expect(result.class).to eq(RomanNumber)
      expect(result.to_decimal).to eq(4)
    end

    it 'raises error if amount is not defined' do
      expect { converter.get_roman_number_from_alias('glob prok') }.to raise_error('Amount not defined')
    end
  end

  describe '#parse_roman_number_input' do
    it 'parses roman number input' do
      expect(converter).to receive(:learn_roman_number).with(number_alias: 'glob', number: 'I')
      converter.parse_roman_number_input('glob is I')
    end

    it 'returns false for unknown input' do
      result = converter.parse_roman_number_input('something unknown')
      expect(result).to eq(false)
    end
  end

  describe '#parse_credit_input' do
    before(:each) { allow(converter).to receive(:get_value_from_alias_string).with('glob glob') { 2 } }

    it 'parses credit input' do
      expect(converter).to receive(:learn_good_value).with(good: 'Silver', value: 17.0)
      converter.parse_credit_input('glob glob Silver is 34 Credits')
    end

    it 'returns false for unknown input' do
      result = converter.parse_credit_input('something unknown')
      expect(result).to eq(false)
    end
  end

  describe '#parse_number_calculation' do
    before(:each) { allow(converter).to receive(:get_value_from_alias_string).with('pish tegj glob glob') { 42 } }

    it 'parses returns calculated number' do
      result = converter.parse_number_calculation('how much is pish tegj glob glob ?')
      expect(result).to eq('pish tegj glob glob is 42')
    end

    it 'returns false for unknown input' do
      result = converter.parse_credit_input('something unknown')
      expect(result).to eq(false)
    end
  end

  describe '#parse_credit_calculation' do
    before(:each) { allow(converter).to receive(:get_value_from_alias_string).with('glob prok') { 4 } }
    before(:each) { allow(converter).to receive(:get_good_value).with('Silver') { 17 } }

    it 'returns number of credits' do
      result = converter.parse_credit_calculation('how many Credits is glob prok Silver ?')
      expect(result).to eq('glob prok Silver is 68 Credits')
    end

    it 'returns false for unknown input' do
      result = converter.parse_credit_calculation('something unknown')
      expect(result).to eq(false)
    end
  end

  describe '#parse' do
    it 'parses input for learning numbers' do
      parsed_input = converter.parse('glob is I')
      roman_digit_aliases = converter.instance_variable_get('@roman_digit_aliases')
      expect(roman_digit_aliases).to eq({ 'glob' => 'I' })
    end

    context 'with defined aliases' do
      before(:each) do
        converter.learn_roman_number(number_alias: 'glob', number: 'I')
        converter.learn_roman_number(number_alias: 'prok', number: 'V')
        converter.learn_roman_number(number_alias: 'pish', number: 'X')
        converter.learn_roman_number(number_alias: 'tegj', number: 'L')
      end

      it 'parses input for learning good values' do
        parsed_input = converter.parse('glob prok Gold is 57800 Credits')

        good_values = converter.instance_variable_get('@good_values')
        expect(good_values).to eq({ 'Gold' => 14450 })
      end

      it 'parses input for number calculation' do
        parsed_input = converter.parse('how much is pish tegj glob glob ?')
        expect(parsed_input).to eq('pish tegj glob glob is 42')
      end

      it 'parses input for credit calculation' do
        converter.learn_good_value(good: 'Silver', value: 17)
        parsed_input = converter.parse('how many Credits is glob prok Silver ?')
        expect(parsed_input).to eq('glob prok Silver is 68 Credits')
      end
    end

    it 'returns message if input cannot be parsed' do
      parsed_input = converter.parse('how much wood could a woodchuck chuck if a woodchuck could chuck wood ?')
      expect(parsed_input).to eq('I have no idea what you are talking about')
    end

    context 'integration' do
      it 'handles all test cases from example' do
        converter.parse('glob is I')
        converter.parse('prok is V')
        converter.parse('pish is X')
        converter.parse('tegj is L')
        converter.parse('glob glob Silver is 34 Credits')
        converter.parse('glob prok Gold is 57800 Credits')
        converter.parse('pish pish Iron is 3910 Credits')

        expect(converter.parse('how much is pish tegj glob glob ?')).to eq('pish tegj glob glob is 42')
        expect(converter.parse('how many Credits is glob prok Silver ?')).to eq('glob prok Silver is 68 Credits')
        expect(converter.parse('how many Credits is glob prok Gold ?')).to eq('glob prok Gold is 57800 Credits')
        expect(converter.parse('how many Credits is glob prok Iron ?')).to eq('glob prok Iron is 782 Credits')
        expect(converter.parse('how much wood could a woodchuck chuck if a woodchuck could chuck wood ?')).to(
          eq('I have no idea what you are talking about'))
      end
    end
  end
end
