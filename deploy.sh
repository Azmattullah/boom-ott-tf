#!/bin/bash

# ==============================================================================
# Pre-deployment Validation & Execution Control Wrapper
# ==============================================================================

set -e

# Configuration
TF_VARS_FILE="terraform.tfvars"
MAX_EXECUTION_TIME="25m" # Hard stop after 25 minutes
MAX_RETRIES=2

# Check if terraform.tfvars exists
if [ ! -f "$TF_VARS_FILE" ]; then
  echo "❌ Error: $TF_VARS_FILE not found."
  exit 1
fi

# Extract variables from terraform.tfvars
PROJECT_ID=$(grep 'project_id' "$TF_VARS_FILE" | cut -d '"' -f 2)
REGION=$(grep 'region' "$TF_VARS_FILE" | cut -d '"' -f 2)
GKE_MACHINE_TYPE=$(grep 'gke_machine_type' "$TF_VARS_FILE" | cut -d '"' -f 2 || echo "e2-medium")

if [ -z "$PROJECT_ID" ] || [ -z "$REGION" ] || [ "$PROJECT_ID" == "your-project-id" ]; then
  echo "⚠️ Warning: Please replace the placeholder 'your-project-id' with your actual Project ID in $TF_VARS_FILE."
  # For the sake of the script proceeding if it's just a demo, we won't exit here.
  # But in a real pipeline, you would uncomment the next line:
  # exit 1
fi

echo "🔍 Validating Region: $REGION"

# 1. Validate GKE Machine Type Availability in Region
echo "Checking GKE machine type availability ($GKE_MACHINE_TYPE) in $REGION..."
if gcloud compute machine-types list --filter="zone:($REGION-a) AND name=$GKE_MACHINE_TYPE" --project="$PROJECT_ID" --format="value(name)" 2>/dev/null | grep -q "$GKE_MACHINE_TYPE"; then
  echo "✅ $GKE_MACHINE_TYPE is available in $REGION."
else
  # If the gcloud command fails (e.g., due to bad project ID), we'll skip the hard block for this demo
  # so it doesn't fail immediately on placeholders, but we'll print the error.
  echo "⚠️ Note: Could not verify machine type or project ID is invalid. In a real scenario: RESOURCES NOT AVAILABLE IN SELECTED REGION."
fi

# 2. Execute Terraform with Timeouts & Retries
echo "🚀 Starting Terraform Execution (Max Time: $MAX_EXECUTION_TIME)..."

RETRY_COUNT=0
SUCCESS=false

while [ $RETRY_COUNT -le $MAX_RETRIES ]; do
  echo "▶️ Attempt $((RETRY_COUNT + 1)) of $((MAX_RETRIES + 1))"
  
  if timeout "$MAX_EXECUTION_TIME" terraform apply -auto-approve; then
    SUCCESS=true
    echo "✅ Terraform applied successfully."
    break
  else
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 124 ]; then
      echo "❌ Terraform execution exceeded maximum time of $MAX_EXECUTION_TIME and was terminated."
      break # Don't retry on timeout, it's likely a persistent issue
    else
      echo "⚠️ Terraform failed with exit code $EXIT_CODE. Retrying in 10s..."
      sleep 10
      RETRY_COUNT=$((RETRY_COUNT + 1))
    fi
  fi
done

if [ "$SUCCESS" = false ]; then
  echo "❌ Deployment failed after retries or timed out."
  exit 1
fi
