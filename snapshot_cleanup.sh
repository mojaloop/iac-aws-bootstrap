#!/bin/sh

DATE=$(which gdate || which date)

if [[ ! $1 =~ ^-?[0-9]+$ ]]; then
  echo "Usage $0 <number of days to look back> [owner id]" 
  exit 1
fi

if [ ! -z "$2" ]; then
  OWNER="--owner-ids $2"
else
  OWNER="--owner self"
fi

snapshots_to_delete=$(aws ec2 describe-snapshots $OWNER --query "Snapshots[?StartTime<='`$DATE  --date=\"$1 days ago\" +%F`'].SnapshotId" --output text)

# actual deletion
for snap in $snapshots_to_delete; do
  aws ec2 delete-snapshot --snapshot-id $snap --no-dry-run
done
