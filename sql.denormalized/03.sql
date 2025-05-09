-- sql.denormalized/03.sql
-- per-language counts of tweets tagged #coronavirus
SELECT
  data->>'lang' AS lang,
  count(DISTINCT (data->>'id')::bigint) AS count
FROM tweets_jsonb,
     jsonb_array_elements(data->'entities'->'hashtags') AS h
WHERE h->>'text' = 'coronavirus'
GROUP BY lang
ORDER BY count DESC, lang;

