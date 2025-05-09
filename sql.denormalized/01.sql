-- sql.denormalized/01.sql
-- count of tweets tagged #coronavirus
SELECT
  count(DISTINCT (data->>'id')::bigint)
FROM tweets_jsonb
WHERE EXISTS (
  SELECT 1
  FROM jsonb_array_elements(data->'entities'->'hashtags') AS h
  WHERE h->>'text' = 'coronavirus'
);

