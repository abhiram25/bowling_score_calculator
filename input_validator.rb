class InputValidator
  VALID_SYMBOLS = ["X", "/"].freeze

  def self.validate!(rolls)
    raise ArgumentError, "Rolls must be an array" unless rolls.is_a?(Array)
		raise ArgumentError, "Cannot have more than 21 rolls in a game" if rolls.length > 21
    raise ArgumentError, "Rolls cannot be empty" if rolls.empty?

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

	def self.validate_tenth_frame!(tenth_frame)
		first, second, third = tenth_frame.rolls

		if first == "/"
			raise ArgumentError,
						"First roll in a frame cannot be a spare"
		end

		if second == "X" && first != "X"
			raise ArgumentError,
						"Second roll in the tenth frame cannot be a strike unless the first roll is a strike"
		end

		if second == "/" && first == "X"
			raise ArgumentError,
						"Second roll in the tenth frame cannot be a spare if the first roll is a strike"
		end

		if third == "/" && (first != "X" || !second.is_a?(Integer))
			raise ArgumentError,
						"Third roll in the tenth frame can only be a spare after a strike followed by a numeric roll"
		end
	end
end