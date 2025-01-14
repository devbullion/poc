# This assumes you have already installed Docker (probably best to install Docker for Desktop) and gcloud
# If not, please install them first
# brew install docker
# brew install --cask google-cloud-sdk

# Login to Google Cloud
gcloud auth login

# Only need to run this once
gcloud auth configure-docker

# Build the docker image and push it to the Google Container Registry
# We are using the Linux/AMD64 platform so Google Cloud can run it
docker build --platform linux/amd64 -t gcr.io/goldreader/flask-app .
docker push gcr.io/goldreader/flask-app