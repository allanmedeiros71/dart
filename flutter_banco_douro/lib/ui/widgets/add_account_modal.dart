import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/models/account.dart';
import 'package:flutter_banco_douro/services/account_service.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';
import 'package:uuid/uuid.dart';

class AddAccountModal extends StatefulWidget {
  const AddAccountModal({super.key});

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  AccountType _accountType = AccountType.ambrosia;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
        top: 32,
        bottom:
            MediaQuery.of(context)
                .viewInsets
                .bottom, // Esta linha serve para reservar espaço em baixo caso o teclado seja aberto
      ),
      height: MediaQuery.of(context).size.height * 0.75,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Center(child: Image.asset('assets/images/icon_add_account.png')),
            const SizedBox(height: 32),
            const Text('Adicionar nova conta', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            const Text(
              'Preencha os dados abaixo',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Sobrenome'),
            ),
            const SizedBox(height: 16),
            const Text("Tipo da Conta"),
            DropdownButtonFormField<AccountType>(
              value: _accountType,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _accountType = newValue;
                  });
                }
              },
              items:
                  AccountType.values.map((type) {
                    return DropdownMenuItem<AccountType>(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        (_isLoading)
                            ? null
                            : () {
                              onButtonCancelClicked;
                            },
                    style: const ButtonStyle(
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(color: Colors.black),
                      ),
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onButtonAddClicked(),
                    style: const ButtonStyle(
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(color: Colors.black),
                      ),
                      backgroundColor: WidgetStatePropertyAll(AppColors.orange),
                    ),
                    child:
                        _isLoading
                            ? SizedBox(
                              height: 16,
                              width: 16,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Adicionar',
                              style: TextStyle(color: Colors.black),
                            ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onButtonCancelClicked() {
    if (_isLoading) return;
    Navigator.pop(context);
  }

  onButtonAddClicked() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    String name = _nameController.text;
    String lastName = _lastNameController.text;
    Account account = Account(
      id: Uuid().v4(),
      name: name,
      lastName: lastName,
      balance: 0,
      accountType: _accountType,
    );
    await AccountService().addAccount(account);
    closeModal();
  }

  closeModal() {
    Navigator.pop(context);
  }
}
