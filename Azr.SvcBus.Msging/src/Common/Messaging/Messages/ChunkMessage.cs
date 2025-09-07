namespace Common.Messaging.Messages;

public record ChunkMessage(
    string FileId,
    int ChunkIndex,
    string Text
);