import 'package:cocktails/pages/store/product_card.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/goods_bloc/goods_bloc.dart';
import '../../widgets/custom_arrowback.dart';
import '../../widgets/store/goods_search_bar.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    const threshold = 100.0;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= threshold) {
      context.read<GoodsBloc>().add(FetchMoreGoods());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(
            children: [
              CustomAppBar(
                text: tr('store.title'),
                arrow: false,
                auth: false,
                onPressed: null,
              ),
              const SizedBox(height: 16),
              const GoodsSearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<GoodsBloc, GoodsState>(
                  builder: (context, state) {
                    if (state is GoodsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GoodsLoaded) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            state.goods.length + (state.next != null ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < state.goods.length) {
                            final product = state.goods[index];
                            return ProductCard(
                              name: product.name ??
                                  tr("store.default_product_name"),
                              imageUrl: product.photo ?? '',
                              price: product.price,
                              product: product,
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      );
                    } else if (state is GoodsError) {
                      return Center(
                        child: Text(
                          tr('errors.server_error'),
                          style: context.text.bodyText16White,
                        ),
                      );
                    }
                    return Center(child: Text(tr('store.empty_message')));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
