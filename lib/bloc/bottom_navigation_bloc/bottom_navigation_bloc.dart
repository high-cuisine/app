import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_navigation_event.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(HomePageState()) {
    on<NavigateToHome>((event, emit) => emit(HomePageState()));
    on<NavigateToCatalog>((event, emit) => emit(CatalogPageState()));
    on<NavigateToStore>((event, emit) => emit(StorePageState()));
    on<NavigateToAccount>((event, emit) => emit(AccountPageState()));
  }
}
