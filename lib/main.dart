import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';
import 'package:ironkey/password_generator.dart';
import 'package:ironkey/pin_password_generator.dart';
import 'package:ironkey/standard_password_generator.dart';

void main() {
  runApp(IronKeyApp());
}

class IronKeyApp extends StatelessWidget {
  const IronKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      title: "IronKey",
      home: IronKeyScreen(),
    );
  }
}

class IronKeyScreen extends StatefulWidget {
  const IronKeyScreen({super.key});

  @override
  State<IronKeyScreen> createState() => _IronKeyScreenState();
}

class _IronKeyScreenState extends State<IronKeyScreen> {
  final TextEditingController _passwordControler = TextEditingController();

  PasswordType passwordTypeSelected = PasswordType.pin;
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    _passwordControler.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordControler.dispose();
    super.dispose();
  }

  void copyPassword(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

  void generatePassword() {
    late final PasswordGenerator generator;

    switch (passwordTypeSelected) {
      case PasswordType.pin:
        generator = PinPasswordGenerator();
        break;
      case PasswordType.standard:
        generator = StandardPasswordGenerator();
        break;
    }

    setState(() {
      _passwordControler.text = generator.generate(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ColorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          "assets/images/ironman.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Sua senha segura",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      enabled: isEditable,
                      controller: _passwordControler,
                      maxLength: 12,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefix: Icon(Icons.lock),
                        suffix: _passwordControler.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  copyPassword(_passwordControler.text);
                                },
                                icon: Icon(Icons.copy),
                              )
                            : null,
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Tipo de senha"),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: PasswordType.pin,
                            title: Text("PIN"),
                            groupValue: passwordTypeSelected,
                            onChanged: (value) {
                              setState(() {
                                passwordTypeSelected = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: PasswordType.standard,
                            groupValue: passwordTypeSelected,
                            title: Text("Senha Padrão"),
                            onChanged: (value) {
                              setState(() {
                                passwordTypeSelected = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    Divider(color: ColorScheme.outline),
                    Row(
                      children: [
                        Icon(isEditable ? Icons.lock_open : Icons.lock),
                        SizedBox(width: 8),
                        Expanded(child: Text("Permitir editar a senha?")),
                        Switch(
                          value: isEditable,
                          onChanged: (value) {
                            setState(() {
                              isEditable = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(color: ColorScheme.outline),
                    const SizedBox(height: 20),

                    if (isEditable) Text("Senha costumizada"),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: generatePassword,
                  child: Text(
                    "Gerar Senha",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum PasswordType { pin, standard }
