#!/bin/bash

DAYS=2
DB="main"


until mongo mongodb://mongo:27017/$DB --eval "db.stats()" > /dev/null 2>&1; do
    echo "[cleanup] Waiting for MongoDB..."
    sleep 5
done

echo "[cleanup] MongoDB is up. Starting cleanup loop..."

while true; do
    CUTOFF=$(($(date +%s) - DAYS*24*60*60))
    echo "[cleanup] Cleaning records older than $DAYS days (cutoff: $CUTOFF)..."

    mongo mongodb://mongo:27017/$DB --eval "
        print('[cleanup] annotated_documents...');
        db.annotated_documents.deleteMany({ fetch_time: { \$lt: $CUTOFF } });

        print('[cleanup] clusters...');
        db.clusters.deleteMany({ create_time: { \$lt: $CUTOFF } });

        print('[cleanup] documents...');
        db.documents.deleteMany({ fetch_time: { \$lt: $CUTOFF } });

        print('[cleanup] Done.');
    "

    echo "[cleanup] Sleeping 24h..."
    sleep 43200
done
