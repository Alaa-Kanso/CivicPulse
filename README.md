# CivicPulse

CivicPulse is a civic issue reporting and tracking platform designed to improve communication between citizens and municipalities.  
Citizens can submit location-based reports (with an optional photo) and track status updates, while municipality operators manage reports by region. An Admin manages operator accounts.

> Master’s Project — Computer Science

---

## Table of Contents

- [Problem / Pain Point](#problem--pain-point)
- [MVP Scope](#mvp-scope)
  - [Citizen](#citizen)
  - [Operator (Municipality)](#operator-municipality)
  - [Admin](#admin)
- [Tech Stack](#tech-stack)
- [Repository Structure](#repository-structure)
- [Running Locally](#running-locally)
  - [Prerequisites](#prerequisites)
  - [Local Configuration](#local-configuration)
  - [Exact Run Steps](#exact-run-steps)
  - [Verify Everything Works](#verify-everything-works)
- [Admin Seeding](#admin-seeding)
- [Git / Team Notes](#git--team-notes)
- [Common Troubleshooting](#common-troubleshooting)
- [Project Status](#project-status)

---

## Problem / Pain Point

In many municipalities, citizens report issues (potholes, broken streetlights, trash, etc.) through scattered channels (calls, WhatsApp, social media) with little transparency.  
This leads to lost reports, slow follow-up, and no clear status updates for citizens.

CivicPulse provides a simple, trackable workflow from **report creation → review → progress → resolution**, with accountability and better visibility for both citizens and municipalities.

---

## MVP Scope

### Citizen

- Register (email/password)
- Login
- Create a report:
  - title, description, category
  - city + region (dropdown)
  - street text (free form)
  - location (GPS / map pin)
  - photo upload _(planned)_
- View “My Reports” and track status:
  - InReview → InProgress → Done
- Receive **in-app notifications** when a report status changes _(not push notifications)_

### Operator (Municipality)

- Login (no registration)
- View reports assigned to their city/region
- Update report status (InReview / InProgress / Done)
- Mark report as **Spam**
- Anti-spam: if a citizen gets **3 spam strikes** → account is blocked

### Admin

- Website-only _(planned)_
- Creates/edits operator accounts (operators cannot self-register)

---

## Tech Stack

### Backend (current)

- ASP.NET Core Web API (**.NET 8**)
- Entity Framework Core
- PostgreSQL (Docker)
- Swagger / OpenAPI
- BCrypt password hashing

### Frontend (planned)

- Flutter (mobile app)
- Flutter Web (Admin/Operator website) _(planned)_

### File Storage (planned)

- External storage for report photos _(TBD: Supabase Storage / Google Cloud Storage)_

---

## Repository Structure

```text
CivicPulse/
  backend/
    CivicPulse.sln
    docker-compose.yml
    CivicPulse.Api/
    CivicPulse.Domain/
    CivicPulse.Infrastructure/
```

---

## Running Locally

### Prerequisites

- **.NET SDK 8**
- **Docker Desktop**
- EF Core CLI tools (install once):

```bash
dotnet tool install --global dotnet-ef
```

> Optional (recommended): VS Code extensions
>
> - C# Dev Kit (or C#)
> - Docker

---

### Local Configuration

We keep real local secrets out of git by using:

- `appsettings.json` → committed template (safe defaults, no secrets)
- `appsettings.Development.json` → local-only (contains your DB password/admin password, etc.)

### 1) Create your Development config from the example

In `backend/CivicPulse.Api/` you will find:

- `appsettings.Development.example.json` ✅ committed

Copy it and create your local dev file:

```bash
# from backend/CivicPulse.Api
cp appsettings.Development.example.json appsettings.Development.json
```

On Windows (PowerShell):

```powershell
Copy-Item appsettings.Development.example.json appsettings.Development.json
```

### 2) Fill in the placeholders

Open appsettings.Development.json and replace the placeholder values with your real local settings **(must match docker-compose.yml)**

**Important**

- Values must match your `backend/docker-compose.yml` values.
- Do **NOT** commit `appsettings.Development.json` (it contains secrets).
- If the API throws **Host can't be null**, it usually means **your connection string wasn’t loaded**.

---

### Exact Run Steps

#### 1) Start PostgreSQL with Docker

From the `backend/` folder:

```bash
docker compose up -d
```

Confirm it’s running:

```bash
docker ps
```

#### 2) Apply database migrations

From the `backend/` folder:

```powershell
dotnet ef database update `
  --project .\CivicPulse.Infrastructure\CivicPulse.Infrastructure.csproj `
  --startup-project .\CivicPulse.Api\CivicPulse.Api.csproj
```

#### (Optional) Ensure the app runs in **Development** environment

ASP.NET Core usually runs as `Development` locally, but if you ever notice it’s not loading
`appsettings.Development.json`, you can force the environment.

> > inside the backend folder

**PowerShell (Windows):**

```powershell
$env:ASPNETCORE_ENVIRONMENT="Development"
dotnet run --project .\CivicPulse.Api\CivicPulse.Api.csproj
```

**Bash (macOS/Linux):**

```bash
export ASPNETCORE_ENVIRONMENT=Development
dotnet run --project ./CivicPulse.Api/CivicPulse.Api.csproj
```

#### 3) Run the API

From the `backend/` folder:

```bash
dotnet run --project .\CivicPulse.Api\CivicPulse.Api.csproj
```

---

### Verify Everything Works

#### Swagger (API Docs)

When the API is running, open:

- `https://localhost:<PORT>/swagger`

> `<PORT>` is shown in the terminal output when you run the API.

#### Health + DB Ping

- `GET https://localhost:<PORT>/api/health`
- `GET https://localhost:<PORT>/api/db-ping`

---

## Admin Seeding

On startup, the API seeds a default **Admin** user using:

- `AdminSeed.Email`
- `AdminSeed.Password`

from configuration (in local dev, from `appsettings.Development.json`).

This is for development convenience so the system always has an Admin account available.

---

## Git / Team Notes

### What should NOT be committed?

- `appsettings.Development.json` (secrets)
- `bin/`, `obj/` folders

Make sure `.gitignore` includes them (example):

```gitignore
**/bin/
**/obj/
appsettings.Development.json
```

---

## Common Troubleshooting

### Docker error: cannot connect to docker engine

- Ensure **Docker Desktop is running**
- Re-run:

```bash
docker compose up -d
```

### EF migration error: “Host can't be null”

- Your connection string is missing or not being loaded.
- Confirm `backend/CivicPulse.Api/appsettings.Development.json` exists and contains:

```json
{
  "ConnectionStrings": { "CivicPulseDb": "..." }
}
```

---

## Project Status

- ✅ Database + migrations working locally
- ✅ Health + DB Ping endpoints
- ✅ DTO scaffolding
- ✅ Admin seeding (local)
