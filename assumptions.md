Assumptions


1. A numeric roll is an integer between 0-9.

2. A strike is represented by `"X"`.

3. A spare is represented by `"/"` and always follows a numeric roll.

4. Frames 1–9 consist of either:
   - one roll (strike), or
   - two rolls (open frame or spare).

5. The 10th frame may contain up to three rolls if a strike or spare is scored.

6. The method returns per-frame scores, not cumulative scores.

7. Frames that cannot yet be scored because the required bonus rolls are unavailable return `nil`.

8. Incomplete games are supported and partially completed frames are preserved.