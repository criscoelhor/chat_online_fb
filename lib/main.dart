import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  Firestore.instance
      .collection("teste")
      .document("testeDocument")
      .setData({"teste": "teste"});

  runApp(MyApp());
}

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
    primarySwatch: Colors.purple, accentColor: Colors.orangeAccent[400]);

final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) user = await googleSignIn.signInSilently();

  if (user == null) user = await googleSignIn.signIn();

  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: credentials.accessToken,
      idToken: credentials.idToken,
    );
    await auth.signInWithCredential(credential);
  }
}

_handleSubmitted(String text) async{
    await _ensureLoggedIn();

    _setMessage(text: text);
}

void _setMessage({String text, String imgUrl}){

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Chat App",
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context).platform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: ChatScreen());
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat App"),
          centerTitle: true,
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[ChatMessage(), ChatMessage(), ChatMessage()],
              ),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(),
            )
          ],
        ),
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  final _textController = TextEditingController();

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200])))
              : null,
          child: Row(
            children: <Widget>[
              Container(
                child: IconButton(
                    icon: Icon(Icons.photo_camera), onPressed: () {}),
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration.collapsed(
                      hintText: "Enviar uma Mensagem"),
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.length > 0;
                    });
                  },
                  onSubmitted: (text){
                    _handleSubmitted(text);
                  },
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoButton(
                          child: Text("Enviar"),
                          onPressed: _isComposing ? () {
                            _handleSubmitted(_textController.text);
                          } : null,
                        )
                      : IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _isComposing ? () {
                            _handleSubmitted(_textController.text);
                          } : null,
                        ))
            ],
          ),
        ));
  }
}

class ChatMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "http://lh3.googleusercontent.com/a-/AAuE7mDNrd3OYZc_6YBg3e6U_FNLrOtlkpxjnS5c8zxfgJU=s96-cc"),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Cristiano",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text("Message"),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
