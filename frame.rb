# frozen_string_literal: true

# Frame class provides the blueprint for to make Frame a data structure
# Frame has rolls and a next frame to point the the frame after to help
# get the total for the frame.
class Frame
  attr_reader :rolls
  attr_reader :next_frame

  def initialize(*rolls)
    @rolls = rolls
  end

  def strike?
    rolls.first == 'X'
  end

  def spare?
    rolls[1] == '/'
  end

  def complete?
    strike? || rolls.length == 2
  end

  def open_frame?
    !strike? && !spare?
  end

  def next_frame=(frame)
    raise ArgumentError, "Open frames do not need a next frame" if open_frame?
    raise ArgumentError, "Next frame already linked" if @next_frame
    @next_frame = frame
  end 

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

  def score_strike
    return nil unless next_two_rolls.length == 2

    10 + value(next_two_rolls[0]) + value(next_two_rolls[1])
  end

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

  def value(roll)
    roll == 'X' ? 10 : roll
  end
end
