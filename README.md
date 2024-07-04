# Streamlit Deployment Action

This GitHub Action deploys a Streamlit app to Google Cloud Run using Terraform.
**INFO:** This action is not a proper action, just some example code from the real internal action we use at Thoughtgears. If you want something like this,
please contact us and have a chat.

## Prerequisites

To run this action the assumption is that you have the following:

- A artifact repository in the same project as you want to deploy the cloud run service
- Workload identity federation configured for the repository using this action
    - Role: `roles/artifactregistry.writer`
    - Role: `roles/run.developer`

## Inputs

### `region`

**Optional** The Google Cloud Platform (GCP) region to deploy to. Default is `europe-west1`.

### `project`

**Required** The GCP project to deploy to.

### `docker_repository`

**Required** The name of the Docker repository to store the image.

### `streamlit_name`

**Required** The name of the Streamlit app.

### `streamlit_path`

**Required** The path to the Streamlit code and Dockerfile.

### `public`

**Optional** Whether the app should be public or not. Default is `false`.

### `github_token`

**Required** The GitHub token to use in the action for different steps.

### `access_token`

**Required** The access token to use for Docker login.

### `gcs_state_bucket`

**Required** The name of the GCS bucket to store the Terraform state.

## Outputs

### `streamlit_url`

The URL of the deployed Cloud Run Streamlit app.

## Example usage

```yaml
on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Google Cloud
        uses: google-github-actions/setup-gcloud@v0.2.1
        with:
          project_id: ${{ secrets.GCP_PROJECT }}
          service_account_key: ${{ secrets.GCP_SA_KEY }}
          export_default_credentials: true

      - name: Streamlit Deploy
        uses: ./
        with:
          region: 'europe-west1'
          project: ${{ secrets.GCP_PROJECT }}
          docker_repository: 'europe-docker.pkg.dev/my-project/streamlit'
          streamlit_name: 'my-streamlit-app'
          streamlit_path: './path/to/streamlit'
          public: 'false'
          github_token: ${{ secrets.GITHUB_TOKEN }}
          access_token: ${{ secrets.ACCESS_TOKEN }}
          gcs_state_bucket: 'my-gcs-bucket'
