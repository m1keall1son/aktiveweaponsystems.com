
#!/bin/sh

profiles=$(aws configure list-profiles)

if [[ ${profiles} != *"s3-deploy"* ]];then
    echo "profiles do not contain s3-deploy, loading ~/.ssh/deploy.aktiveweaponsystems.com.csv..."
    if ! aws configure import --csv file://~/.ssh/deploy.aktiveweaponsystems.com.csv; then
        echo "failed to import csv."
        exit 1;
    fi
    echo "imported csv"
fi

echo "configuring aws cli..."
if ! aws configure set region us-west-1 --profile s3-deploy; then
    echo "failed to configure aws cli."
    exit 1;
fi
echo "aws cli configured."

echo "syncing site folder to bucket..."
if ! aws s3 --profile s3-deploy sync ./site s3://aktiveweaponsystems.com --delete; then
    echo "failed to sync bucket."
    exit 1;
fi
echo "site synced"

echo "deploy successful."