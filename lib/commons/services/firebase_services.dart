import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wpp_firebase/commons/models/usuarios.dart';
import 'package:wpp_firebase/screens/homepage.dart';
import 'package:wpp_firebase/screens/register.dart';

class FirebaseService {
  void singInFirebase(String email, String senha, context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((value) async {
      final Usuarios newUser = Usuarios();
      DocumentSnapshot result = await db
          .collection('usuarios')
          .doc(value.user!.uid)
          .get()
          .then((documentSnapshot) {
        // if (documentSnapshot.exists) {
        //   print('O documento existe no banco de dados');
        //   print('Document data: ${documentSnapshot.data()}');
        // }
        return documentSnapshot;
      });
      newUser.email = result.get('email');
      newUser.name = result.get('nome');
      newUser.senha = result.get('senha');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  user: newUser,
                  logado: true,
                )),
      );
    });
  }

  void cadastrarUsuario(Usuarios usuarios, BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuarios.email.toString(),
            password: usuarios.senha.toString())
        .then((value) {
      salvarDadosUsuarioDb(usuarios, value.user);
      Future.delayed(const Duration(milliseconds: 100), () {
        ScaffoldMessenger.of(context)
            .showSnackBar(RegistroPage.snackbar('Salvo com sucesso', ''));
      });
    }).catchError((e) {
      Future.delayed(const Duration(milliseconds: 100), () {
        ScaffoldMessenger.of(context)
            .showSnackBar(RegistroPage.snackbar('Error', e.toString()));
      });
    });
  }

  void salvarDadosUsuarioDb(Usuarios usuarios, User? user) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('usuarios').doc(user!.uid).set(usuarios.toMap());
  }

  void logado(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    if (user != null) {
      final Usuarios newUser = Usuarios();
      DocumentSnapshot result = await db
          .collection('usuarios')
          .doc(user.uid)
          .get()
          .then((documentSnapshot) {
        // if (documentSnapshot.exists) {
        //   // print('O documento existe no banco de dados');
        //   // print('Document data: ${documentSnapshot.data()}');
        // }
        return documentSnapshot;
      });

      newUser.email = result.get('email');
      newUser.name = result.get('nome');
      newUser.senha = result.get('senha');
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => HomePage(
                      logado: true,
                      user: newUser,
                    )));
      });
    }
  }
}
