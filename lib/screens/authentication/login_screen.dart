import 'package:flutter/material.dart';
import 'package:publrealty/components/publ_primary_button.dart';
import 'package:publrealty/components/publ_text_field.dart';
import 'package:publrealty/extensions/global_extensions.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/providers/authentication_provider.dart';
import 'package:publrealty/providers/liked_properties_provider.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/themes/app_themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Login'),
          leading: Padding(
            padding: const EdgeInsets.all(7.5), // Adjust padding as needed
            child: Image.asset(
              'assets/images/logo.png', // Path to your logo image
              width: 160, // Adjust the width as needed
              height: 160, // Adjust the height as needed
            ),
          ),
        ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          localization.login,
                          style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w300,
                              color: theme.primaryColor),
                        ),
                        const SizedBox(height: 24),
                        PublTextField(
                          controller: usernameController,
                          placeHolder: localization.username,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.pleaseEnterText;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        PublTextField(
                          controller: passwordController,
                          placeHolder: localization.password,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.pleaseEnterText;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        PublPrimaryButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                showLoading();
                                final authResult = await ApiService.login(
                                    usernameController.text,
                                    passwordController.text);

                                if (authResult.user != null &&
                                    authResult.token != null) {
                                  if (!mounted) return;
                                  await AuthenticationProvider.of(context)
                                      .login(
                                          authResult.user!, authResult.token!);
                                  if (!mounted) return;
                                  await LikedPropertiesProvider.of(context)
                                      .fetchLikedProperties();
                                  if (!mounted) return;
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                }
                              } catch (e) {
                                handleException(e);
                              } finally {
                                hideLoading();
                              }
                            }
                          },
                          minHeight: 48,
                          title: localization.loginUpper,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/register");
                          },
                          child: Text(
                            localization.registerUpper,
                            style: TextStyle(
                              color: theme.customLabelColor.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              end: 12,
              top: 4,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                icon: Icon(
                  Icons.close_rounded,
                  size: 32,
                  color: theme.customBlackColor.withOpacity(0.7),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
