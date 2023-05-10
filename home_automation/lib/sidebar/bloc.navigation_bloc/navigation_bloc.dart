import 'package:bloc/bloc.dart';
import 'package:home_automation/widgets/index.dart';

import '../../screens/index.dart';


enum NavigationEvents {
  HomePageClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc() : super(BottomNavigation());


  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield BottomNavigation();
        break;
    }
  }
}
