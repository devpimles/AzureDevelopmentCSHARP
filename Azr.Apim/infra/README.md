# Azure API Management Infrastructure

This folder contains the Bicep files and PowerShell deployment script for the API Management module.

## Resources Deployed

- Azure API Management
- Supporting API-related configuration through Bicep modules

## Files

```text
infra/
|-- README.md
|-- deploy.ps1
|-- main.bicep
|-- main.dev.bicepparam
`-- modules/
    |-- apim.bicep
    `-- inference-api.bicep
```

## Deployment Style

This module uses:

- `main.bicep` as the entry-point template
- `main.dev.bicepparam` for environment-specific values
- `deploy.ps1` as the PowerShell orchestrator

The script reads values from `.env`, signs in with Azure CLI, creates the resource group, and currently runs the deployment in `--what-if` mode.

## Quick Start

1. Create or update `.env` in this folder with the values expected by `deploy.ps1`.
2. From this folder, run:

```powershell
.\deploy.ps1
```

## Notes

- Because the script currently uses `--what-if`, it is especially useful for validating the resource plan before a real deployment.
- The next natural improvement for this README would be listing the exact `.env` keys expected by the script.
