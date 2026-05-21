using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Api.Dtos.AdminRouting;

public sealed class RerouteAdminRoutedReportRequestDto
{
    [Required]
    public long MunicipalityId { get; set; }
}