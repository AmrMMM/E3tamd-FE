import 'package:e3tmed/logic/interfaces/IAgentOperations.dart';
import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/models/order.dart';

class ArStrings implements IStrings {
  @override
  String getStrings(AllStrings string) {
    switch (string) {
      case AllStrings.phoneNumberTitle:
        return "رقم الهاتف";
      case AllStrings.passwordTitle:
        return "كلمة السر";
      case AllStrings.enterTitle:
        return "أدخل";
      case AllStrings.forgotPasswordTitle:
        return "نسيت كلمة السر";
      case AllStrings.loginTitle:
        return "تسجيل دخول";
      case AllStrings.dontHaveAccountTitle:
        return "ليس لديك حساب؟";
      case AllStrings.registerNowTitle:
        return "سجل الأن";
      case AllStrings.createNewAccountTitle:
        return "إنشاء حساب جديد";
      case AllStrings.step1Title:
        return "خطوة 1";
      case AllStrings.step2Title:
        return "خطوة 2";
      case AllStrings.nextTitle:
        return "التالي";
      case AllStrings.alreadyUserTitle:
        return "مستخدم بالفعل؟";
      case AllStrings.loginNowTitle:
        return "تسجيل دخول";
      case AllStrings.firstNameTitle:
        return "الأسم الأول";
      case AllStrings.lastNameTitle:
        return "أسم العائلة";
      case AllStrings.emailTitle:
        return "البريد الإلكتروني";
      case AllStrings.countryTitle:
        return "البلد";
      case AllStrings.cityTitle:
        return "المدينة";
      case AllStrings.regionTitle:
        return "المنطقة";
      case AllStrings.addressTitle:
        return "العنوان";
      case AllStrings.registerTitle:
        return "إنشاء حساب";
      case AllStrings.aboutTitle:
        return "من نحن";
      case AllStrings.aboutMessageTile:
        return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum";
      case AllStrings.helpTitle:
        return "المساعدة";
      case AllStrings.helloTitle:
        return "مرحبا";
      case AllStrings.instructionsTitle:
        return "يمكنك إرسال رسالة لنا, وسيقوم أحد ممثلينا بالتواصل معكم خلال 24 ساعة أو تواصل معنا عن طريق whatsapp";
      case AllStrings.nameTitle:
        return "الأسم";
      case AllStrings.messageTitle:
        return "الرسالة";
      case AllStrings.sendTitle:
        return "إرسال";
      case AllStrings.homeTitle:
        return "الرئيسية";
      case AllStrings.goodMorningTitle:
        return "مرحبا";
      case AllStrings.pleaseChooseTheNeededServiceTitle:
        return "تصفح و إختار الخدمة المطلوبة";
      case AllStrings.profileTitle:
        return "الملف الشخصي";
      case AllStrings.offersTitle:
        return "العروض";
      case AllStrings.myOrdersTitle:
        return "طلباتي";
      case AllStrings.continueTitle:
        return "الإستمرار";
      case AllStrings.didYouForgetYourPasswordTitle:
        return "نسيت كلمة السر؟";
      case AllStrings.enterYourPhoneNumberToReceiveTheValidationCodeTitle:
        return "قم بإدخال رقم الهاتف الخاص بك لتستلم رمز التأكيد";
      case AllStrings.receivedCodeTitle:
        return "الرمز المرسل";
      case AllStrings.newPasswordTitle:
        return "الرقم السري الجديد";
      case AllStrings.startYourOrdersAndContactWithClientsTitle:
        return "إبدأ الطلبات الخاصة بك وتواصل مع العملاء";
      case AllStrings.requestsTitle:
        return "الطلبات";
      case AllStrings.changePasswordTitle:
        return "تغير كلمة السر";
      case AllStrings.confirmPasswordTitle:
        return "تأكيد كلمة السر";
      case AllStrings.currentPasswordTitle:
        return "كلمة السر الحالية";
      case AllStrings.notificationTitle:
        return "الإشعارات";
      case AllStrings.youDontHaveNotificationYetTitle:
        return "لا يوجد لديك إشعارات بعد";
      case AllStrings.logoutTitle:
        return "تسجيل خروج";
      case AllStrings.areYouSureYouWantToLogoutTitle:
        return "هل أنت متأكد من أنك تريد تسجيل الخروج ؟";
      case AllStrings.yesTitle:
        return "نعم";
      case AllStrings.noTitle:
        return "لا";
      case AllStrings.allTitle:
        return "الكل";
      case AllStrings.newTitle:
        return "جديد";
      case AllStrings.repairTitle:
        return "إصلاح";
      case AllStrings.pendingTitle:
        return "معلقة";
      case AllStrings.confirmedTitle:
        return "مؤكد";
      case AllStrings.completedTitle:
        return "إنتهاء";
      case AllStrings.priceDetailsTitle:
        return "تفاصيل السعر";
      case AllStrings.totalTitle:
        return "الإجمالي";
      case AllStrings.productPriceTitle:
        return "أسعار المنتجات";
      case AllStrings.agentFeesTitle:
        return "أجر العميل";
      case AllStrings.acceptTitle:
        return "قبول";
      case AllStrings.viewDetailsTitle:
        return "المزيد";
      case AllStrings.contactViaWhatsAppTitle:
        return "التواصل عن طريق واتساب";
      case AllStrings.editDetailsTitle:
        return "تعديل التفاصيل";
      case AllStrings.dimensionsTitle:
        return "الأبعاد";
      case AllStrings.thicknessTitle:
        return "السمك";
      case AllStrings.colorTitle:
        return "اللون";
      case AllStrings.motorTitle:
        return "المحرك";
      case AllStrings.addSparePartsTitle:
        return "أضف قطع غيار";
      case AllStrings.addExtrasTitle:
        return "إضافات أخري";
      case AllStrings.addNoteTitle:
        return "مذكرة";
      case AllStrings.saveAndContinueTitle:
        return "استكمال العملية";
      case AllStrings.orderConfirmedTitle:
        return "تم تأكيد الطلب";
      case AllStrings.orderInstalledTitle:
        return "تم التركيب";
      case AllStrings.completeTitle:
        return "الإنتهاء";
      case AllStrings.orderDetailsTitle:
        return "تفاصيل الطلب";
      case AllStrings.vatTitle:
        return "القيمة المضافة";
      case AllStrings.cartTitle:
        return "العربة";
      case AllStrings.settingsTitle:
        return "الإعدادات";
      case AllStrings.changeNameTitle:
        return "تغيير الأسم";
      case AllStrings.addressesTitle:
        return "العنوان";
      case AllStrings.changePhoneNumberTitle:
        return "تغيير رقم الهاتف";
      case AllStrings.changeEmailTitle:
        return "تغيير البريد الإلكتروني";
      case AllStrings.yourListIsEmptyTitle:
        return "لا توجد لديك بيانات في القائمة";
      case AllStrings.deliverToTitle:
        return "التوصيل إلي";
      case AllStrings.subtotalTitle:
        return "الإجمالي";
      case AllStrings.askForAgentTitle:
        return "طلب عميل";
      case AllStrings.addDimensionsTitle:
        return "أضف أبعاد";
      case AllStrings.continueCheckoutTitle:
        return "إلي عملية الشراء";
      case AllStrings.addToCartTitle:
        return "أضف الي العربة";
      case AllStrings.priceSummaryTitle:
        return "تفاصيل السعر";
      case AllStrings.productCostTitle:
        return "تكلفة المنتج";
      case AllStrings.paymentMethodTitle:
        return "طرق الدفع";
      case AllStrings.changePaymentTitle:
        return "تغيير طريقة الدفع";
      case AllStrings.termAndConditionsTitle:
        return "الأحكام والشروط";
      case AllStrings.iHaveReadAndAcceptedTermAdnConditionsTitle:
        return "لقد قرأت وقبلت الشروط والأحكام";
      case AllStrings.confirmOrderTitle:
        return "أكد الطلب";
      case AllStrings.proceedToBuyTitle:
        return "الشروع في الشراء";
      case AllStrings.itemsTitle:
        return "منتج";
      case AllStrings.deleteTitle:
        return "إزالة";
      case AllStrings.cancelTitle:
        return "إلغاء";
      case AllStrings.newPhoneNumberTitle:
        return "رقم الهاتف الجديد";
      case AllStrings.changeAddressTitle:
        return "تغيير العنوان";
      case AllStrings.addCardTitle:
        return "إضافة بطاقة";
      case AllStrings.cardNumberTitle:
        return "رقم البطاقة";
      case AllStrings.expiryDateTitle:
        return "تاريخ الإنتهاء";
      case AllStrings.cvvTitle:
        return "رقم CVV";
      case AllStrings.cardHolderFirstNameTitle:
        return "الإسم الأول لحامل البطاقة";
      case AllStrings.cardHolderLastNameTitle:
        return "الإسم العائلى لحامل البطاقة";
      case AllStrings.changeTitle:
        return "تغيير";
      case AllStrings.enterThePhoneNumberTitle:
        return "أدخل رقم الهاتف";
      case AllStrings.isRequiredTitle:
        return "إجباري";
      case AllStrings.enterCorrectTitle:
        return "أدخل كتابة صحيحة ل";
      case AllStrings.maintenanceTitle:
        return "إصلاح";
      case AllStrings.agentVisitTitle:
        return "زيارة عميل";
      case AllStrings.sparePartsTitle:
        return "قطع غيار";
      case AllStrings.extrasAndServicesTitle:
        return "خدمات وقطع غيار إضافية";
      case AllStrings.orderSummaryTitle:
        return "ملخص الطلب";
      case AllStrings.changeLanguageTitle:
        return "تغيير اللغة";
      case AllStrings
            .priceMayChangeAccordingToAgentsVisitAndFeesWillBeDeductedFromTotalPaymentWhenTheRequestIsCompletedTitle:
        return "يمكن للسعر أن يتغير بناء علي زيارة أحد موظفينا اليك, و سيتم استقطاع هذا المبلغ من السعر الاجمالي في حاله تم تأكيد طلبكم";
      case AllStrings.ifYouDontKnowTheDoorDimensionsYouCanAskForAnAgentTitle:
        return "في حالة عدم معرفة الأبعاد الصحيحة, يمكنك طلب أحد موظفينا";
      case AllStrings.verifyTitle:
        return "تأكيد";
      case AllStrings.submitTitle:
        return "تسجيل";
      case AllStrings.confirmTitle:
        return "تأكيد";
      case AllStrings
            .youWillReceiveACodeToVerifyYourPhoneNumberPleaseWriteItDownWhenYouReceiveItTitle:
        return "سوف تصلك رسالة بها رمز التأكيد الخاص بك, برجاء إدخال رمز التأكيد";
      case AllStrings
            .youWillReceiveACodeToResetYourPasswordPleaseWriteItDownWhenYouReceiveItTitle:
        return "سوف تصلك رسالة بها رمز التأكيد الخاص بك لتغيير رقم السري الخاص بك, برجاء إدخال رمز التأكيد";
      case AllStrings.codeTitle:
        return "رمز";
      case AllStrings.confirmationCodeTitle:
        return "رمز التأكيد";
      case AllStrings.noteTitle:
        return "ملاحظة";
      case AllStrings.newEmailTitle:
        return "البريد الإلكتروني الجديد";
      case AllStrings.quantityTitle:
        return "العدد";
      case AllStrings.addPhotoTitle:
        return "إضافة صورة";
      case AllStrings.specificationTitle:
        return "المواصفات";
      case AllStrings.photosTitle:
        return "الصور";
      case AllStrings.widthTitle:
        return "العرض";
      case AllStrings.heightTitle:
        return "الطول";
      case AllStrings.cannotStartWithZero:
        return "لا يبدأ ب 0";
      case AllStrings.emailAndPhoneAreAlreadyExistTitle:
        return "البريد الإلكتروني والهاتف مسجلين بالفعل";
      case AllStrings.emailIsAlreadyExistTitle:
        return "البريد الإلكتروني مسجل بالفعل";
      case AllStrings.phoneIsAlreadyExistTitle:
        return "رقم الهاتف مسجل بالفعل";
      case AllStrings.emailOrPassowrdAreIncorrectTitle:
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة";
      case AllStrings.phoneOrPasswordAreIncorrectTitle:
        return "رقم الهاتف أو كلمة المرور غير صحيحة";
      case AllStrings.youWillBeReceivingCodeInTitle:
        return "سوف تتلقى الرمز في ";
      case AllStrings.secondsTitle:
        return "ثانية";
      case AllStrings.cancelOrderTitle:
        return "إلغاء الطلب";
      case AllStrings.areYouSureYouWantToCancelOrderTitle:
        return "هل أنت واثق بأنك تريد أن تلغي طلب الشراء؟";
      case AllStrings.resendCodeAgainTitle:
        return "إرسال الرمز مرة أخري";
      case AllStrings.orderCanceledSuccessfullyTitle:
        return "تم إلغاء الطلب بنجاح";
      case AllStrings.failedToCancelOrderTitle:
        return "فشل في إلغاء الطلب";
      case AllStrings.passwordAndConfirmPasswordDoesntMatchTitle:
        return "كلمة المرور وتأكيد كلمة المرور غير متطابقان";
      case AllStrings.registerSuccessfulPleaseLoginTitle:
        return "نم التسجيل بنجاح ، يرجى تسجيل الدخول";
      case AllStrings.changedSuccessfullyTitle:
        return "تم التغيير بنجاح";
      case AllStrings.orderRemovedFromCartTitle:
        return "تمت إزالة الطلب من سلة التسوق";
      case AllStrings.failedToRemoveOrderFromCartTitle:
        return "فشل في إزالة الطلب من سلة التسوق";
      case AllStrings.thanksForContactingUsTitle:
        return "شكرا لإتصالك بنا!";
      case AllStrings.failedToSendMessageTitle:
        return "فشل في إرسال الرسالة";
      case AllStrings.orderAddedToCartTitle:
        return "تمت إضافة الطلب إلى سلة التسوق";
      case AllStrings.failedToAddOrderToCartTitle:
        return "فشل إضافة الطلب إلى عربة التسوق";
      case AllStrings.thanksForOrderingTitle:
        return "شكرا للطلب";
      case AllStrings.nameChangedSuccessfullyTitle:
        return "تم تغيير الأسم بنجاح";
      case AllStrings.errorWhileChangingNameTitle:
        return "خطأ أثناء تغيير الأسم";
      case AllStrings.pleaseSelectAnAddressToContinueTitle:
        return "الرجاء تحديد عنوان للمتابعة";
      case AllStrings.emailChangedSuccessfullyTitle:
        return "تم تغيير البريد الإلكتروني بنجاح";
      case AllStrings.errorWhileChangingEmailTitle:
        return "خطأ أثناء تغيير البريد الإلكتروني";
      case AllStrings.passwordChangedSuccessfullyTitle:
        return "تم تغيير الرقم السري بنجاح";
      case AllStrings.errorWhileChangingPasswordTitle:
        return "خطأ أثناء تغيير كلمة المرور";
      case AllStrings.phoneNumberChangedSuccessfullyTitle:
        return "تم تغيير رقم الهاتف بنجاح";
      case AllStrings.errorWhileChangingPhoneNumberTitle:
        return "خطأ أثناء تغيير رقم الهاتف";
      case AllStrings.orderCanceledTitle:
        return "إلغاء الطلب";
      case AllStrings.newVersionTitle:
        return "تحديث جديد";
      case AllStrings.aNewVersionHasBeenReleasedPleaseUpdateTitle:
        return "يوجد تحديث جديد, برجاء التحديث حتي تتمكن من استخدام التطبيق";
      case AllStrings.updateTitle:
        return "تحديث";
      case AllStrings.itemDetailsTitle:
        return "تفاصيل";
      case AllStrings.paymentMethodCashTitle:
        return "الدفع نقداً";
      case AllStrings.paymentMethodCardTitle:
        return "الدفع بالبطاقة البنكية";
      case AllStrings.editTitle:
        return "تعديل";
      case AllStrings.deleteAddressTitle:
        return "مسح العنوان";
      case AllStrings.areYouSureYouWantToDeleteThisAddressTitle:
        return "هل انت متأكد من انك تريد مسح هذا العنوان؟";
      case AllStrings.paidAmount:
        return "المبلغ المدفوع";
      case AllStrings.totalDue:
        return "المبلغ المتبقى";
    }
  }

