namespace Common.Messaging.Messages;

public record FileMessage(
    string FileId,
    string FileName,
    string FileType,
    string StorageUrl
);