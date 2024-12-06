# Build the Vue/Cli project
npm run build

# Deploy the website to the Google Cloud Storage bucket
gcloud auth login
gsutil rsync -r ./dist gs://goldrush-poc-bucket

# Set the website configs
gsutil web set -m index.html -e 404.html gs://goldrush-poc-bucket