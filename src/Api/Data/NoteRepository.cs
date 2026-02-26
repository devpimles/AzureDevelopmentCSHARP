using Api.Domain;
using Api.Middleware.MultiTenancy;
using Microsoft.Azure.Cosmos;

namespace Api.Data
{
    public sealed class NoteRepository
    {
        private readonly Container _container;
        private readonly ITenantContextAccessor _tenant;

        public NoteRepository(
            Database database,
            ITenantContextAccessor tenant)
        {
            _container = database.GetContainer("notes");
            _tenant = tenant;
        }

        private string TenantId => _tenant.Current!.TenantId;

        public async Task<Note> CreateAsync(string content)
        {
            var note = new Note
            {
                id = Guid.NewGuid().ToString(),
                tenantId = TenantId,
                content = content
            };

            var response = await _container.CreateItemAsync(
                note,
                new PartitionKey(TenantId));

            return response.Resource;
        }

        public async Task<IReadOnlyList<Note>> GetAllAsync()
        {
            var query = new QueryDefinition(
                "SELECT * FROM c WHERE c.tenantId = @tenantId")
                .WithParameter("@tenantId", TenantId);

            var iterator = _container.GetItemQueryIterator<Note>(
                query,
                requestOptions: new QueryRequestOptions
                {
                    PartitionKey = new PartitionKey(TenantId)
                });

            var results = new List<Note>();

            while (iterator.HasMoreResults)
            {
                var response = await iterator.ReadNextAsync();
                results.AddRange(response);
            }

            return results;
        }

        public async Task<Note?> GetByIdAsync(string id)
        {
            try
            {
                var response = await _container.ReadItemAsync<Note>(
                    id,
                    new PartitionKey(TenantId));

                return response.Resource;
            }
            catch (CosmosException ex) when (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
            {
                return null;
            }
        }

        public async Task<bool> UpdateAsync(string id, string content)
        {
            var existing = await GetByIdAsync(id);
            if (existing == null)
                return false;

            existing.content = content;

            await _container.ReplaceItemAsync(
                existing,
                id,
                new PartitionKey(TenantId));

            return true;
        }

         public async Task<bool> DeleteAsync(string id)
        {
            try
            {
                await _container.DeleteItemAsync<Note>(
                    id,
                    new PartitionKey(TenantId));

                return true;
            }
            catch (CosmosException ex) when (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
            {
                return false;
            }
        }
    }
}