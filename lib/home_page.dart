import 'package:flutter/material.dart';
import 'package:flutter_auth0/flutter_auth0.dart';

import 'login_page.dart';

final String clientId = '7r4sAmPbAnbr3oELvCLavxP6ccE5xImZ';
final String domain = 'zonar-dev.auth0.com';

class HomePage extends StatefulWidget {
    HomePage({Key key, this.title}) : super(key: key);
    final String title;

    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    Auth0 auth;

    @override
    void initState() {
        auth = Auth0(baseUrl: 'https://$domain/', clientId: clientId);
        super.initState();
    }

    void showInfo(String text, String message) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(text),
                    content: SingleChildScrollView(
                        child: Text(message),
                    ),
                    actions: <Widget>[
                        FlatButton(
                            child: Text("Close"),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                );
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                elevation: 0.7,
                centerTitle: true,
                leading: Image.network(
                    'https://cdn.auth0.com/styleguide/components/1.0.8/media/logos/img/logo-grey.png',
                    height: 40,
                ),
                backgroundColor: Color.fromRGBO(0, 0, 0, 1.0),
                title: Text(widget.title),
            ),
            body: LayoutBuilder(
                builder: (ctx, constraints) {
                    return Container(
                        constraints: constraints,
                        color: Colors.white,
                        child: LoginPage(auth, showInfo),
                    );
                },
            ),
        );
    }
}
