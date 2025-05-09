-- services/pg_denormalized/schema-indexes.sql

DROP INDEX IF EXISTS idx_tweets_jsonb_hashtags;
DROP INDEX IF EXISTS idx_tweets_jsonb_symbols;
DROP INDEX IF EXISTS idx_tweets_jsonb_lang;
DROP INDEX IF EXISTS idx_tweets_jsonb_text_ft;

-- 1) bump parallel workers & maintenance memory for faster index creation
SET max_parallel_maintenance_workers = 80;
SET maintenance_work_mem = '2GB';

-- 2) index hashtags array for @> containment queries
CREATE INDEX IF NOT EXISTS idx_tweets_jsonb_hashtags
  ON tweets_jsonb
  USING GIN ((data->'entities'->'hashtags') jsonb_path_ops);

-- 3) index symbols (cashtags) array for @> containment queries
CREATE INDEX IF NOT EXISTS idx_tweets_jsonb_symbols
  ON tweets_jsonb
  USING GIN ((data->'entities'->'symbols') jsonb_path_ops);

-- 4) btree index on data->>'lang' for fast WHERE data->>'lang' = 'en'
CREATE INDEX IF NOT EXISTS idx_tweets_jsonb_lang
  ON tweets_jsonb ((data->>'lang'));

-- 5) full-text GIN index on the text field
CREATE INDEX IF NOT EXISTS idx_tweets_jsonb_text_ft
  ON tweets_jsonb
  USING GIN (to_tsvector('english', data->>'text'));

