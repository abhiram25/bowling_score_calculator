class InputValidator
  VALID_SYMBOLS = ["X", "/"].freeze

  def self.validate!(rolls)
    raise ArgumentError, "Rolls must be an array" unless rolls.is_a?(Array)

    rolls.each do |roll|
      valid_integer = roll.is_a?(Integer) && roll.between?(0, 9)
      valid_symbol = VALID_SYMBOLS.include?(roll)

      unless valid_integer || valid_symbol
        raise ArgumentError, "Invalid roll: #{roll.inspect}"
      end
    end
  end
end