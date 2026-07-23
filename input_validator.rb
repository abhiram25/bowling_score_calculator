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

  def self.validate_frames!(frames)
    if frames.any? { |frame| frame.rolls.first == "/" }
			raise ArgumentError, "First roll in a frame cannot be a spare" 
		elsif frames.any? { |frame| frame.rolls[1] == "X" && frame.class == Frame }
    	raise ArgumentError, "Second roll in a frame cannot be a strike in a normal frame."
		end
  end
end