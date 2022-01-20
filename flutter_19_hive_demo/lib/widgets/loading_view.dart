import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (Platform.isIOS)
            ? const Center(child: CupertinoActivityIndicator())
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}