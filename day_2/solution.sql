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
