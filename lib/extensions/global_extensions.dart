import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:publrealty/exceptions/response_error.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/providers/authentication_provider.dart';

extension GlobalExtensions on State {
  void handleException(Object error) {
    final localization = AppLocalizations.of(context);

    if (error is DioError) {
      final errorType = error;
      if (errorType.response?.statusCode == 401) {
        if (mounted) {
          AuthenticationProvider.of(context).logout();
        }
      }
    } else if (error is ResponseError) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(error.message ?? ""),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localization.okUpper),
            ),
          ],
        ),
      );
    }
  }

  showLoading() {
    EasyLoading.show();
  }

  hideLoading() {
    EasyLoading.dismiss();
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
