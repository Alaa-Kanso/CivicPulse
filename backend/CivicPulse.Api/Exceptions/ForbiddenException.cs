namespace CivicPulse.Api.Exceptions;

public sealed class ForbiddenException : Exception
{
    public ForbiddenException(string message) : base(message) { }
}