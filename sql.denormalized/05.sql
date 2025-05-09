-- sql.denormalized/05.sql
--
-- “Find the top co-occurring hashtags in English tweets
--  whose text matches ‘coronavirus’ via full-text search.”

WITH matches AS (
  SELECT
    (data->>'id')::bigint        AS id_tweets,
    data->>'text'                AS txt,
    data->>'lang'                AS lang,
    data->'entities'->'hashtags' AS hashtags
  FROM tweets_jsonb
  WHERE data->>'lang' = 'en'
    AND to_tsvector('english', data->>'text')
        @@ to_tsquery('english','coronavirus')
),
exploded AS (
  SELECT
    id_tweets,
    jsonb_array_elements(hashtags) AS h
  FROM matches
),
distinct_tags AS (
  SELECT DISTINCT
    id_tweets,
    -- build a plain‐text tag, never parsed as JSON
    '#' || (h->>'text')          AS tag
  FROM exploded
)
SELECT
  tag,
  count(*) AS count
FROM distinct_tags
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;

