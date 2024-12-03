-- Used to find out how many different xml roots there were when analyzing data

WITH const
         as (SELECT E'\n' ||
                    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' ||
                    E'\n'                                    AS heading,
                    '<?xml version="1.0" encoding="UTF-8"?>' AS encoding),

     cleanup AS
         (SELECT replace(replace(christmas_menus.menu_data::varchar, const.heading, ''), const.encoding,
                         '')::xml AS cleaned_up
          FROM const
                   CROSS JOIN christmas_menus),
     roots AS
         (SELECT DISTINCT unnest(regexp_matches(cleaned_up::text, '<.*? version=".*?">'))
          FROM cleanup)


SELECT *
FROM roots;
