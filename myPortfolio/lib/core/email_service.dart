import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  // ⚠️ REPLACE THESE WITH YOUR ACTUAL EMAILJS VALUES
  static const String _serviceId  = 'service_8mg02ix';
  static const String _templateId = 'template_izyrtcj';
  static const String _publicKey  = 'z84xFVQHmSdRDrorg';

  static const String _endpoint = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Sends the contact form data via EmailJS.
  /// Returns true if successful, false otherwise.
  static Future<bool> sendMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'from_name': name,
            'from_email': email,
            'message': message,
          },
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}