using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CivicPulse.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddClientTypeToRefreshTokenSession : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_RefreshTokenSessions_UserId",
                table: "RefreshTokenSessions");

            migrationBuilder.AddColumn<int>(
                name: "ClientType",
                table: "RefreshTokenSessions",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_RefreshTokenSessions_UserId_ClientType",
                table: "RefreshTokenSessions",
                columns: new[] { "UserId", "ClientType" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_RefreshTokenSessions_UserId_ClientType",
                table: "RefreshTokenSessions");

            migrationBuilder.DropColumn(
                name: "ClientType",
                table: "RefreshTokenSessions");

            migrationBuilder.CreateIndex(
                name: "IX_RefreshTokenSessions_UserId",
                table: "RefreshTokenSessions",
                column: "UserId");
        }
    }
}
