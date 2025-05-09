file=$1

python3 -u load_tweets_batch.py --db=postgresql://postgres:pass@localhost:8764/postgres --inputs $file
