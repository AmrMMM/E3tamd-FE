// ignore_for_file: no_logic_in_create_state

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/screens/end_user_phase/requesting_item_screen/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../viewmodels/end_user_viewmodels/nav_host_view_model.dart';
import '../about/about_screen.dart';
import '../cart/cart_screen.dart';
import '../help/help_screen.dart';
import '../home/home_screen.dart';
import '../home/product_list_screen.dart';
import '../myorders/my_orders_screen.dart';
import '../myorders/order_details_screen.dart';
import '../offers/offers_screen.dart';
import '../profile/profile_screen.dart';
import '../requesting_item_screen/checkout_screen.dart';
import '../requesting_item_screen/item_details_screen/item_details_screen.dart';
import '../settings/account_information_screen.dart';
import '../settings/addresses_screen.dart';
import '../settings/chage_email_screen.dart';
import '../settings/change_password_screen.dart';
import '../settings/change_phone_number_screen.dart';
import '../settings/settings_screen.dart';

class NavHostScreen extends ScreenWidget {
  NavHostScreen(BuildContext context) : super(context);

  @override
  NavHostScreenState createState() => NavHostScreenState(context);
}

class GeneralRouteObserver extends RouteObserver {
  final listeners = List<void Function(Route<dynamic>?)>.empty(growable: true);

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    __informListeners(previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    __informListeners(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    __informListeners(newRoute);
  }

  __informListeners(Route<dynamic>? newRoute) {
    for (final listener in listeners) {
      listener(newRoute);
    }
  }

  void listen(void Function(Route<dynamic>? newRoute) onRouteChanged) {
    listeners.add(onRouteChanged);
  }
}

class NavHostScreenState
    extends BaseStateObject<NavHostScreen, NavHostViewModel> {
  NavHostScreenState(BuildContext context)
      : super(() => NavHostViewModel(context));
  final strings = Injector.appInstance.get<IStrings>();
  final thisNavigator = GlobalKey<NavigatorState>();
  final routeObserver = GeneralRouteObserver();
  String currentRoute = "/";

  @override
  void initState() {
    super.initState();
    routeObserver.listen((newRoute) {
      if (newRoute?.settings.name != currentRoute) {
        setState(() {
          currentRoute = newRoute?.settings.name ?? "";
        });
      }
    });
  }

  int getCurrentIndex() {
    switch (currentRoute) {
      case "/settings":
        return 0;
      case "/cart":
        return 1;
      case "/home":
      case "/":
        return 2;
      case "/profile":
        return 3;
      default:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget Function(BuildContext)> routes = {
      '/': (context) => HomeScreen(context),
      '/home': (context) => HomeScreen(context),
      '/offers': (context) => OffersScreen(context),
      '/help': (context) => HelpScreen(context),
      '/about': (context) => AboutScreen(context),
      '/settings': (context) => SettingsScreen(context),
      '/cart': (context) => CartScreen(context),
      '/profile': (context) => ProfileScreen(context),
      '/myOrders': (context) => MyOrderScreen(context),
      '/accountInformation': (context) => AccountInformationScreen(context),
      '/addresses': (context) => AddressesScreen(context),
      '/changePassword': (context) => ChangePasswordScreen(context),
      '/changePhoneNumber': (context) => ChangePhoneNumberScreen(context),
      '/changeEmail': (context) => ChangeEmailScreen(context),
      '/newDoors': (context) => ProductListScreen(context),
      '/itemDetails': (context) => ItemDetailsScreen(context),
      '/checkout': (context) => CheckoutScreen(context),
      '/orderDetails': (context) => OrderDetailsScreen(context),
      '/payment': (context) => PaymentScreen(context)
    };

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 7,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: Theme.of(context).primaryColor,
        selectedItemColor: getCurrentIndex() == -1
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.secondary,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        currentIndex: getCurrentIndex() == -1 ? 0 : getCurrentIndex(),
        onTap: (index) {
          if (index == getCurrentIndex()) return;
          switch (index) {
            case 0:
              thisNavigator.currentState!.pushNamed("/settings");
              break;
            case 1:
              thisNavigator.currentState!.pushNamed("/cart");
              break;
            case 2:
              thisNavigator.currentState!
                  .pushNamedAndRemoveUntil("/home", (_) => false);
              break;
            case 3:
              thisNavigator.currentState!.pushNamed("/profile");
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              label: strings.getStrings(AllStrings.settingsTitle)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              label: strings.getStrings(AllStrings.cartTitle)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: strings.getStrings(AllStrings.homeTitle)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person_outlined),
              label: strings.getStrings(AllStrings.profileTitle)),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          if (thisNavigator.currentState?.canPop() ?? false) {
            thisNavigator.currentState!.pop();
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Navigator(
          key: thisNavigator,
          observers: [routeObserver],
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              fullscreenDialog: false,
              settings: settings,
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
        ),
      ),
    );
  }
}
