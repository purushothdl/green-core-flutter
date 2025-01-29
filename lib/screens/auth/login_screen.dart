// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:green_core/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/waste_provider.dart';
import '../../widgets/shared/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final wasteProvider = Provider.of<WasteProvider>(context, listen: false);
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);

        await context.read<AuthProvider>().loginUser(
              _emailController.text,
              _passwordController.text,
            );
        await authProvider.fetchUserDetails(forceRefresh: true);
        await wasteProvider.fetchAllData(forceRefresh: true);
        await profileProvider.fetchUserDetails(forceRefresh: true);
        if (authProvider.user != null) {
          await chatProvider.loadUserChats(authProvider.user!.id.toString());
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🌿 Welcome back to GreenCore!'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/register');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white, 
        body: DecoratedBox(
          decoration: const BoxDecoration(),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildLoginForm(),
                  const SizedBox(height: 24),
                  _buildFooterLinks(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset('assets/logo/logo.png', height: 100),
        const SizedBox(height: 20),
        Text(
          'Welcome Back',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2E7D32),
                letterSpacing: 0.8,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Continue your eco-friendly journey',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF455A64),
              ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildEmailField(),
            const SizedBox(height: 20),
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildForgotPassword(),
            const SizedBox(height: 32),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Color(0xFF455A64)),
      decoration: InputDecoration(
        labelText: 'Email Address',
        labelStyle: const TextStyle(color: Color(0xFF78909C)),
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF81C784)),
        filled: true,
        fillColor: const Color(0xFFF1F8E9).withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF81C784), width: 2),
        ),
      ),
      validator: (value) => !value!.contains('@') ? 'Enter a valid email' : null,
    );
  }

Widget _buildPasswordField() {
  return StatefulBuilder(
    builder: (context, setState) {
      return TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible, // Toggle visibility
        style: const TextStyle(color: Color(0xFF455A64)),
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(color: Color(0xFF78909C)),
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF81C784)),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible; // Toggle state
              });
            },
            icon: Icon(
              Icons.eco, // Leaf icon
              color: _isPasswordVisible
                  ? const Color(0xFF2E7D32) // Dark green when visible
                  : const Color(0xFF81C784).withOpacity(0.6), // Light green when hidden
            ),
          ),
          filled: true,
          fillColor: const Color(0xFFF1F8E9).withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF81C784), width: 2),
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Enter your password' : null,
      );
    },
  );
}

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF2E7D32),
        ),
        child: const Text(
          'Forgot Password?',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: authProvider.isLoading ? null : () => _login(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF2E7D32),
              shadowColor: Colors.green[100],
              elevation: 4,
            ),
            child: authProvider.isLoading
                ? const LoadingWidget()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        'Continue to GreenCore',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
Widget _buildFooterLinks() {
  return Column(
    children: [
      const SizedBox(height: 24),
      Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the row
        children: [
          Text(
            'New to GreenCore? ',
            style: TextStyle(
              color: const Color(0xFF78909C).withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4), // Space between text and button
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // Remove default padding
              minimumSize: Size.zero, // Remove minimum size
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink tap target
              foregroundColor: Colors.green, // Green color
            ),
            child: const Text(
              'Create Account',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
}