/*
 * 'Twas the month before Christmas, and all through Santa's workshop, the elves
 * were in a panic! During the annual toy database upgrade, something went
 * terribly wrong with the magical toy-tracking system. The enchanted database
 * that keeps track of all toy descriptions and magical properties had
 * undergone a massive update, changing how toys were tagged and categorized.
 *
 * Head Elf Database Administrator (HEDA) Pixelspring discovered that while
 * they still had all the previous toy tags and the new ones, they desperately
 * needed to understand what exactly changed during the upgrade. Some toys
 * gained new magical properties, others lost their old enchantments, and
 * some maintained their original charm.
 *
 * Santa needs your help! As a consulting Database Wizard, you must help the
 * elves analyze these changes so they can ensure each toy maintains its
 * Christmas magic before being delivered to children around the world. Your
 * task is to write a query that will help identify which magical properties
 * (tags) were added, which remained constant, and which were lost during the
 * great toy tag migration.
 *
 * The fate of Christmas organization rests in your hands - can you help the
 * elves make sense of their toy tags before Santa's big night?
 *
 * Help the elves analyze toy tags by finding:
 * 1. New tags that weren't in previous_tags (call this added_tags)
 * 2. Tags that appear in both previous and new tags (call this unchanged_tags)
 * 3. Tags that were removed (call this removed_tags)
 * 4. For each toy, return toy_name and these three categories as arrays.
 *
 * Find the toy with the most added tags, there is only 1, and submit the
 * following:
 * 1. toy_id
 * 2. added_tags length
 * 3. unchanged_tags length
 * 4. removed_tags length
 *
 * Remember to handle cases where the array is empty, their output should
 * be 0.
 */

WITH data AS (SELECT tp.toy_id,
                     tp.toy_name,
                     ARRAY(SELECT UNNEST(tp.new_tags) EXCEPT SELECT UNNEST(previous_tags))    AS added_tags,
                     ARRAY(SELECT UNNEST(tp.new_tags) INTERSECT SELECT UNNEST(previous_tags)) AS unchanged_tags,
                     ARRAY(SELECT UNNEST(tp.previous_tags) EXCEPT SELECT UNNEST(new_tags))    AS removed_tags
              FROM toy_production tp)

SELECT toy_id,
       toy_name,
       array_length(added_tags, 1)     AS added_length,
       array_length(unchanged_tags, 1) AS unchanged_length,
       array_length(removed_tags, 1)   AS removed_length
FROM data
WHERE array_length(added_tags, 1) = (SELECT MAX(array_length(added_tags, 1)) FROM data);
