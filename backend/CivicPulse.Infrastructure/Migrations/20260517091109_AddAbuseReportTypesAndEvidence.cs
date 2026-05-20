using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CivicPulse.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddAbuseReportTypesAndEvidence : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AbuseReports_Reports_ReportId",
                table: "AbuseReports");

            migrationBuilder.AddColumn<int>(
                name: "Type",
                table: "AbuseReports",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "AbuseReportEvidences",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AbuseReportId = table.Column<Guid>(type: "uuid", nullable: false),
                    ReportId = table.Column<Guid>(type: "uuid", nullable: false),
                    AddedAtUtc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AbuseReportEvidences", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AbuseReportEvidences_AbuseReports_AbuseReportId",
                        column: x => x.AbuseReportId,
                        principalTable: "AbuseReports",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AbuseReportEvidences_Reports_ReportId",
                        column: x => x.ReportId,
                        principalTable: "Reports",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AbuseReportEvidences_AbuseReportId_ReportId",
                table: "AbuseReportEvidences",
                columns: new[] { "AbuseReportId", "ReportId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AbuseReportEvidences_ReportId",
                table: "AbuseReportEvidences",
                column: "ReportId");

            migrationBuilder.AddForeignKey(
                name: "FK_AbuseReports_Reports_ReportId",
                table: "AbuseReports",
                column: "ReportId",
                principalTable: "Reports",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AbuseReports_Reports_ReportId",
                table: "AbuseReports");

            migrationBuilder.DropTable(
                name: "AbuseReportEvidences");

            migrationBuilder.DropColumn(
                name: "Type",
                table: "AbuseReports");

            migrationBuilder.AddForeignKey(
                name: "FK_AbuseReports_Reports_ReportId",
                table: "AbuseReports",
                column: "ReportId",
                principalTable: "Reports",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
