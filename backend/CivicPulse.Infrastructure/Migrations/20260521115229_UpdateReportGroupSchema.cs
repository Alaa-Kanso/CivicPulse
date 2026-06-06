using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CivicPulse.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class UpdateReportGroupSchema : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_ReportGroups_MunicipalityId",
                table: "ReportGroups");

            migrationBuilder.DropColumn(
                name: "RadiusMeters",
                table: "ReportGroups");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "ReportGroups");

            migrationBuilder.RenameColumn(
                name: "Center",
                table: "ReportGroups",
                newName: "CenterLocation");

            migrationBuilder.RenameIndex(
                name: "IX_ReportGroups_Center",
                table: "ReportGroups",
                newName: "IX_ReportGroups_CenterLocation");

            migrationBuilder.CreateIndex(
                name: "IX_ReportGroups_MunicipalityId_ReportTypeId",
                table: "ReportGroups",
                columns: new[] { "MunicipalityId", "ReportTypeId" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_ReportGroups_MunicipalityId_ReportTypeId",
                table: "ReportGroups");

            migrationBuilder.RenameColumn(
                name: "CenterLocation",
                table: "ReportGroups",
                newName: "Center");

            migrationBuilder.RenameIndex(
                name: "IX_ReportGroups_CenterLocation",
                table: "ReportGroups",
                newName: "IX_ReportGroups_Center");

            migrationBuilder.AddColumn<double>(
                name: "RadiusMeters",
                table: "ReportGroups",
                type: "double precision",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddColumn<int>(
                name: "Status",
                table: "ReportGroups",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_ReportGroups_MunicipalityId",
                table: "ReportGroups",
                column: "MunicipalityId");
        }
    }
}
