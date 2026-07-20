require "minitest/autorun"
require_relative "../bowling_score_calculator"

class BowlingScoreCalculatorTest < Minitest::Test
  def test_if_perfect_game_is_true
    rolls = Array.new(12, "X")

    assert_equal true, perfect_game?(rolls)
  end

  def test_perfect_game_is_all_30
    rolls = ["X", "X", "X", "X", "X", "X", "X", "X", "X", "X", "X", "X"]
    assert_equal [30] * 10, calculate_frames(rolls)
  end

  def test_parses_open_frame
    frames = parse_frames([4, 5])
    frame = frames.first

    assert_equal 1, frames.length
    assert_instance_of Frame, frame
    assert_equal [4, 5], frame.rolls
  end  

  def test_scores_parsed_open_frame
    frames = parse_frames([4, 5])

    assert_equal 9, frames.first.score
  end
  
  def test_calculates_open_frame
    assert_equal [9], calculate_frames([4, 5])
  end

  def test_parses_frame_with_spare
    rolls = [4, "/"]

    frames = parse_frames(rolls)

    assert_equal 1, frames.length
    assert_equal [4, "/"], frames.first.rolls
  end

  def test_returns_nil_for_incomplete_spare
    frame = Frame.new(4, "/")

    assert_nil frame.score
  end  

	def test_calculate_frames_returns_nil_for_incomplete_spare
		rolls = [4, "/"]

		assert_equal [nil], calculate_frames(rolls)
	end	

	def test_parses_frame_with_complete_spare
		rolls = [4, "/", 5]

		frames = parse_frames(rolls)

		assert_equal 2, frames.length
		assert_equal [4, "/"], frames.first.rolls
		assert_equal [5], frames.last.rolls
	end	

	def test_calculate_frames_scores_spare_when_bonus_roll_exists
		rolls = [4, "/", 5]

		scores = calculate_frames(rolls)

		assert_equal 15, scores.first
	end	  	

	def test_calculate_frames_returns_scores_for_complete_spare
		rolls = [4, "/", 5]

		assert_equal [15, nil], calculate_frames(rolls)
	end
	
	def test_parses_spare_followed_by_open_frame
		rolls = [4, "/", 5, 4]

		frames = parse_frames(rolls)

		assert_equal 2, frames.length
		assert_equal [4, "/"], frames.first.rolls
		assert_equal [5, 4], frames.last.rolls
	end	

	def test_calculate_frames_scores_spare_and_following_open_frame
    rolls = [4, "/", 5, 4]

    scores = calculate_frames(rolls)

		assert_equal [15, 9], scores
  end

	def test_parses_single_strike
		rolls = ["X"]

		frames = parse_frames(rolls)

		assert_equal 1, frames.length
		assert_equal ["X"], frames.first.rolls
	end	

	def test_calculate_frames_returns_nil_for_single_strike
		rolls = ["X"]

		assert_equal [nil], calculate_frames(rolls)
	end

	def test_score_returns_nil_for_incomplete_strike
		frame = Frame.new("X")

		assert_nil frame.score
	end
	
	def test_parses_two_strikes
		rolls = ["X", "X"]

		frames = parse_frames(rolls)

		assert_equal 2, frames.length
		assert_equal ["X"], frames.first.rolls
		assert_equal ["X"], frames.last.rolls
	end	
	
	def test_calculate_frames_returns_nil_for_two_strikes
		rolls = ["X", "X"]

		assert_equal [nil, nil], calculate_frames(rolls)
	end
	
	def test_parses_three_strikes
		rolls = ["X", "X", "X"]

		frames = parse_frames(rolls)

		assert_equal 3, frames.length
		assert_equal ["X"], frames[0].rolls
		assert_equal ["X"], frames[1].rolls
		assert_equal ["X"], frames[2].rolls
	end
	
	def test_scores_three_strikes
		rolls = ["X", "X", "X"]

		frames = parse_frames(rolls)

		assert_equal 30, frames.first.score
		assert_nil frames[1].score
		assert_nil frames[2].score
	end

	def test_calculate_frames_returns_scores_for_three_strikes
		rolls = ["X", "X", "X"]

		assert_equal [30, nil, nil], calculate_frames(rolls)
	end

	def test_parses_three_strikes_followed_by_four
		rolls = ["X", "X", "X", 4]

		frames = parse_frames(rolls)

		assert_equal 4, frames.length
		assert_equal ["X"], frames[0].rolls
		assert_equal ["X"], frames[1].rolls
		assert_equal ["X"], frames[2].rolls
		assert_equal [4], frames[3].rolls
	end	

	# A strike bonus can span two subsequent frames.
	def test_scores_three_strikes_followed_by_four
		rolls = ["X", "X", "X", 4]

		frames = parse_frames(rolls)

		assert_equal 30, frames[0].score
		assert_equal 24, frames[1].score
		assert_nil frames[2].score
		assert_nil frames[3].score
	end
	
	def test_calculate_frames_returns_scores_for_three_strikes_followed_by_four
		rolls = ["X", "X", "X", 4]

		assert_equal [30, 24, nil, nil], calculate_frames(rolls)
	end
	
	def test_parses_three_strikes_followed_by_open_frame
		rolls = ["X", "X", "X", 4, 5]

		frames = parse_frames(rolls)

		assert_equal 4, frames.length
		assert_equal ["X"], frames[0].rolls
		assert_equal ["X"], frames[1].rolls
		assert_equal ["X"], frames[2].rolls
		assert_equal [4, 5], frames[3].rolls
	end
	
	def test_calculate_frames_returns_scores_for_three_strikes_followed_by_open_frame
		rolls = ["X", "X", "X", 4, 5]

		assert_equal [30, 24, 19, 9], calculate_frames(rolls)
	end
	
	def test_parses_complete_open_game
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5, 4, 5
		]

		frames = parse_frames(rolls)

		assert_equal 10, frames.length

		frames.each do |frame|
			assert_equal [4, 5], frame.rolls
		end
	end
	
	def test_scores_complete_open_game
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5, 4, 5
		]

		frames = parse_frames(rolls)

		frames.each do |frame|
			assert_equal 9, frame.score
		end
	end	

	def test_calculate_frames_returns_scores_for_complete_open_game
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5, 4, 5
		]

		assert_equal [9, 9, 9, 9, 9, 9, 9, 9, 9, 9], calculate_frames(rolls)
	end

	# The parser should not create a tenth frame until a tenth-frame roll exists.
	def test_does_not_create_tenth_frame_when_only_nine_frames_exist
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			"X"
		]

		frames = parse_frames(rolls)

		assert_equal 9, frames.length
		assert_equal ["X"], frames.last.rolls
		assert frames.none? { |frame| frame.is_a?(TenthFrame) }
	end

	def test_creates_tenth_frame_when_tenth_frame_roll_exists
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			"X",
			4
		]

		frames = parse_frames(rolls)

		assert_equal 10, frames.length
		assert_instance_of Frame, frames[8]
		assert_instance_of TenthFrame, frames[9]
		assert_equal [4], frames[9].rolls
	end	

	def test_calculate_frames_returns_scores_for_incomplete_tenth_frame
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			"X",
			4
		]

		assert_equal [9, 9, 9, 9, 9, 9, 9, 9, nil, nil], calculate_frames(rolls)
	end	

	# The ninth-frame strike uses the first two rolls from the tenth frame as its bonus.
	def test_calculates_ninth_frame_strike_using_tenth_frame_rolls
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			"X",
			4, 5
		]

		assert_equal(
			[9, 9, 9, 9, 9, 9, 9, 9, 19, 9],
			calculate_frames(rolls)
		)
	end	

	def test_incomplete_tenth_frame_returns_nil_with_one_roll
		frame = TenthFrame.new(4)

		assert_nil frame.score
	end
	
	def test_returns_nil_for_incomplete_tenth_frame_with_one_roll
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5,
			4
		]

		assert_equal(
			[9, 9, 9, 9, 9, 9, 9, 9, 9, nil],
			calculate_frames(rolls)
		)
	end	

	# A tenth-frame spare requires one bonus roll before it can be scored.
	def test_incomplete_tenth_frame_returns_nil_with_spare
		frame = TenthFrame.new(4, "/")

		assert_nil frame.score
	end	

	def test_incomplete_tenth_frame_returns_nil_with_one_roll
		frame = TenthFrame.new(4)

		assert_nil frame.score
	end

	# A tenth-frame strike requires two bonus rolls before it can be scored.
	def test_incomplete_tenth_frame_returns_nil_with_single_strike
		frame = TenthFrame.new("X")

		assert_nil frame.score
	end	

	def test_calculate_frames_returns_nil_for_incomplete_tenth_frame_spare
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5,
			4, "/"
		]

		assert_equal(
			[9, 9, 9, 9, 9, 9, 9, 9, 9, nil],
			calculate_frames(rolls)
		)
	end
	
	def test_tenth_frame_spare_with_strike_bonus_does_not_award_extra_bonus_rolls
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5,
			4, "/", "X"
		]

		assert_equal(
			[9, 9, 9, 9, 9, 9, 9, 9, 9, 20],
			calculate_frames(rolls)
		)
	end
	
	def test_calculate_frames_returns_nil_for_incomplete_tenth_frame_strike
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5,
			"X"
		]

		assert_equal(
			[9, 9, 9, 9, 9, 9, 9, 9, 9, nil],
			calculate_frames(rolls)
		)
	end	

	# A strike with only one tenth-frame bonus roll is still incomplete.
	def test_calculate_frames_returns_nil_for_tenth_frame_strike_with_one_bonus_roll
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5,
			"X", 4
		]

		assert_equal(
			[9, 9, 9, 9, 9, 9, 9, 9, 9, nil],
			calculate_frames(rolls)
		)
	end
	
	def test_calculate_frames_returns_nil_for_tenth_frame_with_two_strikes
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5,
			"X", "X"
		]

		assert_equal(
			[9, 9, 9, 9, 9, 9, 9, 9, 9, nil],
			calculate_frames(rolls)
		)
	end	

	def test_calculate_frames_scores_three_strikes_in_tenth_frame
		rolls = [
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5, 4, 5, 4, 5, 4, 5,
			4, 5,
			"X", "X", "X"
		]

		assert_equal(
			[9, 9, 9, 9, 9, 9, 9, 9, 9, 30],
			calculate_frames(rolls)
		)
	end	

	def test_calculate_frames_scores_mixed_game
		rolls = [
			4, 5,       # Frame 1: 9
			6, "/",     # Frame 2: 10 + 3 = 13
			3, 4,       # Frame 3: 7
			"X",        # Frame 4: 10 + 2 + 3 = 15
			2, 3,       # Frame 5: 5
			8, "/",     # Frame 6: 10 + 10 = 20
			"X",        # Frame 7: 10 + 5 + 4 = 19
			5, 4,       # Frame 8: 9
			7, "/",     # Frame 9: 10 + 6 = 16
			6, 2        # Frame 10: 8
		]

		assert_equal(
			[9, 13, 7, 15, 5, 20, 19, 9, 16, 8],
			calculate_frames(rolls)
		)
	end	

	def test_gutter_game
    rolls = [0, 0] * 10

    assert_equal [0] * 10, calculate_frames(rolls)
  end
end