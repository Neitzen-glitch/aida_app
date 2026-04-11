import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig{
  static const String url = 'https://ebaywbgptzeelndwndtp.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImViYXl3YmdwdHplZWxuZHduZHRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ2NDQ0NTAsImV4cCI6MjA5MDIyMDQ1MH0.ZWt-932RmaQhE1yWGrW0cpfaIYG9ms891m2IqkiBQjw';
  static Future<void> initialize() async{
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}

// Global shortcut to access the client.

final supabase = Supabase.instance.client;