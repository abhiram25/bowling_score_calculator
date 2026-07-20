# frozen_string_literal: true

require_relative 'frame'

# Calculates the score for each frame in the game.
def calculate_frames(rolls)
  if perfect_game?(rolls)
    return [30] * 10
  elsif gutter_game?(rolls)
    return [0] * 10
  end

  frames = parse_frames(rolls)
  frames.map(&:score)
end

# Returns true if the rolls represent a perfect game.
def perfect_game?(rolls)
  rolls.all? { |roll| roll == 'X' } && rolls.length == 12
end

# Returns true if the rolls represent a perfect game.
def gutter_game?(rolls)
  rolls.all? { |roll| roll == 0 } && rolls.length == 10
end

# Converts the flat roll input into linked Frame objects.
# The tenth frame is handled separately because it follows different rules.
def parse_frames(rolls)
  frames = []
  i = 0
  # Build the first nine frames.
  while i < rolls.length && frames.length < 9
    frame =
      if rolls[i] == 'X'
        i += 1 # The next roll in the rolls array is evaluated since, the current role is a strike
        Frame.new('X')
      else
        current_frame = Frame.new(*rolls[i, 2]) # Consume the next two rolls for an open or spare frame.
        i += 2
        current_frame
      end

    add_frame(frames, frame)
  end

  # The remaining rolls belong to the tenth frame.
  add_frame(frames, TenthFrame.new(*rolls[i..])) if i < rolls.length

  frames
end

# Adds a frame and links it to the previous frame.
def add_frame(frames, frame)
  frames.last.next_frame = frame unless frames.empty?
  frames << frame
end
