class ApiEndpoints {
  static const String baseUrl = "https://65c1-117-213-147-133.ngrok-free.app";

  // Auth Endpoints
  static const String register = "$baseUrl/api/users/register";
  static const String login = "$baseUrl/api/users/login";
  static const String me = "$baseUrl/api/users/me";

  // Waste Endpoints
  static const String disposeWaste = "$baseUrl/api/waste/dispose";
  static const String wasteHistory = "$baseUrl/api/waste/history";

  // Orgs Endpoints
  static const String getOrgs = "$baseUrl/api/orgs/nearby";

  // Chat Endpoints
  static const String startChat = "$baseUrl/api/chats/start";
  static const String continueChat = "$baseUrl/api/chats/continue";
  static const String endChat = "$baseUrl/api/chats/end/{session_id}";

  // FAQs Endpoint
  static const String getFAQs = "$baseUrl/api/faqs/";
}