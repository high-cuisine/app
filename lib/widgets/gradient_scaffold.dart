import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;

  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: Colors.transparent,
      // Делает Scaffold прозрачным
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.pink],
            // Задайте свои цвета градиента
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: body,
        ),
      ),
    );
  }
}
