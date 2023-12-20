import 'package:e3tmed/logic/interfaces/IAgentOperations.dart';
import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/models/order.dart';

import '../../interfaces/IAuth.dart';

class EnStrings implements IStrings {
  @override
  String getStrings(AllStrings string) {
    switch (string) {
      case AllStrings.phoneNumberTitle:
        return "Phone number";
      case AllStrings.passwordTitle:
        return "Password";
      case AllStrings.enterTitle:
        return "Enter";
      case AllStrings.forgotPasswordTitle:
        return "Forgot password";
      case AllStrings.loginTitle:
        return "Login";
      case AllStrings.dontHaveAccountTitle:
        return "Dont have account?";
      case AllStrings.registerNowTitle:
        return "Register now";
      case AllStrings.createNewAccountTitle:
        return "Create new account";
      case AllStrings.step1Title:
        return "Step 1";
      case AllStrings.step2Title:
        return "Step 2";
      case AllStrings.nextTitle:
        return "Next";
      case AllStrings.alreadyUserTitle:
        return "Already user?";
      case AllStrings.loginNowTitle:
        return "Login now";
      case AllStrings.firstNameTitle:
        return "First name";
      case AllStrings.lastNameTitle:
        return "Last name";
      case AllStrings.emailTitle:
        return "Email";
      case AllStrings.countryTitle:
        return "Country";
      case AllStrings.cityTitle:
        return "City";
      case AllStrings.regionTitle:
        return "Region";
      case AllStrings.addressTitle:
        return "Address";
      case AllStrings.registerTitle:
        return "Register";
      case AllStrings.aboutTitle:
        return "About";
      case AllStrings.aboutMessageTile:
        return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum";
      case AllStrings.helpTitle:
        return "Help";
      case AllStrings.helloTitle:
        return "Hello";
      case AllStrings.instructionsTitle:
        return "You can send us a message , and our agent will contact you within 24 hours or contact us via whatsapp";
      case AllStrings.nameTitle:
        return "Name";
      case AllStrings.messageTitle:
        return "Message";
      case AllStrings.sendTitle:
        return "Send";
      case AllStrings.homeTitle:
        return "Home";
      case AllStrings.goodMorningTitle:
        return "Good Morning";
      case AllStrings.pleaseChooseTheNeededServiceTitle:
        return "Explore and choose from our services";
      case AllStrings.profileTitle:
        return "Profile";
      case AllStrings.offersTitle:
        return "Offers";
      case AllStrings.myOrdersTitle:
        return "My Orders";
      case AllStrings.continueTitle:
        return "Continue";
      case AllStrings.didYouForgetYourPasswordTitle:
        return "Forgot password?";
      case AllStrings.enterYourPhoneNumberToReceiveTheValidationCodeTitle:
        return "Enter your phone number to receive the validation code";
      case AllStrings.receivedCodeTitle:
        return "Received code";
      case AllStrings.newPasswordTitle:
        return "New password";
      case AllStrings.startYourOrdersAndContactWithClientsTitle:
        return "Start your orders and contact with clients";
      case AllStrings.requestsTitle:
        return "Requests";
      case AllStrings.changePasswordTitle:
        return "Change password";
      case AllStrings.confirmPasswordTitle:
        return "Confirm password";
      case AllStrings.currentPasswordTitle:
        return "Current password";
      case AllStrings.notificationTitle:
        return "Notifications";
      case AllStrings.youDontHaveNotificationYetTitle:
        return "You don’t have notifications yet";
      case AllStrings.logoutTitle:
        return "Logout";
      case AllStrings.areYouSureYouWantToLogoutTitle:
        return "Are you sure you want to logout ?";
      case AllStrings.yesTitle:
        return "Yes";
      case AllStrings.noTitle:
        return "No";
      case AllStrings.allTitle:
        return "All";
      case AllStrings.newTitle:
        return "New";
      case AllStrings.repairTitle:
        return "Repair";
      case AllStrings.pendingTitle:
        return "Pending";
      case AllStrings.confirmedTitle:
        return "Confirmed";
      case AllStrings.completedTitle:
        return "Completed";
      case AllStrings.priceDetailsTitle:
        return "Price details";
      case AllStrings.totalTitle:
        return "Total";
      case AllStrings.productPriceTitle:
        return "Price";
      case AllStrings.agentFeesTitle:
        return "Agent fees";
      case AllStrings.acceptTitle:
        return "Accept";
      case AllStrings.viewDetailsTitle:
        return "View details";
      case AllStrings.contactViaWhatsAppTitle:
        return "Contact via whatsapp";
      case AllStrings.editDetailsTitle:
        return "Edit details";
      case AllStrings.dimensionsTitle:
        return "Dimensions";
      case AllStrings.thicknessTitle:
        return "Thickness";
      case AllStrings.colorTitle:
        return "Color";
      case AllStrings.motorTitle:
        return "Motor";
      case AllStrings.addSparePartsTitle:
        return "Add spare parts";
      case AllStrings.addExtrasTitle:
        return "Add extras";
      case AllStrings.addNoteTitle:
        return "Add note";
      case AllStrings.saveAndContinueTitle:
        return "Save & continue";
      case AllStrings.orderConfirmedTitle:
        return "Order confirmed";
      case AllStrings.orderInstalledTitle:
        return "Order installed";
      case AllStrings.completeTitle:
        return "Complete";
      case AllStrings.orderDetailsTitle:
        return "Order details";
      case AllStrings.vatTitle:
        return "VAT";
      case AllStrings.cartTitle:
        return "Cart";
      case AllStrings.settingsTitle:
        return "Settings";
      case AllStrings.changeNameTitle:
        return "Change name";
      case AllStrings.addressesTitle:
        return "Addresses";
      case AllStrings.changePhoneNumberTitle:
        return "Change phone number";
      case AllStrings.changeEmailTitle:
        return "Change email";
      case AllStrings.yourListIsEmptyTitle:
        return "Your list is empty";
      case AllStrings.deliverToTitle:
        return "Deliver to";
      case AllStrings.subtotalTitle:
        return "Subtotal";
      case AllStrings.askForAgentTitle:
        return "Ask for agent";
      case AllStrings.addDimensionsTitle:
        return "Add Dimensions";
      case AllStrings.continueCheckoutTitle:
        return "Checkout";
      case AllStrings.addToCartTitle:
        return "Add to cart";
      case AllStrings.priceSummaryTitle:
        return "Price summary";
      case AllStrings.productCostTitle:
        return "Product cost";
      case AllStrings.paymentMethodTitle:
        return "Payment method";
      case AllStrings.changePaymentTitle:
        return "Change payment method";
      case AllStrings.termAndConditionsTitle:
        return "Terms and conditions";
      case AllStrings.iHaveReadAndAcceptedTermAdnConditionsTitle:
        return "I have read and accepted terms and conditions";
      case AllStrings.confirmOrderTitle:
        return "Confirm order";
      case AllStrings.proceedToBuyTitle:
        return "Proceed to buy";
      case AllStrings.itemsTitle:
        return "items";
      case AllStrings.deleteTitle:
        return "Delete";
      case AllStrings.cancelTitle:
        return "Cancel";
      case AllStrings.newPhoneNumberTitle:
        return "New phone number";
      case AllStrings.changeAddressTitle:
        return "Change address title";
      case AllStrings.addCardTitle:
        return "Add card";
      case AllStrings.cardNumberTitle:
        return "Card number";
      case AllStrings.expiryDateTitle:
        return "Expiry date";
      case AllStrings.cvvTitle:
        return "CVV";
      case AllStrings.cardHolderFirstNameTitle:
        return "Card holder first name";
      case AllStrings.cardHolderLastNameTitle:
        return "Card holder last name";
      case AllStrings.changeTitle:
        return "change";
      case AllStrings.enterThePhoneNumberTitle:
        return "Enter the phone number";
      case AllStrings.isRequiredTitle:
        return "is required";
      case AllStrings.enterCorrectTitle:
        return "Enter correct";
      case AllStrings.maintenanceTitle:
        return "Maintenance";
      case AllStrings.agentVisitTitle:
        return "Agent visit";
      case AllStrings.sparePartsTitle:
        return "Spare parts";
      case AllStrings.extrasAndServicesTitle:
        return "Extras and services";
      case AllStrings.orderSummaryTitle:
        return "Order summary";
      case AllStrings.changeLanguageTitle:
        return "Change language";
      case AllStrings
            .priceMayChangeAccordingToAgentsVisitAndFeesWillBeDeductedFromTotalPaymentWhenTheRequestIsCompletedTitle:
        return "Price may change according to agent’s visit, and fees will be deducted from total payment when the request is completed.";
      case AllStrings.ifYouDontKnowTheDoorDimensionsYouCanAskForAnAgentTitle:
        return "If you dont know the door dimensions, you can ask for an agent";
      case AllStrings.verifyTitle:
        return "Verify";
      case AllStrings.submitTitle:
        return "Submit";
      case AllStrings.confirmTitle:
        return "Confirm";
      case AllStrings
            .youWillReceiveACodeToVerifyYourPhoneNumberPleaseWriteItDownWhenYouReceiveItTitle:
        return "You will receive a code to verify your ${currentAuthenticationMode.name}, please write it down when you receive it.";
      case AllStrings
            .youWillReceiveACodeToResetYourPasswordPleaseWriteItDownWhenYouReceiveItTitle:
        return "You will receive a code to reset your password, please write it down when you receive it.";
      case AllStrings.codeTitle:
        return "Code";
      case AllStrings.confirmationCodeTitle:
        return "Confirmation code";
      case AllStrings.noteTitle:
        return "Note";
      case AllStrings.newEmailTitle:
        return "New email";
      case AllStrings.quantityTitle:
        return "Quantity";
      case AllStrings.addPhotoTitle:
        return "Add photo";
      case AllStrings.specificationTitle:
        return "Specifications";
      case AllStrings.photosTitle:
        return "Photos";
      case AllStrings.widthTitle:
        return "Width";
      case AllStrings.heightTitle:
        return "Height";
      case AllStrings.cannotStartWithZero:
        return "cannot start with 0";
      case AllStrings.emailAndPhoneAreAlreadyExistTitle:
        return "Email and phone are already exist";
      case AllStrings.emailIsAlreadyExistTitle:
        return "Email is already exist";
      case AllStrings.phoneIsAlreadyExistTitle:
        return "Phone is already exist";
      case AllStrings.emailOrPassowrdAreIncorrectTitle:
        return "Email or password are incorrect";
      case AllStrings.phoneOrPasswordAreIncorrectTitle:
        return "Phone or password are incorrect";
      case AllStrings.youWillBeReceivingCodeInTitle:
        return "You will be receiving code in";
      case AllStrings.secondsTitle:
        return "seconds";
      case AllStrings.cancelOrderTitle:
        return "Cancel order";
      case AllStrings.areYouSureYouWantToCancelOrderTitle:
        return "Are you sure you want to cancel order?";
      case AllStrings.resendCodeAgainTitle:
        return "Resend code again";
      case AllStrings.orderCanceledSuccessfullyTitle:
        return "Order canceled successfully";
      case AllStrings.failedToCancelOrderTitle:
        return "Failed to cancel order";
      case AllStrings.passwordAndConfirmPasswordDoesntMatchTitle:
        return "Password and confirm password doesnt match";
      case AllStrings.registerSuccessfulPleaseLoginTitle:
        return "Register successfully, please login";
      case AllStrings.changedSuccessfullyTitle:
        return "Changed Successfully";
      case AllStrings.orderRemovedFromCartTitle:
        return "Order removed from cart";
      case AllStrings.failedToRemoveOrderFromCartTitle:
        return "Failed to remove order from cart";
      case AllStrings.thanksForContactingUsTitle:
        return "Thanks for contacting us!";
      case AllStrings.failedToSendMessageTitle:
        return "Failed to send message";
      case AllStrings.orderAddedToCartTitle:
        return "Order added to cart";
      case AllStrings.failedToAddOrderToCartTitle:
        return "Failed to add order to cart";
      case AllStrings.thanksForOrderingTitle:
        return "Thanks for ordering";
      case AllStrings.nameChangedSuccessfullyTitle:
        return "Name changed successfully";
      case AllStrings.errorWhileChangingNameTitle:
        return "Error while changing name";
      case AllStrings.pleaseSelectAnAddressToContinueTitle:
        return "Please select an address to continue";
      case AllStrings.emailChangedSuccessfullyTitle:
        return "Email changed successfully";
      case AllStrings.errorWhileChangingEmailTitle:
        return "Error while changing email";
      case AllStrings.passwordChangedSuccessfullyTitle:
        return "Password changed successfully";
      case AllStrings.errorWhileChangingPasswordTitle:
        return "Error while changing password";
      case AllStrings.phoneNumberChangedSuccessfullyTitle:
        return "Phone number changed successfully";
      case AllStrings.errorWhileChangingPhoneNumberTitle:
        return "Error while changing phone number";
      case AllStrings.orderCanceledTitle:
        return "Order Canceled";
      case AllStrings.newVersionTitle:
        return "New version";
      case AllStrings.aNewVersionHasBeenReleasedPleaseUpdateTitle:
        return "A new version has been release, Please update in order to keep using the app";
      case AllStrings.updateTitle:
        return "Update";
      case AllStrings.itemDetailsTitle:
        return "Details";
      case AllStrings.paymentMethodCashTitle:
        return "Pay in cash";
      case AllStrings.paymentMethodCardTitle:
        return "Pay with bank card";
      case AllStrings.editTitle:
        return "ُEdit";
      case AllStrings.deleteAddressTitle:
        return "Delete address";
      case AllStrings.areYouSureYouWantToDeleteThisAddressTitle:
        return "Are you sure you want to delete this address?";
      case AllStrings.paidAmount:
        return "Paid amount";
      case AllStrings.totalDue:
        return "Total due";
    }
  }

