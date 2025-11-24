#!/bin/bash

DAYS=7
DB="main"

while true; do
    CUTOFF=$(($(date +%s) - DAYS*24*60*60))
    echo "[cleanup] Cleaning records older than $DAYS days (cutoff: $CUTOFF)..."

    # используем старый mongo shell
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
    sleep 86400
done
