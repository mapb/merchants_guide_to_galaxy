class Matcher
  # Regexp for input like 'glob is I', 'prok is V', 'pish is X', 'tegj is L'
  ROMAN_NUMBER_MATCHER = /(.*)\sis\s(I|V|X|L|C|D|M)$/i
  # Regexp for input like 'glob glob Silver is 34 Credits', 'glob prok Gold is 57800 Credits', 'pish pish Iron is 3910 Credits'
  CREDIT_MATCHER = /^(.+)\s(.+)\sis\s(\d+)\sCredits$/i
  # Regexp for questions like 'how much is pish tegj glob glob ?'
  NUMBER_CALCULATION_MATCHER = /^how much is\s(.+)\s\?$/i
  #Regexp for questions like 'how many Credits is glob prok Silver ?'
  CREDIT_CALCULATION_MATCHER = /^how many Credits is\s(.+)\s(.+)\s\?$/i
end
