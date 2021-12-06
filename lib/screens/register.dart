import 'package:flutter/material.dart';
import 'package:wpp_firebase/commons/models/usuarios.dart';
import 'package:wpp_firebase/commons/services/firebase_services.dart';
import 'package:wpp_firebase/screens/login.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({Key? key}) : super(key: key);

  @override
  State<RegistroPage> createState() => _RegistroPageState();
  static snackbar(String title, String error) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      dismissDirection: DismissDirection.down,
      content: Text(title),
    );
  }
}

class _RegistroPageState extends State<RegistroPage> {
  late String _mensagemErro;
  bool envio = false;

  @override
  void initState() {
    super.initState();
    _mensagemErro = '';
    envio = false;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controllerNome = TextEditingController();
    final TextEditingController _controllerEmail = TextEditingController();
    final TextEditingController _controllerSenha = TextEditingController();
    FirebaseService newFirebase = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff075E54),
        elevation: 0,
        title: const Text("Cadastro"),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff075E54)),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "assests/usuario.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Container(
                  height: 8,
                ),
                TextField(
                  controller: _controllerSenha,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      onPressed: () {
                        String name = _controllerNome.text;
                        String email = _controllerEmail.text;
                        String senha = _controllerSenha.text;

                        validacaoCampo(
                            name, email, senha, newFirebase, context);
                      },
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    _mensagemErro,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validacaoCampo(
    String name,
    String email,
    String senha,
    FirebaseService newFirebase,
    BuildContext context,
  ) {
    if (name.isNotEmpty && email.isNotEmpty && senha.isNotEmpty) {
      Usuarios newUser = Usuarios();
      newUser.name = name;
      newUser.email = email;
      newUser.senha = senha;

      newFirebase.cadastrarUsuario(newUser, context);
    } else if (name.isEmpty) {
      setState(() {
        _mensagemErro = 'Insira o seu nome';
      });
    } else if (email.contains('@')) {
      setState(() {
        _mensagemErro = 'Insira um email válido';
      });
    } else if (senha.isEmpty && senha.length > 6) {
      setState(() {
        _mensagemErro = 'Insira uma senha válida';
      });
    }
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }
}