  @override
  String getOrderFilterString(AgentOrderFilters filter) {
    switch (filter) {
      case AgentOrderFilters.pending:
        return "إنتظار";
      case AgentOrderFilters.confirmed:
        return "تأكيد";
      case AgentOrderFilters.complete:
        return "إنتهاء";
    }
  }

  @override
  String getOrderStatusString(OrderStatus status) {
    switch (status) {
      case OrderStatus.unassigned:
        return "غير مؤكد";
      case OrderStatus.pending:
        return "في إنتظار العميل";
      case OrderStatus.confirmed:
        return "جاري تحضير طلبك";
      case OrderStatus.toBeDelivered:
        return "جاهز للتوصيل";
      case OrderStatus.finished:
        return "تم التوصيل";
    }
  }

  @override
  String getUserOrderStatusInformationString(OrderStatus status) {
    switch (status) {
      case OrderStatus.unassigned:
        return "تم إنشاء طلبك بنجاح";
      case OrderStatus.pending:
        return "طلبك في وضع الإنتظار الأن";
      case OrderStatus.confirmed:
        return "تم تأكيد طلبك بنجاح";
      case OrderStatus.finished:
        return "تم التكريب بنجاح";
      case OrderStatus.toBeDelivered:
        return "الطلب جاهز للتوصيل";
    }
  }

