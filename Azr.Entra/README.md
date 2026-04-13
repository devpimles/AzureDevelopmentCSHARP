# Azure Entra ID

This module is an identity playground for Microsoft Entra ID. It combines infrastructure deployment with a small client application so you can experiment with OAuth2 flows, delegated permissions, app roles, group assignments, and Graph-backed setup automation.

## What This Module Covers

- App registrations for an API and a client application
- Delegated scopes and app roles
- Security groups mapped to roles
- PowerShell automation for deployment and cleanup
- A sample client application in `Client`

## Structure

```text
Azr.Entra/
|-- README.md
|-- Azr.Entra.sln
|-- Client/
`-- infra/
    |-- README.md
    |-- Deploy.ps1
    |-- Cleanup-Resources.ps1
    |-- Verify.ps1
    |-- scripts/
    `-- modules/
```

## Reader Guide

- Start here for the scenario overview.
- Use [infra/README.md](infra/README.md) when you are ready to deploy the Entra objects.
- Inspect `Client` if you want to test the identity setup from application code.

## Quick Start

1. Review [infra/README.md](infra/README.md).
2. Populate the `.env` file expected by [infra/Deploy.ps1](infra/Deploy.ps1).
3. Run the deployment from the `infra` folder:

```powershell
.\Deploy.ps1
```

## References

- [Microsoft Graph Bicep reference for applications](https://learn.microsoft.com/en-us/graph/templates/bicep/reference/applications?view=graph-bicep-1.0)
