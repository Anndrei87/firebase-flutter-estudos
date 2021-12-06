import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wpp_firebase/commons/models/usuarios.dart';
import 'package:wpp_firebase/screens/login.dart';
import 'package:wpp_firebase/screens/register.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.user,
    required this.logado,
  }) : super(key: key);
  final Usuarios? user;
  final bool logado;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green, title: const Text('Bem vindo ')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.user!.name == null
                ? const Text('Firebase-Estudos')
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Olá ${widget.user!.name}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
            widget.logado
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text('Login')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistroPage()),
                  );
                },
                child: const Text('Cadastro')),
            ElevatedButton(
                onPressed: () async {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.signOut();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Deslogar'))
          ],
        ),
      ),
    );
  }
}
