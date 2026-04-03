part of 'deep_link_bloc.dart';

abstract class DeepLinkNavigationEvent {}

class AppLinkEvent extends DeepLinkNavigationEvent {
  final Uri uri;

  AppLinkEvent(this.uri);
}
