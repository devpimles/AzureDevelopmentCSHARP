namespace Api.Domain;

public class Note
{
    public string id { get; set; } = Guid.NewGuid().ToString();
    public string tenantId { get; set; } = default!;
    public string content { get; set; } = default!;
}