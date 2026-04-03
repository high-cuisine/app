import 'package:cocktails/pages/catalog/pop_up/filter_pop_up.dart';
import 'package:cocktails/widgets/catalog_widgets/catalog_fetch_list.dart';
import 'package:cocktails/widgets/catalog_widgets/catalog_search_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../widgets/catalog_widgets/custom_tab_indicator.dart';
import '../../widgets/custom_arrowback.dart';
import '../../widgets/home/search_bar_widget.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // В каталоге используются отдельные блоки для Alco/Non‑Alco вкладок.
      // Грузим оба списка сразу, иначе вкладки могут оставаться пустыми.
      context
          .read<AlcoholicCocktailBloc>()
          .add(const FetchCocktails(page: 1, pageSize: 20, alc: true));
      context
          .read<NonAlcoholicCocktailBloc>()
          .add(const FetchCocktails(page: 1, pageSize: 20, alc: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Количество вкладок
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
            child: Column(
              children: [
                /// Верхний бар
                CustomAppBar(
                  text: tr('catalog_page.title'),
                  onPressed: null,
                  secondIcon: true,
                  arrow: false,
                  onSecondIconTap: () {
                    openFilterModal(context, true);
                  },
                ),
                const SizedBox(height: 10),

                /// Поле поиска
                CustomSearchBar(
                  controller: editingController,
                ),
                const SizedBox(height: 16),

                /// Вкладки
                TabBar(
                  labelColor: Colors.white,
                  // Цвет активной вкладки
                  unselectedLabelColor: Colors.grey,
                  // Цвет неактивной вкладки
                  indicator: CustomTabIndicator(),
                  // Кастомный индикатор
                  indicatorWeight: 0.0,
                  dividerHeight: 0,

                  tabs: [
                    Tab(text: tr('catalog_page.alco')), // Алко
                    Tab(text: tr('catalog_page.nonAlco')), // Безалко
                  ],
                ),

                /// Содержимое вкладок
                Expanded(
                  child: TabBarView(
                    children: [
                      /// Вкладка 1: алкогольные
                      BlocBuilder<AlcoholicCocktailBloc, CocktailListState>(
                        builder: (context, state) {
                          if (state is CocktailLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is CocktailLoaded) {
                            return CatalogFetchList(
                              catalogPage: true,
                              alcoholPage: true,
                              fetchList: state.cocktails,
                              hasReachedMax: state.hasReachedMax,
                            );
                          } else if (state is CocktailSearchLoaded) {
                            return CatalogSearchList(
                              catalogPage: true,
                              alcoholPage: true,
                              searchList: state.cocktails,
                              hasReachedMax: state.hasReachedMax,
                              query: editingController.text,
                              searchPage: true,
                            );
                          } else if (state is CocktailError) {
                            return Center(
                              child: Text(tr('errors.server_error')),
                            );
                          }
                          return Center(
                            child: Text(tr('catalog_page.start_search')),
                          );
                        },
                      ),

                      /// Вкладка 2: безалкогольные
                      BlocBuilder<NonAlcoholicCocktailBloc, CocktailListState>(
                        builder: (context, state) {
                          if (state is CocktailLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is CocktailLoaded) {
                            return CatalogFetchList(
                              catalogPage: true,
                              alcoholPage: false,
                              fetchList: state.cocktails,
                              hasReachedMax: state.hasReachedMax,
                            );
                          } else if (state is CocktailSearchLoaded) {
                            return CatalogSearchList(
                              catalogPage: true,
                              alcoholPage: false,
                              searchList: state.cocktails,
                              hasReachedMax: state.hasReachedMax,
                              query: editingController.text,
                              searchPage: true,
                            );
                          } else if (state is CocktailError) {
                            return Center(
                              child: Text(tr('errors.server_error')),
                            );
                          }
                          return Center(
                            child: Text(tr('catalog_page.start_search')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
