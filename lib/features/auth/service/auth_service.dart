import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase/supabase_client.dart';

class AuthService {
  // 1. Sign Up with Email and Password

    Future<AuthResponse> signUp(String email, String password) async{
      try {
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
        );

        return response;
      } catch (e) {
        rethrow; // Pass the error to the UI to show the message
      }
    }

    //Sign In with Email and Password

    Future<AuthResponse> signIn(String email, String password) async {
      try {
        final response = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    // 3. Sign Out

    Future<void> signOut() async{
      await supabase.auth.signOut();
    }

    //Note: Google Sign-in requires extra setup in GCP(Google Cloud Platform)
    //and Supabase Dashboard. We will set up the basic structure here.

    Future<void> signInWithGoogle() async{
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.neitzen.aida://login-callback',
      );
    }
}