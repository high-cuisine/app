part of 'deep_link_bloc.dart';

abstract class DeepLinkNavigationState {}

class DeepLinkNavigationInitial extends DeepLinkNavigationState {}

class DeepLinkNavigationOpenRecipe extends DeepLinkNavigationState {
  final int cocktailId;

  DeepLinkNavigationOpenRecipe(this.cocktailId);
}
