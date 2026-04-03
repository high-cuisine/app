import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'deep_link_event.dart';
part 'deep_link_state.dart';

class DeepLinkNavigationBloc
    extends Bloc<DeepLinkNavigationEvent, DeepLinkNavigationState> {
  DeepLinkNavigationBloc() : super(DeepLinkNavigationInitial()) {
    on<AppLinkEvent>(_handleAppLinkEvent);
  }

  void _handleAppLinkEvent(
      AppLinkEvent event, Emitter<DeepLinkNavigationState> emit) {
    debugPrint('Received URI: ${event.uri}');
    final pathSegments = event.uri.pathSegments;

    if (pathSegments.length >= 2 && pathSegments[0] == 'recipe') {
      final cocktailId = int.tryParse(pathSegments[1]);
      if (cocktailId != null) {
        debugPrint('Parsed cocktail ID: $cocktailId');
        emit(DeepLinkNavigationOpenRecipe(cocktailId));
      } else {
        debugPrint('Failed to parse cocktail ID');
      }
    } else {
      debugPrint('Invalid URI path segments: $pathSegments');
    }
  }
}
