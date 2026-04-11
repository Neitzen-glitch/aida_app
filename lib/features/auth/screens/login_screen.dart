import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../service/auth_service.dart';
import '../../../main.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isSignUp = false; // Toggle Between Login And SignUp

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // Helper method to show mesage to the user
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  Future<void> _submitAuth() async {
    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (_isSignUp) {
        await _authService.signUp(email, password);

        _showMessage("Check your email to confirm registration!");
      } else {
        await _authService.signIn(email, password); 
        
        // If successful, navigate to the Dashboard
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainNavigationWrapper()),
          );
        }
      }
    } on AuthException catch (error) {
      _showMessage(error.message, isError: true);
    } catch (e) {
      _showMessage("An unexpected error occured.", isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/icons/logo.png', height: 80),
              const SizedBox(height: 16),
              const Text("AIDA", textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),

              const Text("Global Business OS by Neitzen", textAlign: TextAlign.center,),
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
              ),

              const SizedBox(height: 24),

              // Login / SignUp Button
              ElevatedButton(
                onPressed: _isLoading ? null :_submitAuth,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) :Text(_isSignUp ? "Create Account" : "Sign In"),
              ),

              TextButton(
                onPressed: () => setState(() => _isSignUp = ! _isSignUp),
                child: Text(_isSignUp ? "Already have an account? Sign In" : "Need an account? Sign Up"),
              ),

              const Divider(height: 40),

              // Google Auth Button
              OutlinedButton.icon(
                onPressed: _isLoading ? null : () => _authService.signInWithGoogle(),
                icon: const Icon(Icons.login),
                label: const Text("Continue with Google"),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

