import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/models/account.dart';
import 'package:flutter_banco_douro/services/account_service.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';
import 'package:flutter_banco_douro/ui/widgets/account_widget.dart';
import 'package:flutter_banco_douro/ui/widgets/add_account_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Account>> _loadAccounts = AccountService().getAll();

  Future<void> _refresh() async {
    setState(() {
      _loadAccounts = AccountService().getAll();
    });
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return const AddAccountModal();
            },
          );
        },
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder(
            future: _loadAccounts,
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
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Nenhuma conta encontrada'),
                      );
                    } else {
                      List<Account> listAccounts = snapshot.data!;
                      return ListView.builder(
                        itemCount: listAccounts.length,
                        itemBuilder: (context, index) {
                          return AccountWidget(account: listAccounts[index]);
                        },
                      );
                    }
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
