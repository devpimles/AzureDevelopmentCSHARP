using Microsoft.Azure.Cosmos;

namespace CalmStone.Infrastructure.Cosmos
{
    public interface ICosmosContainerFactory
    {
        Container GetContainer(string logicalName);
    }
}