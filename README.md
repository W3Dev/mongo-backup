# Mongo Backup

### How to Configure

Create a file as `.github/workflows/mongodb-backup.yml` in your root directory. Since you would not want to run this on every push, I have added a condition to only run this if the code is on the `main` branch.


```yaml

name: MongoDB Backup to S3

on:

  # A custome Schedule to run your backups
  schedule:
    # Runs at 00:00 UTC every 7 days
    # Change it according to your needs
    - cron: '0 0 */7 * *'

  # Allows your to trigger the run from the UI
  workflow_dispatch:

jobs:
  backup:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Backup and upload to S3
      # Configiure these secrets in REPO_URL/settings/secrets/actions with the `secrets` section
      env:
        MONGODB_URI: ${{ secrets.MONGODB_URI }}
        TARGET_S3_FOLDER: ${{ secrets.S3_URI }}
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        AWS_CLI_ARGS: ${{ secrets.AWS_CLI_ARGS }}
      run: |
        echo "S3 Directory: $TARGET_S3_FOLDER"
        docker run --rm \
          -e MONGO_URI="$MONGODB_URI" \
          -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
          -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
          -e TARGET_S3_FOLDER="$TARGET_S3_FOLDER" \
          -e AWS_CLI_ARGS="$AWS_CLI_ARGS" \
          ghcr.io/w3dev/mongo-backup:latest
      shell: bash
```

### Environment Variables



| Env Variable   |      Use Case      |  Required |
|----------|:-------------:|------:|
| MONGO_URI |  URI formatted mongo-url | ✅ |
| TARGET_S3_FOLDER |    S3 Location where you want to upload the backups. e.g. `s3://project/backups/`   | ✅ |
| AWS_ACCESS_KEY_ID |    AWS Access Key ID   | ✅ |
| AWS_SECRET_ACCESS_KEY | AWS Secret Access Key | ✅ |
| AWS_CLI_ARGS | Add extra arguments to be passed on to `aws` command such as `--endpoint-url=https://XXXXX` | ❌ |
    