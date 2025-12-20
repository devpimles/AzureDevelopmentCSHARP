# Entra ID OAuth2 playground

Provision Microsoft Entra ID (Azure AD) resources intended for controlled experimentation with OAuth 2.0 authentication flows, JWT-based authorization, delegated scopes, app roles, and group-based access management.

![Diagram](img/Entra-Diagram.drawio.png)

## What Gets Deployed - Entra ID Objects

- **API Application** (`api-app-*`)
  - OAuth2 scopes:
    - `test.read`
    - `test.write`
  - App roles:
    - `Test.Reader`
    - `Test.Writer`
- **Client Application** (`client-app-*`)
  - Public client
  - Requests delegated access to API scopes
- **Service Principals**
  - Automatically created for both applications
- **Security Groups**
  - `grp-test-reader-*`
  - `grp-test-writer-*`
- **Role Assignments**
  - Groups mapped to corresponding API app roles

## Quick Start

1. Configure [`.env`](.env):


2. Deploy:
   ```powershell
   .\Deploy.ps1
   ```

3. View created resources:
   ```powershell
   .\scripts\List_Objects.ps1
   ```

4. Clean resources:
   ```powershell
   .\Cleanup_Resources.ps1
   ```

## Use Cases

- Test OAuth2 delegated permissions and app roles
- Experiment with JWT tokens and claims
- Understand group-based access control in Entra ID
- Practice app registration configuration

## Reference

[Microsoft.Graph Bicep Reference](https://learn.microsoft.com/en-us/graph/templates/bicep/reference/applications?view=graph-bicep-1.0)