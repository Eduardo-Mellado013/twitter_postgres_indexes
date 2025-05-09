-- sql.denormalized/04.sql
-- full-text count of English tweets matching “coronavirus”
SELECT
  count(*)
FROM tweets_jsonb
WHERE data->>'lang' = 'en'
  AND to_tsvector('english', data->>'text')
      @@ to_tsquery('english','coronavirus');

