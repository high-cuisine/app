import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import '../pages/account/account_page.dart';
import '../pages/catalog/catalog_page.dart';
import '../pages/home/home_page.dart';
import '../pages/store/store_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey<NavigatorState>> navigatorKeys = [
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
    ];

    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          int currentIndex = _getCurrentIndex(state);

          return WillPopScope(
            onWillPop: () async {
              // Check if the current tab's Navigator can go back
              if (navigatorKeys[currentIndex].currentState?.canPop() ?? false) {
                navigatorKeys[currentIndex].currentState?.pop(true);
                return false; // Prevent exiting the app
              }
              return true; // Allow app to exit
            },
            child: _buildNavigator(
                currentIndex, navigatorKeys[currentIndex], state),
          );
        },
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE76E24).withOpacity(0.15),
                    spreadRadius: 120,
                    blurRadius: 140,
                    offset: const Offset(0, 5),
                    blurStyle: BlurStyle.normal,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF0B0B0B),
                currentIndex: _getCurrentIndex(state),
                onTap: (index) {
                  switch (index) {
                    case 0:
                      BlocProvider.of<BottomNavigationBloc>(context)
                          .add(NavigateToHome());
                      break;
                    case 1:
                      BlocProvider.of<BottomNavigationBloc>(context)
                          .add(NavigateToCatalog());
                      break;
                    case 2:
                      BlocProvider.of<BottomNavigationBloc>(context)
                          .add(NavigateToStore());
                      break;
                    case 3:
                      BlocProvider.of<BottomNavigationBloc>(context)
                          .add(NavigateToAccount());
                      break;
                  }
                },
                items: [
                  _buildBottomNavigationBarItem(
                    icon: 'assets/images/home_icon.svg',
                    label: tr('bottom_nav.home'),
                    // Локализованный заголовок для главной страницы
                    isSelected: state is HomePageState,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: 'assets/images/book_icon.svg',
                    label: tr('bottom_nav.catalog'),
                    // Локализованный заголовок для каталога
                    isSelected: state is CatalogPageState,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: 'assets/images/store_icon.svg',
                    label: tr('bottom_nav.store'),
                    // Локализованный заголовок для магазина
                    isSelected: state is StorePageState,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: 'assets/images/account_icon.svg',
                    label: tr('bottom_nav.account'),
                    // Локализованный заголовок для аккаунта
                    isSelected: state is AccountPageState,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavigator(
      int index, GlobalKey<NavigatorState> key, BottomNavigationState state) {
    Widget child;
    if (state is HomePageState) {
      child = const HomePage();
    } else if (state is CatalogPageState) {
      child = const CatalogPage();
    } else if (state is StorePageState) {
      child = const StorePage();
    } else if (state is AccountPageState) {
      child = const AccountPage();
    } else {
      child = const HomePage(); // Default to HomePage
    }

    return Navigator(
      key: key,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }

  int _getCurrentIndex(BottomNavigationState state) {
    if (state is HomePageState) return 0;
    if (state is CatalogPageState) return 1;
    if (state is StorePageState) return 2;
    if (state is AccountPageState) return 3;
    return 0;
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          SvgPicture.asset(
            icon,
            width: 18,
            height: 18,
            color: isSelected ? Colors.white : const Color(0xFFB7B7B7),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFFB7B7B7),
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 3,
              width: 24,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF8C82C),
                    Color(0xFFEF7F31),
                    Color(0xFFDD66A9),
                  ],
                ),
              ),
            ),
        ],
      ),
      label: '',
    );
  }
}
