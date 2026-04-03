import 'package:app_links/app_links.dart';
import 'package:cocktails/bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import 'package:cocktails/pages/cocktail_card_page/cocktail_card_screen.dart';
import 'package:cocktails/pages/welcome_page.dart';
import 'package:cocktails/theme/themes.dart';
import 'package:cocktails/utilities/adaptive_size.dart';
import 'package:cocktails/utilities/bloc_providers.dart';
import 'package:cocktails/utilities/language_swich.dart';
import 'package:cocktails/widgets/bottom_nav_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/app_start_bloc/app_start_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();

  // Инициализируем in-memory кэш из SharedPreferences
  await LanguageService.getLanguage();
  // Если easy_localization сохранил другую локаль — синхронизируемся
  await LanguageService.syncFromEasyLocalization();

  final savedLanguage = LanguageService.currentLanguage;
  final startLocale = savedLanguage == 'rus'
      ? const Locale('ru')
      : const Locale('en');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(EasyLocalization(
        supportedLocales: const [Locale('en', ''), Locale('ru', '')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', ''),
        startLocale: startLocale,
        saveLocale: false,
        child: const MainApp()));
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.getProviders,
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  String? _deepLink;

  @override
  void initState() {
    super.initState();
    _initializeDeepLinkListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale;
    final lang = locale.languageCode == 'ru' ? 'rus' : 'eng';
    if (LanguageService.currentLanguage != lang) {
      LanguageService.saveLanguage(lang);
    }
  }

  void _initializeDeepLinkListener() async {
    _appLinks = AppLinks();

    // Слушатель для обработанных ссылок
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    // Проверка активной ссылки при старте
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
  }

  void _handleDeepLink(Uri uri) {
    if (uri.pathSegments.contains('recipe')) {
      final id = uri.pathSegments.last;
      debugPrint(id);
      if (id.isNotEmpty) {
        setState(() {
          _deepLink = uri.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SizeConfig().init(context);
        });
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mr. Barmister',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          scrollBehavior: const _NoStretchScrollBehavior(),
          home: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              if (_deepLink != null) {
                context
                    .read<CocktailListBloc>()
                    .add(FetchCocktailById(_deepLink!.split('/').last));
                return CocktailCardScreen(
                  userId: null,
                );
              } else if (state is AppInitial) {
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
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _NoStretchScrollBehavior extends MaterialScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Отключаем "подпрыгивание"/растяжение на iOS, делаем поведение как на Android
    return const ClampingScrollPhysics();
  }
}
