/* Find the top cities in each country (max top 3 cities for each country) with the
 * highest average naughty_nice_score for children who received gifts, but only include cities
 * with at least 5 children. Write them in any order below.
 */

SELECT DISTINCT city, country, avg(naughty_nice_score) AS NaughtyNiceAvg, count(*) AS childCount
FROM children c
INNER JOIN christmaslist cl ON c.child_id = cl.child_id
WHERE cl.was_delivered = true
GROUP BY city, country
HAVING count(c.city) >= 5
ORDER BY country, NaughtyNiceAvg DESC;
