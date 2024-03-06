#!/bin/zsh

# Define your AWS S3 bucket name
bucket_name="$KNOWLEDGE_SYNC_S3_BUCKET_NAME"

# check that bucket name is provided
if [ -z "$bucket_name" ]; then
    echo "S3 bucket name is not provided or empty. Please set the S3_BUCKET_NAME environment variable."
    exit 1
fi

# Define the directory you want to upload
directory_to_upload="$KNOWLEDGE_SYNC_S3_UPLOAD_DIRECTORY"

# Check if the specified directory exists
if [ ! -d "$directory_to_upload" ]; then
    echo "Directory '$directory_to_upload' does not exist."
    exit 1
fi

# Sync files from S3 bucket to local directory
echo "Syncing files from S3 bucket '$bucket_name' to local directory '$directory_to_upload'..."
aws s3 sync "s3://$bucket_name" "$directory_to_upload"

if [ $? -eq 0 ]; then
    echo "Sync completed successfully."
else
    echo "Sync failed."
    exit 1
fi

# Upload directory to S3 bucket
echo "Uploading directory '$directory_to_upload' to S3 bucket '$bucket_name'..."
aws s3 sync "$directory_to_upload" "s3://$bucket_name"

if [ $? -eq 0 ]; then
    echo "Upload completed successfully."
else
    echo "Upload failed."
    exit 1
fi
