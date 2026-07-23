# frozen_string_literal: true

require_relative 'frame'
require_relative 'tenth_frame'
require_relative 'input_validator'

class BowlingScoreCalculator
	def calculate_frames(rolls)
		InputValidator.validate!(rolls)

		if perfect_game?(rolls)
			return [30] * 10
		elsif gutter_game?(rolls)
			return [0] * 10
		end

		frames = generate_frames(rolls)
		InputValidator.validate_frames!(frames)
		frames.map(&:score)
	end

	def perfect_game?(rolls)
		rolls.all? { |roll| roll == 'X' } && rolls.length == 12
	end

	def gutter_game?(rolls)
		rolls.all? { |roll| roll == 0 } && rolls.length == 20
	end

	def generate_frames(rolls)
		frames = []
		i = 0

		while i < rolls.length && frames.length < 9
			frame =
				if rolls[i] == 'X'
					i += 1
					Frame.new('X')
				else
					current_frame = Frame.new(*rolls[i, 2])
					i += 2
					current_frame
				end

			add_frame(frames, frame)
		end

		add_frame(frames, TenthFrame.new(*rolls[i..])) if i < rolls.length

		frames
	end

	def add_frame(frames, frame)
		previous_frame = frames.last

		if previous_frame && !previous_frame.open_frame?
			previous_frame.next_frame = frame
		end

		frames << frame
	end
end