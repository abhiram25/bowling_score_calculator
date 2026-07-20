# frozen_string_literal: true

# Frame class provides the blueprint for to make Frame a data structure
# Frame has rolls and a next frame to point the the frame after to help
# get the total for the frame.
class Frame
  attr_reader :rolls
  attr_accessor :next_frame

  # Initializes a frame with its rolls.
  # Accepts a variable number of rolls to support regular frames (e.g. 'X' or 4, 5)
  # and the tenth frame, which may contain up to three rolls.
  def initialize(*rolls)
    @rolls = rolls
  end

  # strike? checks to see if the frame was a strike
  # On a tenth frame, strike is determined if the first roll is a strike
  def strike?
    rolls.first == 'X'
  end

  # spare? checks to see if the second roll resulted in a spare
  def spare?
    rolls[1] == '/'
  end

  # checks to see if the frame is completed
  # by checking for a strike or two rolls
  def complete?
    strike? || rolls.length == 2
  end

  # returns the score of the frame
  def score
    return nil unless complete?

    if strike?
      score_strike
    elsif spare?
      score_spare
    else
      rolls.sum
    end
  end

  private

  # Calculates the score for a strike.
  # Returns nil until the next two rolls are available.
  def score_strike
    return nil unless next_two_rolls.length == 2

    10 + value(next_two_rolls[0]) + value(next_two_rolls[1])
  end

  # Calculates the score for a spare.
  # Returns nil until the next roll is available.
  def score_spare
    return nil unless next_roll

    10 + value(next_roll)
  end

  # Returns the next roll after this frame.
  # Spare bonuses are based on the following roll.
  def next_roll
    next_frame&.rolls&.first
  end

  # Returns the next two rolls after this frame.
  # Strike bonuses may require rolls from one or two subsequent frames.
  def next_two_rolls
    return [] unless next_frame

    rolls = next_frame.rolls.dup

    rolls.concat(next_frame.next_frame.rolls) if rolls.length < 2 && next_frame.next_frame

    rolls.first(2)
  end

  # Returns the numeric value of a roll.
  # A strike ('X') is worth 10 pins.
  def value(roll)
    roll == 'X' ? 10 : roll
  end
end

# The tenth frame has different scoring rules because it may include
# up to two bonus rolls after a strike or spare.
class TenthFrame < Frame
  # Calculates the score for the tenth frame.
  # Bonus rolls are scored within the frame instead of looking ahead
  # to a subsequent frame.
  def score
    return nil unless complete?

    if strike?
      10 + value(rolls[1]) + value(rolls[2])
    elsif spare?
      10 + value(rolls[2])
    else
      rolls.sum
    end
  end

  # Determines whether the tenth frame has all required rolls.
  # A strike or spare requires a third roll; otherwise two rolls complete the frame.
  def complete?
    return false if rolls.empty?

    if strike? || spare?
      rolls.length == 3
    else
      rolls.length == 2
    end
  end
end
