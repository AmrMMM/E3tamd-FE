// ignore_for_file: file_names
import 'package:e3tmed/logic/implementations/Auth.dart';
import 'package:e3tmed/logic/implementations/Cart.dart';
import 'package:e3tmed/logic/implementations/Configuration.dart';
import 'package:e3tmed/logic/implementations/NotificationsManager.dart';
import 'package:e3tmed/logic/implementations/PriceLogic.dart';
import 'package:e3tmed/logic/implementations/agent_operations.dart';
import 'package:e3tmed/logic/implementations/core_logic.dart';
import 'package:e3tmed/logic/implementations/istrings/ar_strings.dart';
import 'package:e3tmed/logic/implementations/istrings/en_strings.dart';
import 'package:e3tmed/logic/implementations/payment_logic.dart';
import 'package:e3tmed/logic/implementations/social.dart';
import 'package:e3tmed/logic/implementations/support.dart';
import 'package:e3tmed/logic/interfaces/IAgentOperations.dart';
import 'package:e3tmed/logic/interfaces/ICart.dart';
import 'package:e3tmed/logic/interfaces/IConfiguration.dart';
import 'package:e3tmed/logic/interfaces/IHTTP.dart';
import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/logic/interfaces/IPriceLogic.dart';
import 'package:e3tmed/logic/interfaces/ISocial.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/logic/interfaces/payment_logic.dart';
import 'package:e3tmed/logic/interfaces/support.dart';
import 'package:e3tmed/models/AuthModels.dart';
import 'package:e3tmed/models/IModelFactory.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/models/category.dart';
import 'package:e3tmed/models/motor.dart';
import 'package:e3tmed/models/notification.dart';
import 'package:e3tmed/models/offer.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/payment.dart';
import 'package:e3tmed/models/price.dart';
import 'package:e3tmed/models/product.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:injector/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logic/implementations/IOHTTP.dart';
import 'logic/interfaces/IAuth.dart';

const useStubs = false;
const supportWhatsAppNumber = "+966542606342";
String useLanguage = 'english';
// ignore: constant_identifier_names
const VAT = 115.0;

void __setModelFactories() {
  final injector = Injector.appInstance;
  injector.registerSingleton<IModelFactory<Category>>(() => CategoryFactory());
  injector.registerSingleton<IModelFactory<Product>>(() => ProductFactory());
  injector.registerSingleton<IModelFactory<Motor>>(() => MotorFactory());
  injector.registerSingleton<IModelFactory<UserAuthModel>>(
      () => UserAuthModelFactory());
  injector.registerSingleton<IModelFactory<UserAddress>>(
      () => UserAddressFactory());
  injector.registerSingleton<IModelFactory<LoginResult>>(
      () => LoginResultFactory());
  injector.registerSingleton<IModelFactory<Offer>>(() => OfferFactory());
  injector
      .registerSingleton<IModelFactory<OrderItem>>(() => OrderItemFactory());
  injector.registerSingleton<IModelFactory<Order>>(() => OrderFactory());
  injector.registerSingleton<IModelFactory<AgentRequest>>(
      () => AgentRequestFactory());
  // injector.registerSingleton<IModelFactory<RequestItem>>(
  //     () => RequestItemFactory());
  injector
      .registerSingleton<IModelFactory<ExtraModel>>(() => ExtraModelFactory());
  injector.registerSingleton<IModelFactory<UserInfo>>(() => UserInfoFactory());
  injector.registerSingleton<IModelFactory<OrderItemExtraElement>>(
      () => OrderItemExtraElementFactory());
  injector.registerSingleton<IModelFactory<OrderItemExtraProduct>>(
      () => OrderItemExtraProductFactory());
  injector.registerSingleton<IModelFactory<OrderItemImage>>(
      () => OrderItemImageFactory());
  injector.registerSingleton<IModelFactory<APINotification>>(
      () => APINotificationFactory());
  injector.registerSingleton<IModelFactory<PriceDTO>>(() => PriceDTOFactory());
  injector.registerSingleton<IModelFactory<PriceItemDTO>>(
      () => PriceItemDTOFactory());
  injector.registerSingleton<IModelFactory<PaymentRequest>>(
      () => PaymentRequestFactory());
  injector.registerSingleton<IModelFactory<PaymentResult>>(
      () => PaymentResultFactory());
}

void __setStubs() {
  throw Exception("No more stubs ya 7oss7oss");
}

Future __setRealDependencies() async {
  final injector = Injector.appInstance;
  injector.registerSingleton<IHTTP>(() => IOHTTP());
  injector.registerSingleton<IAuth>(() => Auth());
  injector.registerSingleton<ISupport>(() => Support());
  injector.registerSingleton<ICoreLogic>(() => CoreLogic());
  injector.registerSingleton<ISocial>(() => SocialImplementation());
  final prefs = await SharedPreferences.getInstance();
  final language = prefs.getString('language');
  if (language == null) {
    await prefs.setString('language', Languages.arabic.name);
  }
  useLanguage = prefs.getString('language')!;
  if (useLanguage == Languages.english.name) {
    injector.registerSingleton<IStrings>(() => EnStrings());
  } else if (useLanguage == Languages.arabic.name) {
    injector.registerSingleton<IStrings>(() => ArStrings());
  }
  injector
      .registerSingleton<IAgentOperations>(() => AgentRequestImplementation());
  injector.registerSingleton<ICart>(() => Cart());
  injector
      .registerSingleton<INotificationsManager>(() => NotificationsManager());
  injector.registerSingleton<IPriceLogic>(() => PriceLogic());
  injector.registerSingleton<IConfiguration>(() => Configuration());
  injector.registerSingleton<IPaymentLogic>(() => PaymentLogic());
}

Future resetDependencies() async {
  final injector = Injector.appInstance;
  injector.clearAll();
  await __setRealDependencies();
  __setModelFactories();
}

Future setDependencies() async {
  if (useStubs) {
    __setStubs();
  } else {
    await __setRealDependencies();
  }
  __setModelFactories();
}
