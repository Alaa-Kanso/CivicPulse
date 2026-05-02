# frontend

A new Flutter project.

## Getting Started

📱 Connecting Flutter App to Local Backend

To allow the Flutter mobile app to communicate with the local ASP.NET API, you must expose the
backend to your local network and configure the correct base URL.

1) Configure ASP.NET to Accept External Connections

By default, ASP.NET runs only on localhost, which is not accessible from a physical device or
emulator.

Update the following file:

backend/CivicPulse.Api/Properties/launchSettings.json

Modify the applicationUrl:

"applicationUrl": "http://0.0.0.0:5139
- Why 0.0.0.0?
  - Allows the API to listen on all network interfaces
  - Makes the backend accessible from other devices on the same network

2) Get Your Local IPv4 Address

Run the following command:

    ipconfig

Look for:

      IPv4 Address . . . . . . . . . . : 192.168.X.X

This is your local network IP address.

3) Configure Flutter Base URL

In your Flutter project (e.g., DioClient), set the base URL:

      baseUrl = "http://<YOUR_IPV4>:5139/api";

Example:

      baseUrl = "http://192.168.0.194:5139/api";

4) Requirements: 
   - Backend and mobile device must be on the same Wi-Fi network
   - Backend must be running
   - Port must match (5139 in this example)
   - Do not use localhost or 127.0.0.1 on a physical device
5) HTTPS (Development Note)

- Using HTTPS locally may result in certificate errors such as:

  - Your connection is not private

  - This is due to self-signed development certificates.

Recommendation: use HTTP for local development:

      http://<YOUR_IPV4>:5139

6) Troubleshooting
- Mobile shows “No Internet Connection”
- Verify the correct IPv4 address
- Ensure backend is running
- Ensure both devices are on the same network
- Check firewall settings
- Cannot access Swagger from phone

Try:

      http://<YOUR_IPV4>:5139/swagger

If it fails:

- Ensure ASP.NET is listening on 0.0.0.0
- Check firewall rules