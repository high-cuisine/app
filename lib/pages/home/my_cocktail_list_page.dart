import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/home/create_cocktail_widgets/gradient_add_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../provider/cocktail_list_get.dart';
import '../../widgets/cocktail_list/cocktail_card.dart';
import '../../widgets/custom_arrowback.dart';
import '../../widgets/home/search_bar_widget.dart';
import 'new_recipe/new_recipe_page.dart';

class MyCocktailsListPage extends StatefulWidget {
  const MyCocktailsListPage({super.key});

  @override
  State<MyCocktailsListPage> createState() => _MyCocktailsListPageState();
}

class _MyCocktailsListPageState extends State<MyCocktailsListPage> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<CocktailListBloc>().add(FetchUserCocktails());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CocktailListBloc(CocktailRepository())
          ..add(FetchUserCocktails());
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<CocktailListBloc, CocktailListState>(
            builder: (context, state) {
              Widget content;

              // Обрабатываем различные состояния блока
              if (state is CocktailLoading) {
                content = const Center(child: CircularProgressIndicator());
              } else if (state is UserCocktailLoaded) {
                if (state.userCocktails.isEmpty) {
                  content = Center(
                    child: Text(
                      tr('my_cocktails_page.no_cocktails'),
                      style: context.text.headline20White,
                    ),
                  );
                } else {
                  content = RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<CocktailListBloc>()
                          .add(FetchUserCocktails());
                    },
                    child: ListView.builder(
                      itemCount: state.userCocktails.length,
                      itemBuilder: (context, index) {
                        return CocktailCard(
                          cocktail: state.userCocktails[index],
                          myCocktailPage: true,
                        );
                      },
                    ),
                  );
                }
              } else if (state is CocktailError) {
                content = Center(
                  child: Text(tr('errors.server_error'),
                      style: context.text.bodyText16White),
                );
              } else {
                content = Center(
                  child: Text(tr('my_cocktails_page.start_search')),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
                child: Column(
                  children: [
                    CustomAppBar(
                      text: tr('my_cocktails_page.title', namedArgs: {
                        'count': state is UserCocktailLoaded
                            ? state.userCocktails.length.toString()
                            : '0'
                      }),
                      onPressed: null,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                            child: CustomSearchBar(
                          userRecipes: true,
                        )),
                        const SizedBox(width: 8),
                        GradientAddButton(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const NewRecipePage()));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: content),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
