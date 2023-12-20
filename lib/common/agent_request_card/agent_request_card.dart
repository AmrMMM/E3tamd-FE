import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../logic/interfaces/IStrings.dart';
import '../../models/agent_requests_model.dart';
import '../buttons/primarybuttonshape.dart';

class RequestOuterDetailsWidget extends StatelessWidget {
  final IconData icon;
  final String title;

  const RequestOuterDetailsWidget(
      {Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        )
      ],
    );
  }
}

class AgentRequestCardWidget extends StatelessWidget {
  final AgentRequest agentRequest;
  final bool? isOrder;
  final void Function(AgentRequest request)? viewDetails;
  final void Function(AgentRequest request)? onAccepting;
  final void Function(AgentRequest request)? onRejecting;
  final void Function(AgentRequest request)? onContactViaWhatsapp;
  final void Function()? onTap;

  const AgentRequestCardWidget(
      {Key? key,
      required this.agentRequest,
      this.viewDetails,
      this.onAccepting,
      this.onRejecting,
      this.onContactViaWhatsapp,
      this.isOrder,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = Injector.appInstance.get<IStrings>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child:
                          Text(agentRequest.items[0].product.getCategoryName()),
                    ),
                    Text(
                      "${agentRequest.addedDate.day}/${agentRequest.addedDate.month}/${agentRequest.addedDate.year}",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: RequestOuterDetailsWidget(
                      icon: Icons.person_outlined,
                      title:
                          "${agentRequest.user.firstName} ${agentRequest.user.lastName}"),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: RequestOuterDetailsWidget(
                      icon: Icons.location_on_outlined,
                      title: agentRequest.address.address),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: RequestOuterDetailsWidget(
                      icon: Icons.error_outline,
                      title:
                          "${agentRequest.items.map((e) => e.product.getCategoryName()).toList()}"),
                ),
                isOrder ?? true
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: InkWell(
                          onTap: () => viewDetails!(agentRequest),
                          child: Text(
                            strings.getStrings(AllStrings.viewDetailsTitle),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          strings.getOrderStatusString(agentRequest.status),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                isOrder ?? true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: PrimaryButtonShape(
                                width: 75,
                                height: 40,
                                text:
                                    strings.getStrings(AllStrings.acceptTitle),
                                color: Theme.of(context).colorScheme.secondary,
                                stream: null,
                                onTap: () => onAccepting!(agentRequest)),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: PrimaryButtonShape(
                            imageAsset: "whatsapplogo.png",
                            width: double.infinity,
                            height: 40,
                            text: strings
                                .getStrings(AllStrings.contactViaWhatsAppTitle),
                            color: Theme.of(context).colorScheme.secondary,
                            stream: null,
                            clickable: false,
                            onTap: () => onContactViaWhatsapp!(agentRequest)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
