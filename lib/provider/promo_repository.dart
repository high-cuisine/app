import '../models/promo_model.dart';
import 'dio_service.dart';

class PromoRepository {
  final DioService dio = DioService();

  Future<List<PromoItem>> fetchPromoCodes() async {
    try {
      final response = await dio.dio.get('/promo/');
      if (response.statusCode == 200) {
        final data = response.data;

        // Обработка доступных промокодов
        List<PromoItem> availablePromos = (data['available_promos'] as List)
            .map((item) => PromoItem.fromJson(item))
            .toList();

        // Обработка купленных промокодов, если ключ существует
        List<PromoItem> purchasedPromos = (data['purchased_promos'] as List?)
                ?.map((item) => PromoItem.fromJson(item))
                .toList() ??
            [];

        // Объединяем доступные и купленные промокоды в один список
        return purchasedPromos + availablePromos;
      } else {
        throw Exception('Failed to load promo codes');
      }
    } catch (e) {
      throw Exception('Error fetching promo codes: $e');
    }
  }

  Future<String> buyPromoCode(int promoId) async {
    try {
      final response = await dio.dio.post('/promo/buy/', data: {
        'promo_id': promoId,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        return data['promo_code']; // Возвращаем промокод
      } else if (response.statusCode == 400) {
        throw Exception('Недостаточно баллов для покупки');
      } else {
        throw Exception('Ошибка при покупке промокода');
      }
    } catch (e) {
      throw Exception('Error buying promo code: $e');
    }
  }
}
