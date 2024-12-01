/*
 * Create a report showing what gifts children want, with difficulty ratings and categorization.
 *
 * The primary wish will be the first choice
 *
 * The secondary wish will be the second choice
 *
 * You can presume the favorite color is the first color in the wish list
 *
 * Gift complexity can be mapped from the toy difficulty to make. Assume the following:
 *   ```
 *      Simple Gift = 1
 *      Moderate Gift = 2
 *      Complex Gift >= 3
 *   ```
 *
 * We assign the workshop based on the primary wish's toy category. Assume the following:
 *   ```
 *      outdoor = Outside Workshop
 *      educational = Learning Workshop
 *      all other types = General Workshop
 *   ```
 *
 * Order the list by name in ascending order.
 *
 * Your answer should return only 5 rows
 */

SELECT c.name,
       wl.wishes::json ->> 'first_choice'             AS "primary_wish",
       wl.wishes::json ->> 'second_choice'            AS "backup_wish",
       wl.wishes::json -> 'colors' ->> 0              AS "favorite_color",
       json_array_length(wl.wishes::json -> 'colors') AS "color_count",
       (
           CASE
               WHEN tc1.difficulty_to_make = 1 THEN 'Simple Gift'
               WHEN tc1.difficulty_to_make = 2 THEN 'Moderate Gift'
               ELSE 'Complex Gift'
               END
           )                                          AS "gift_complexity",
       (
           CASE
               WHEN tc1.category = 'outdoor' THEN 'Outside Workshop'
               WHEN tc1.category = 'educational' THEN 'Learning Workshop'
               ELSE 'General Workshop'
               END
           )                                          AS "workshop_assignment"
FROM children c
         INNER JOIN wish_lists wl
                    ON c.child_id = wl.child_id
         INNER JOIN toy_catalogue tc1 ON wl.wishes::json ->> 'first_choice' = tc1.toy_name
         INNER JOIN toy_catalogue tc2 ON wl.wishes::json ->> 'second_choice' = tc2.toy_name
ORDER BY c.name
LIMIT 5;
