/*
 * Mrs. Claus has a delightful but daunting task ahead of her. Every year, she hosts a
 * magnificent Christmas dinner for all the elves, reindeer handlers, and special holiday
 * helpers at the North Pole. This year, she's expecting more guests than ever - over 78
 * helpers in total! So she's only interested in past events where there were more than 78
 * guests. She keeps meticulous records of all previous Christmas dinners in her magical
 * database, stored as XML data that captures everyone's preferences and reactions to
 * different dishes. She needs your help to understand which dishes are the most popular.
 *
 * The challenge is that some records are stored in different XML schemas. Mrs. Claus needs
 * help writing a SQL query that can search through all schema versions to find the most
 * beloved dishes from the busiest celebrations. As she's having more than 78 guests this
 * year, she wants to make sure the dishes are popular with a large crowd, so only use years
 * where she had more than 78 guests.
 *
 * You will have to do some prep-work before you write your final query, like understanding
 * how many unique schema versions exist and how to parse each schema using SQL.
 *
 * Help Mrs. Claus write a SQL query that can:
 *
 * 1. Parse through all different schema versions of menu records
 * 2. Find menu entries where the guest count was above 78
 * 3. Extract the food_item_ids from those successful big dinners
 * 4. From this enormous list of items, determine which dish (by food_item_id) appears most
 *    frequently across all of the dinners.
 */

WITH const
         as (SELECT E'\n' ||
                    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' ||
                    E'\n'                                    AS heading,
                    '<?xml version="1.0" encoding="UTF-8"?>' AS encoding),

     cleanup AS
         (SELECT christmas_menus.menu_data,
                 replace(replace(christmas_menus.menu_data::varchar, const.heading, ''), const.encoding,
                         '')::xml AS cleaned_up
          FROM const
                   CROSS JOIN christmas_menus),
     v1_version AS
         (SELECT menu_data AS md, unnest(xpath('./northpole_database/@version', cleaned_up::xml))::varchar AS version
          FROM cleanup),
     v2_version AS
         (SELECT menu_data AS md, unnest(xpath('./christmas_feast/@version', cleaned_up::xml))::varchar AS version
          FROM cleanup),
     v3_version AS
         (SELECT menu_data AS md, unnest(xpath('./polar_celebration/@version', cleaned_up::xml))::varchar AS version
          FROM cleanup),
     v1 AS
         (SELECT md,
                 unnest(xpath(
                         './northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()',
                         md::xml))::varchar::integer AS guest_count
          FROM v1_version
          WHERE version = '1.0'),
     v2 AS
         (SELECT md,
                 unnest(xpath('./christmas_feast/organizational_details/attendance_record/total_guests/text()',
                              md::xml))::varchar::integer AS guest_count
          FROM v2_version
          WHERE version = '2.0'),
     v3 AS
         (SELECT md,
                 unnest(xpath(
                         './polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present/text()',
                         md::xml))::varchar::integer AS guest_count
          FROM v3_version
          WHERE version = '3.0'),
     v1_food AS
         (SELECT md::varchar,
                 guest_count,
                 unnest(xpath(
                         './northpole_database/annual_celebration/event_metadata/menu_items/food_category/food_category/dish/food_item_id/text()',
                         md::xml))::varchar AS food_item_id
          FROM v1),
     v2_food AS
         (SELECT md::varchar,
                 guest_count,
                 unnest(xpath(
                         './christmas_feast/organizational_details/menu_registry/course_details/dish_entry/food_item_id/text()',
                         md::xml))::varchar AS food_item_id
          FROM v2),
     v3_food AS
         (SELECT md::varchar,
                 guest_count,
                 unnest(xpath(
                         './polar_celebration/event_administration/culinary_records/menu_analysis/item_performance/food_item_id/text()',
                         md::xml))::varchar AS food_item_id
          FROM v3),
     guest_filtered AS
         (SELECT food_item_id, guest_count, md
          FROM v3_food
          WHERE guest_count > 78
          UNION
          SELECT food_item_id, guest_count, md
          FROM v1_food
          WHERE guest_count > 78
          UNION
          SELECT food_item_id, guest_count, md
          FROM v2_food
          WHERE guest_count > 78),
     counts AS
         (SELECT food_item_id, COUNT(food_item_id) AS count
          FROM guest_filtered
          GROUP BY 1)

SELECT food_item_id, count
FROM counts
WHERE count = (SELECT MAX(count) FROM counts);
