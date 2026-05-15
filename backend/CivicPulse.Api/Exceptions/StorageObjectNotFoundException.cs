namespace CivicPulse.Api.Exceptions;

public sealed class StorageObjectNotFoundException : Exception
{
    public StorageObjectNotFoundException(string message) : base(message) { }
}