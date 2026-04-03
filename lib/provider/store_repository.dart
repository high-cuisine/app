import 'package:cocktails/options.dart';
import 'package:dio/dio.dart';

import '../models/store_model.dart';

class GoodsResponse {
  final List<Product> goods;
  final String? next;

  GoodsResponse({required this.goods, this.next});
}

class GoodsRepository {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppOptions.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<GoodsResponse> fetchGoods({String? url}) async {
    try {
      final response = await dio.get(url ?? '/goods/');
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        final goods = results.map((json) => Product.fromJson(json)).toList();
        final next = response.data['next'] as String?;
        return GoodsResponse(goods: goods, next: next);
      } else {
        throw Exception('Failed to load goods');
      }
    } catch (e) {
      throw Exception('Error fetching goods: $e');
    }
  }

  Future<GoodsResponse> searchGoods(String query) async {
    try {
      final response = await dio.get(
        '/goods/',
        queryParameters: {'q': query, 'page_size': 50},
      );
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        final goods = results.map((json) => Product.fromJson(json)).toList();
        final next = response.data['next'] as String?;
        return GoodsResponse(goods: goods, next: next);
      } else {
        throw Exception('Failed to search goods');
      }
    } catch (e) {
      throw Exception('Error searching goods: $e');
    }
  }
}
