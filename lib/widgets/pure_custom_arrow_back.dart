import 'package:cocktails/bloc/app_start_bloc/app_start_bloc.dart';
import 'package:cocktails/pages/welcome_page.dart';
import 'package:cocktails/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PureCustomArrowBack extends StatelessWidget {
  const PureCustomArrowBack({super.key, this.isFromDeepLink});

  final bool? isFromDeepLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.75),
          width: 1.5,
        ),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          'assets/images/arrow_back.svg',
          width: 13,
          height: 13,
        ),
        iconSize: 30.0,
        onPressed: () {
          isFromDeepLink != null && isFromDeepLink == true
              ? Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                  return BlocBuilder<AppBloc, AppState>(
                    builder: (context, state) {
                      if (state is AppInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AppAuthenticated) {
                        return const CustomBottomNavigationBar();
                      } else if (state is AppUnauthenticated) {
                        return const WelcomePage();
                      } else {
                        return const Center(
                          child: Text('Unexpected state!'),
                        );
                      }
                    },
                  );
                }), (route) => false)
              : Navigator.of(context).pop(true);
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: 24.0,
        tooltip: 'Back',
      ),
    );
  }
}
