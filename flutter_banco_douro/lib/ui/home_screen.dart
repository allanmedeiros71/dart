import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/services/account_service.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        title: const Text('Sistema de Gestão de Contas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "login");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: AccountService().getAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                {
                  return Text("A operação acabou");
                }
            }
          },
        ),
      ),
    );
  }
}
