/*
 * In the enchanting winter wonderland of the North Pole, where the night sky
 * dances with the aurora borealis and snow crunches delightfully underfoot,
 * Santa Claus was feeling a mix of excitement and concern. The big night was
 * approaching rapidly, and the workshop was abuzz with elves crafting toys,
 * wrapping gifts, and preparing the sleigh for its global journey.
 *
 * Santa sat by the fireplace in his cozy study, sipping hot cocoa with a hint
 * of peppermint, pondering over his massive 'Naughty or Nice' list. Mrs. Claus,
 * ever the voice of wisdom, noticed his furrowed brow. "What's troubling you,
 * dear?" she asked softly.
 *
 * "Well," Santa began, stroking his snowy beard thoughtfully, "I've been
 * hearing reports that toy production numbers have been fluctuating over the
 * past few days. Some days the elves surpass all expectations, and other days
 * production seems to dip unexpectedly. I worry that if this trend continues,
 * we might not meet our Christmas Eve deadline."
 *
 * Mrs. Claus smiled gently. "Perhaps it's time to delve into the data and see
 * what's causing these variations."
 *
 * "You're right," Santa agreed. "I need a detailed analysis of our daily toy
 * production to understand these trends. Maybe then we can identify any issues
 * and ensure that every child receives a gift on Christmas morning."
 *
 * Santa called upon Figgy, the most tech-savvy elf, renowned for his expertise
 * in data analysis and SQL magic. "Figgy, I need your help to analyze the daily
 * toy production trends over the past week," Santa said. "We need to compare
 * each day's production to the previous day to identify any significant changes."
 *
 * Elated by the challenge, Figgy set out to work, determined to provide Santa
 * with the insights he needed to keep the magic of Christmas alive.
 *
 * Using the provided schema and data, write a SQL query that analyzes the
 * daily toy production trends for each date in the table, comparing a date to
 * the date before. The query should accomplish the following:
 * 1. List each day's production date and the number of toys produced on that day.
 * 2. Include the previous day's toy production next to each current day's production.
 * 3. Calculate the change in the number of toys produced compared to the previous day.
 * 4. Calculate the percentage change in production compared to the previous day.
 *
 * The result set should display the following columns:
 * 1. production_date: The current date.
 * 2. toys_produced: Number of toys produced on the current date.
 * 3. previous_day_production: Number of toys produced on the previous date.
 * 4. production_change: Difference in toys produced between the current date and the previous date.
 * 5. production_change_percentage: Percentage change in production compared to the previous day.
 *
 * Submit the date of the day with the largest daily increase in percentage
 */

WITH lag AS (SELECT *,
                    LAG(toys_produced) OVER (
                        ORDER BY
                            production_date
                        ) AS previous_day_production
             FROM toy_production),
     results AS (SELECT production_date,
                        toys_produced,
                        LAG(toys_produced) OVER (
                            ORDER BY
                                production_date
                            )                                     AS previous_day_production,
                        (toys_produced - previous_day_production) AS production_change,
                        round((100.0 * (toys_produced - previous_day_production)) / previous_day_production,
                              2)                                  AS production_change_percentage
                 FROM lag
                 ORDER BY production_date)

SELECT *
FROM results
WHERE production_change_percentage = (SELECT MAX(production_change_percentage) FROM results);
