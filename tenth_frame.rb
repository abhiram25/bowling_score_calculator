# frozen_string_literal: true

# The tenth frame has different scoring rules because it may include
# up to two bonus rolls after a strike or spare.
class TenthFrame < Frame
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

  def complete?
    return false if rolls.empty?

    if strike? || spare?
      rolls.length == 3
    else
      rolls.length == 2
    end
  end

  def next_frame=(_frame)
    raise ArgumentError, "Tenth frame cannot have a next frame"
  end  
end