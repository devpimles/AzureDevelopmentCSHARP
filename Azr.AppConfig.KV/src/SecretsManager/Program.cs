using Azure.Security.KeyVault.Secrets;
using Azure.Identity;

string keyvaultName = "demo-kv-rbac-20250910";
string keyvaultBaseUrl = "https://demo-kv-rbac-20250910.vault.azure.net/";

var secretClient = new SecretClient(new Uri(keyvaultBaseUrl), new DefaultAzureCredential());

string secretName = "demo-secret-01";
var something = secretClient.SetSecret(secretName, "01-value");

var secret = secretClient.GetSecret(secretName);

Console.WriteLine($"Secret '{secretName}' has value '{secret.Value.Value}'");
Console.ReadLine();