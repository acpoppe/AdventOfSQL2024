/*
 * Santa's elves have reported an issue with gift distribution fairness. Some
 * children are receiving gifts far more expensive than others in their
 * neighborhood. Santa wants to ensure a more equitable distribution by
 * identifying these cases. He needs to find all children who received gifts
 * that are more expensive than the average gift price in the North Pole's gift
 * database, so he can review and adjust the distribution plan accordingly.
 *
 * Write a query that returns the name of each child and the name and price of
 * their gift, but only for children who received gifts more expensive than the
 * average gift price.
 *
 * The results should be ordered by the gift price in ascending order.
 *
 * Give the name of the child with the first gift thats higher than the average.
 */

SELECT c.name AS child_name, g.name AS gift_name, g.price AS gift_price
FROM children c
         INNER JOIN gifts g
                    ON c.child_id = g.child_id
WHERE g.price > (SELECT AVG(price) FROM gifts)
ORDER BY g.price;
