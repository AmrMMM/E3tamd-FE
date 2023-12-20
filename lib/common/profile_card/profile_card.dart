import 'package:flutter/material.dart';

import '../../models/user_auth_model.dart';

class ProfileCardWidget extends StatelessWidget {
  final UserAuthModel? auth;

  const ProfileCardWidget({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return auth != null
        ? Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: auth != null &&
                              auth!.imageUrl != null &&
                              auth!.imageUrl!.isNotEmpty
                          ? Image.network(
                              auth!.imageUrl!,
                              width: 42,
                              height: 42,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: 42,
                                height: 42,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            )),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${auth?.name}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      Text(
                        "${auth?.phone}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                        textDirection: TextDirection.ltr,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${auth?.email}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const Icon(
                    Icons.mail,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                height: 0.8,
                color: Colors.grey,
              ),
            ],
          )
        : const SizedBox();
  }
}
