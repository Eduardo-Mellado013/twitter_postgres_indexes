-- sql.denormalized/02.sql
--
-- “For every tweet that has #coronavirus, find all (distinct)
--  other hashtags on that same tweet, and then count how often
--  each one co-occurs with #coronavirus.”

WITH tags AS (
  SELECT
    (data->>'id')::bigint   AS id_tweets,
    ('#' || (h->>'text'))    AS tag
  FROM tweets_jsonb
  CROSS JOIN LATERAL jsonb_array_elements(data->'entities'->'hashtags') AS h
)
, corona AS (
  -- all tweets + their other tags, but only for tweets that
  -- contain #coronavirus
  SELECT DISTINCT
    t1.id_tweets,
    t2.tag
  FROM tags t1
  JOIN tags t2 USING (id_tweets)
  WHERE t1.tag = '#coronavirus'
    AND t2.tag LIKE '#%'    -- only real hashtags
)
SELECT
  tag,
  count(*) AS count
FROM corona
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;

