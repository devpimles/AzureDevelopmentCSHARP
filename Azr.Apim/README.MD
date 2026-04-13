# Azure API Management

This module combines API Management infrastructure with sample application code. The goal is to keep the backend API, the client, and the deployment assets easy to inspect without losing the end-to-end scenario.

## What This Module Covers

- Azure API Management deployment with Bicep modules
- A sample backend API in `src/OnboardingAPI`
- A sample console client in `src/ConsoleAPIM`
- PowerShell as the deployment orchestrator

## Structure

```text
Azr.Apim/
|-- README.MD
|-- Azr.Apim.sln
|-- src/
|   |-- OnboardingAPI/
|   `-- ConsoleAPIM/
`-- infra/
    |-- README.md
    |-- deploy.ps1
    |-- main.bicep
    |-- main.dev.bicepparam
    `-- modules/
        |-- apim.bicep
        `-- inference-api.bicep
```

## Reader Guide

- `src/OnboardingAPI` contains the sample backend.
- `src/ConsoleAPIM` is a small client to exercise the API path.
- [infra/README.md](infra/README.md) explains the infrastructure side and deployment flow.

## Quick Start

1. Review [infra/README.md](infra/README.md).
2. Populate the `.env` file under [infra](infra) with the values used by [infra/deploy.ps1](infra/deploy.ps1).
3. Run the deployment script from the `infra` folder:

```powershell
.\deploy.ps1
```

## Notes

- The current script runs Azure deployment in `--what-if` mode, so it is useful for validating the plan before a real deployment.
