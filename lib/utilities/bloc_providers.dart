import 'package:cocktails/bloc/app_start_bloc/app_start_bloc.dart';
import 'package:cocktails/bloc/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:cocktails/bloc/catalog_filter_bloc/catalog_filter_bloc.dart';
import 'package:cocktails/bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import 'package:cocktails/bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';
import 'package:cocktails/bloc/create_cocktail_bloc/create_cocktail_bloc.dart';
import 'package:cocktails/bloc/deep_link_bloc/deep_link_bloc.dart';
import 'package:cocktails/bloc/notification_bloc/notification_bloc.dart';
import 'package:cocktails/bloc/notification_settings_bloc/notification_settings_bloc.dart';
import 'package:cocktails/bloc/profile_bloc/profile_bloc.dart';
import 'package:cocktails/bloc/standart_auth_bloc/standart_auth_bloc.dart';
import 'package:cocktails/provider/cocktail_auth_repository.dart';
import 'package:cocktails/provider/cocktail_list_get.dart';
import 'package:cocktails/provider/notification_repository.dart';
import 'package:cocktails/provider/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/avatar_cubit/avatar_cubit.dart';
import '../bloc/goods_bloc/goods_bloc.dart';
import '../bloc/referal_bloc/referal_bloc.dart';
import '../provider/store_repository.dart';

abstract class BlocProviders {
  static get getProviders => [
        BlocProvider<AlcoholicCocktailBloc>(
          create: (context) => AlcoholicCocktailBloc(CocktailRepository()),
        ),
        BlocProvider<NonAlcoholicCocktailBloc>(
          create: (context) => NonAlcoholicCocktailBloc(CocktailRepository()),
        ),
        BlocProvider(create: (context) => DeepLinkNavigationBloc()),
        BlocProvider(
          create: (context) => CocktailCreationBloc(CocktailRepository()),
        ),
        BlocProvider(
          create: (context) => IngredientSelectionBloc(CocktailRepository()),
        ),
        BlocProvider(
          create: (context) => CocktailSelectionBloc(CocktailRepository()),
        ),
        BlocProvider(
          create: (context) => AppBloc(AuthRepository())..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => CocktailListBloc(CocktailRepository()),
        ),
        BlocProvider(create: (context) => BottomNavigationBloc()),
        BlocProvider(create: (context) => NotificationSettingsBloc()),
        BlocProvider(
          create: (context) => ProfileImageCubit()..loadProfileImage(),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(NotificationRepository())
            ..add(LoadNotifications()),
        ),
        BlocProvider(
          create: (context) =>
              ProfileBloc(ProfileRepository())..add(FetchProfile()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository()),
        ),
        BlocProvider<GoodsBloc>(
            create: (context) =>
                GoodsBloc(GoodsRepository())..add(FetchGoods())),
        BlocProvider<ReferralBloc>(
          create: (context) => ReferralBloc(ProfileRepository()),
        )
      ];
}
