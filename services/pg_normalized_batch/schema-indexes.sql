-- schema-indexes.sql
SET max_parallel_maintenance_workers TO 80;
SET maintenance_work_mem TO '16 GB';

-- 1) speed up tag lookups
CREATE INDEX ON tweet_tags(tag);

-- 2) speed up self‐joins & tag→tweet lookups
CREATE INDEX ON tweet_tags(id_tweets);

-- 3) speed up the join from tags back to tweets
CREATE INDEX ON tweets(id_tweets);

-- 4) full-text search on tweet text
CREATE INDEX ON tweets
  USING GIN (to_tsvector('english', text));