  @override
  String getOrderAgentStatusInformationString(OrderStatus status) {
    switch (status) {
      case OrderStatus.unassigned:
        return "سيتم التواصل معك من قبل أحد عملائنا في خلال 24 ساعة";
      case OrderStatus.pending:
        return "سيتم التواصل معك من قبل أحد عملائنا في خلال 24 ساعة";
      case OrderStatus.confirmed:
        return "الطلب تحت التصنيع";
      case OrderStatus.finished:
        return "تم اكمال طلبك بنجاح";
      case OrderStatus.toBeDelivered:
        return "طلبكم قيد التوصيل";
    }
  }

  @override
  String getNotificationMessage(NotificationType type, Order order,
      [OrderStatus? oldOrderStatus]) {
    switch (type) {
      case NotificationType.agentOrderCanceled:
        return "طلب #${order.id} الذاهب الي ${order.address.address} وتكلفته ${order.totalPrice} SAR قد تم الغاءه ";
      case NotificationType.userOrderStatusChanged:
        return "طلب #${order.id} تم تغيير حالته من \"${getOrderStatusString(oldOrderStatus!)}\" إلى \"${getOrderStatusString(order.status!)}\"";
    }
  }

  @override
  String getNotificationTypeString(NotificationType type) {
    switch (type) {
      case NotificationType.agentOrderCanceled:
        return "الغاء طلب";
      case NotificationType.userOrderStatusChanged:
        return "تغيير حالة الطلب";
    }
  }
}
