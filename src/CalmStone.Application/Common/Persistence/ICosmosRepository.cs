using CalmStone.Core.Common.Persistence;

namespace CalmStone.Application.Common.Persistence
{
    public interface ICosmosRepository<T>
        where T : CosmosDocument
    {
        Task<T?> GetAsync(string id, string partitionKey, CancellationToken ct);

        Task UpsertAsync(T entity, CancellationToken ct);

        Task DeleteAsync(string id, string partitionKey, CancellationToken ct);
    }
}