/*
 * 'Twas the month before Christmas, and all through Santa's high-tech command center, not
 * a keyboard was clicking, not even a printer... Until suddenly, BEEP! BEEP! BEEP!
 *
 * "Oh dear, oh my!" exclaimed Pixel, the head of Santa's IT elf team, adjusting his
 * candy-cane striped glasses. "The Northern Lights are acting up again! They've scrambled
 * our letters database!"
 *
 * You see, this year, Santa had modernized his mail system to handle the billions of
 * electronic letters coming in from children worldwide. But the magical Aurora Borealis,
 * extra sparkly this season, had interfered with the database servers, turning perfectly
 * good Christmas wishes into a jumble of integers!
 *
 * To make matters worse, the backup system (managed by two excitable elf twins, Binky and
 * Blinky) had split the data across different tables, and somehow mixed in random "holiday
 * sparkles" (aka noise) into the data.
 *
 * These tables contain pieces of a child's Christmas wish, but they're all mixed up with
 * magical interference from the Northern Lights! We need to:
 *
 * 1. Filter out the holiday sparkles (noise)
 * 2. Combine Binky and Blinky's tables
 * 3. Decode the values back into regular letters
 * 4. Make sure everything's in the right order!
 *
 * Valid characters
 * > All lower case letters a - z
 * > All upper case letters A - Z
 * > Space
 * > !
 * > "
 * > '
 * > (
 * > )
 * > ,
 * > -
 * > .
 * > :
 * > ;
 * > ?
 */
WITH temp_table AS (SELECT id, value, CHR(value) AS chrs
FROM letters_a
WHERE value BETWEEN 65 AND 90
  OR value BETWEEN 97 AND 122
  OR value BETWEEN 32 AND 34
  OR value BETWEEN 39 AND 41
  OR value BETWEEN 44 AND 46
  OR value BETWEEN 58 AND 59
  OR value = 63
UNION SELECT id, value, CHR(value)
      FROM letters_b
      WHERE value BETWEEN 65 AND 90
        OR value BETWEEN 97 AND 122
        OR value BETWEEN 32 AND 34
        OR value BETWEEN 39 AND 41
        OR value BETWEEN 44 AND 46
        OR value BETWEEN 58 AND 59
        OR value = 63
      ORDER BY id)

SELECT string_agg(chrs, '')
FROM temp_table
