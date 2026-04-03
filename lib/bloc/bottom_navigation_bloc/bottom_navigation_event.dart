part of 'bottom_navigation_bloc.dart';

@immutable
abstract class BottomNavigationEvent {}

class NavigateToHome extends BottomNavigationEvent {}

class NavigateToCatalog extends BottomNavigationEvent {}

class NavigateToStore extends BottomNavigationEvent {}

class NavigateToAccount extends BottomNavigationEvent {}