  @override
  String getOrderFilterString(AgentOrderFilters filter) {
    switch (filter) {
      case AgentOrderFilters.pending:
        return "Pending";
      case AgentOrderFilters.confirmed:
        return "Confirmed";
      case AgentOrderFilters.complete:
        return "Completed";
    }
  }

  @override
  String getOrderStatusString(OrderStatus status) {
    switch (status) {
      case OrderStatus.unassigned:
        return "Unassigned";
      case OrderStatus.pending:
        return "Pending";
      case OrderStatus.confirmed:
        return "Confirmed";
      case OrderStatus.toBeDelivered:
        return "Ready for delivery";
      case OrderStatus.finished:
        return "Finished";
    }
  }

  @override
  String getUserOrderStatusInformationString(OrderStatus status) {
    switch (status) {
      case OrderStatus.unassigned:
        return "Your order is created successfully";
      case OrderStatus.pending:
        return "Your order is in pending state";
      case OrderStatus.confirmed:
        return "Your order confirmed successfully";
      case OrderStatus.finished:
        return "You order installed successfully";
      case OrderStatus.toBeDelivered:
        return "Your order is ready to be delivered";
    }
  }

  @override
  String getOrderAgentStatusInformationString(OrderStatus status) {
    switch (status) {
      case OrderStatus.unassigned:
        return "Our agent will contact you within 24 hrs";
      case OrderStatus.pending:
        return "Our agent will contact you within 24 hrs";
      case OrderStatus.confirmed:
        return "Agent on his way to you";
      case OrderStatus.finished:
        return "Your order is completed successfully";
      case OrderStatus.toBeDelivered:
        return "Your order is ready to be delivered";
    }
  }

  @override
  String getNotificationMessage(NotificationType type, Order order,
      [OrderStatus? oldOrderStatus]) {
    switch (type) {
      case NotificationType.agentOrderCanceled:
        return "Order #${order.id} Delivering to ${order.address.address} with a cost of ${order.totalPrice} has been cancelled by user";
      case NotificationType.userOrderStatusChanged:
        return "Your order #${order.id} status changed from \"${getOrderStatusString(oldOrderStatus!)}\" to \"${getOrderStatusString(order.status!)}\"";
    }
  }

  @override
  String getNotificationTypeString(NotificationType type) {
    switch (type) {
      case NotificationType.agentOrderCanceled:
        return "Order canceled";
      case NotificationType.userOrderStatusChanged:
        return "Order status changed";
    }
  }
}
