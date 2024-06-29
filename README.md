# Streamlit Deployment Action

This GitHub Action deploys a Streamlit app to Google Cloud Run using Terraform.

**INFO:** This actions is not a proper action, just some example code from the real internal action we use at Thoughtgears. If you want something like this,
please contact us and have a chat.

## Inputs

### `terraform-version`

**Optional** The version of Terraform to use. Default is `1.8.5`.

### `terraform_directory`

**Optional** The directory containing the Terraform configuration. Default is `terraform`.

### `region`

**Optional** The Google Cloud Platform (GCP) region to deploy to. Default is `europe-west1`.

### `project`

**Required** The GCP project to deploy to.

### `github_token`

**Required** The GitHub token to use in the action for different steps.

### `streamlit_name`

**Required** The name of the Streamlit app.

## Outputs

### `cloud_run_url`

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
        terraform-version: '1.8.5'
        terraform_directory: 'terraform'
        region: 'europe-west1'
        project: ${{ secrets.GCP_PROJECT }}
        github_token: ${{ secrets.GITHUB_TOKEN }}
        streamlit_name: 'my-streamlit-app'
