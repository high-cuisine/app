part of 'promo_bloc.dart';

@immutable
abstract class PromoState {}

class PromoInitial extends PromoState {}

class PromoLoading extends PromoState {}

class PromoLoaded extends PromoState {
  final List<PromoItem> promoCodes;

  PromoLoaded(this.promoCodes);
}

class PromoError extends PromoState {
  final String error;

  PromoError(this.error);
}

class PromoBought extends PromoState {
  final String promoCode;

  PromoBought(this.promoCode);
}

class PromoPurchaseError extends PromoState {
  final String errorMessage;

  PromoPurchaseError(this.errorMessage);
}

class PromoLoadedWithError extends PromoState {
  final List<PromoItem> promoCodes;
  final int failedPromoId; // ID промокода, где произошла ошибка
  final String errorMessage;

  PromoLoadedWithError(this.promoCodes, this.failedPromoId, this.errorMessage);
}
