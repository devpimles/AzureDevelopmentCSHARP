set -e

subscriptionId="b226cf84-8ea9-4c93-8fad-62a33fda6bc0"
resourceGroupName="rg-demo"
location="westeurope"

templateFile="main.bicep"
parametersFile="main.dev.bicepparam"

timestamp=$(date +"%Y%m%d-%H%M%S")
deploymentName="ai-config-$timestamp"

az account set --subscription "$subscriptionId"

az group create --name "$resourceGroupName" --location "$location" --output none

 az deployment group create \
  --name "$deploymentName" \
  --resource-group "$resourceGroupName" \
  --template-file "$templateFile" \
  --parameters "$parametersFile" \
  --parameters \
      openAIKey="$OPENAI_API_KEY" \
      anthropicKey="$ANTHROPIC_API_KEY" \
  # --what-if # Remove --what-if to actually deploy

az resource list --resource-group "$resourceGroupName" --output table
