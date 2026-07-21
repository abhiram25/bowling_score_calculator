# Bowling Score Calculator

A Ruby implementation of a bowling score calculator that parses a sequence of rolls into frames and returns the score for each frame. Frames that cannot yet be scored return `nil`.

## Requirements

- Ruby 3.3.6 or later

Verify your Ruby version:

```bash
ruby -v
```

Expected output:

```text
ruby 3.3.6 (2024-11-05 revision 75015d4c1f) [arm64-darwin25]
```

## Running the Application

From the project root, run:

```bash
ruby bowling_score_calculator.rb
```

## Running in IRB

From the project root, start IRB:

```bash
irb
```

Load the calculator:

```ruby
require_relative "./bowling_score_calculator"
```

Create an instance:

```ruby
calculator = BowlingScoreCalculator.new
```

Calculate frame scores:

```ruby
calculator.calculate_frames([
  4, 5, 4, 5, 4, 5, 4, 5, 4, 5,
  4, 5, 4, 5, 4, 5, 4, 5, 4, 5
])
```

Expected output:

```ruby
[9, 9, 9, 9, 9, 9, 9, 9, 9, 9]
```

## Running the Tests

Run the Minitest suite:

```bash
ruby test/bowling_score_calculator_test.rb
```

## Notes

- The calculator returns **per-frame scores**, not cumulative scores.
- Frames that cannot yet be scored because the required bonus rolls are unavailable return `nil`.
- Incomplete games are supported.
- See `assumptions.md` for implementation assumptions.