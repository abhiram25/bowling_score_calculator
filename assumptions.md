Assumptions

1. Input is an array of rolls.

2. A numeric roll is an integer between 0-9.

3. A strike is represented by `"X"`.

4. A spare is represented by `"/"` and always follows a numeric roll.
5. Frames 1–9 consist of either:
   - one roll (strike), or
   - two rolls (open frame or spare).
6. The 10th frame may contain up to three rolls if a strike or spare is scored.
7. The method returns per-frame scores, not cumulative scores.
8. Frames that cannot yet be scored because the required bonus rolls are unavailable return `nil`.
9. Incomplete games are supported and partially completed frames are preserved.
10. Input is assumed to be valid. Validation of malformed input (e.g., invalid symbols, impossible pin counts, or extra rolls) is outside the scope of this implementation.