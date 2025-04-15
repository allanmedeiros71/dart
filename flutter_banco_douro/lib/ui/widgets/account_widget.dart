import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/models/account.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';

class AccountWidget extends StatelessWidget {
  final Account account;
  const AccountWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${account.lastName.toUpperCase()}, ${account.name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                "ID: ${account.id.substring(0, min(8, account.id.length))}...",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "Saldo: R\$ ${account.balance.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "Tipo: ${account.accountType?.name} (Taxa: ${account.accountType?.tax}%)",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
    );
  }
}
