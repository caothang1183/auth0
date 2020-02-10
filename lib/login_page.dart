import 'package:flutter/material.dart';
import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
    final auth;
    final Function showInfo;

    const LoginPage(this.auth, this.showInfo);

    @override
    _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    bool logged;
    TextEditingController txtUsername;
    TextEditingController txtPassword;
    String token;

    @override
    void initState() {
        super.initState();
        logged = false;
        txtUsername = TextEditingController(text: 'coach.driver@coachtest.com');
        txtPassword = TextEditingController(text: 'driver@coach');
    }

    Auth0 get auth {
        return widget.auth;
    }

    Function get showInfo {
        return widget.showInfo;
    }

    void _signIn() async {
        try {
            var response = await auth.auth.passwordRealm({
                'username': txtUsername.text,
                'password': txtPassword.text,
                'audience': 'http://apidev.zonarsystems.net/',
                'realm': 'Username-Password-Authentication'
            });
            token = response['access_token'];
            showInfo('Sign In', '''
      \nAccess Token: $token
      ''');
        } catch (e) {
            showInfo('Error', e.toString());
        }
    }

    void _userInfo() async {
        try {
            var response = await auth.auth.passwordRealm({
                'username': txtUsername.text,
                'password': txtPassword.text,
                'realm': 'Username-Password-Authentication'
            });
            Auth0Auth authClient = Auth0Auth(
                auth.auth.clientId, auth.auth.client.baseUrl,
                bearer: response['access_token']);
            var info = await authClient.getUserInfo();
            String buffer = '';
            info.forEach((k, v) => buffer = '$buffer\n$k: $v');
            showInfo('User Info', buffer);
        } catch (e) {
            showInfo('Error', e.toString());
        }
    }

    void _getApi() async {
        try {
            var response = await http.get(
                'https://zonar-nonprod-dev.apigee.net/core/v1beta2/drivers/025888e6-82c3-4828-a4b6-4f89b199f269',
                headers: {
                    "Authorization": 'Bearer $token',
                    "Accept": 'application/json',
                    "X-Application-Name":'coach-mobile'
                });
            showInfo('Data Api', response.body.toString());
        } catch (e) {
            showInfo('Error', e.toString());
        }
    }

    @override
    Widget build(BuildContext context) {
        bool canSignIn = (txtUsername.text != null &&
            txtPassword.text != null &&
            txtUsername.text.isNotEmpty &&
            txtPassword.text.isNotEmpty);
        return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        TextField(
                            enabled: !logged,
                            controller: txtUsername,
                            decoration: const InputDecoration(
                                hintText: 'Email/Username',
                            ),
                            onChanged: (e) {
                                setState(() {});
                            },
                        ),
                        TextField(
                            enabled: !logged,
                            controller: txtPassword,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: 'Password',
                            ),
                            onChanged: (e) {
                                setState(() {});
                            },
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                MaterialButton(
                                    child: const Text('Sign In'),
                                    color: Colors.blueAccent,
                                    textColor: Colors.white,
                                    onPressed: canSignIn && !logged ? _signIn : null,
                                ),
                                MaterialButton(
                                    color: Colors.indigo,
                                    textColor: Colors.white,
                                    child: const Text('User Info'),
                                    onPressed: canSignIn ? _userInfo : null,
                                ),
                                MaterialButton(
                                    color: Colors.white70,
                                    textColor: Colors.black,
                                    child: const Text('Get Data from API'),
                                    onPressed: _getApi,
                                ),
                            ],
                        ),

                    ],
                ),
            ),
        );
    }


}
