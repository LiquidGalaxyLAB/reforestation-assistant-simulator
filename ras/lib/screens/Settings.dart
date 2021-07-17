import 'package:flutter/material.dart';
import 'package:ras/services/Authentication.dart';
import 'package:ssh/ssh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ras/widgets/AppBar.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isLoggedIn = false;
  bool obscurePassword = true;
  TextEditingController ipAddress = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _isSigningOut = false;

  connect() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('master_ip', ipAddress.text);
    await preferences.setString('master_password', password.text);

    SSHClient client = SSHClient(
      host: ipAddress.text,
      port: 22,
      username: "lg",
      passwordOrKey: password.text,
    );

    try {
      await client.connect();
      showAlertDialog('Connected!', '${ipAddress.text} Host is reachable');
      await client.disconnect();
    } catch (e) {
      showAlertDialog('Oops!',
          '${ipAddress.text} Host is not reachable. Check if the information given is correct and if the host can be reached');
    }
  }

  showAlertDialog(String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$title'),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: Text('$msg'),
          );
        });
  }

  logout() {}

  init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    ipAddress.text = preferences.getString('master_ip') ?? '';
    password.text = preferences.getString('master_password') ?? '';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ipAddress.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: MyAppBar(
            isHome: false,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Liquid Galaxy Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: TextFormField(
                    controller: ipAddress,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'eg. 192.168.0.115',
                      labelText: 'Master machine IP Address',
                    ),
                  ),
                ),
                TextFormField(
                  controller: password,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'eg. the-passw0rd-0f-my-LG',
                    labelText: 'Master machine Password',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      side: BorderSide(color: Colors.blue, width: 1),
                    ),
                    onPressed: () {
                      connect();
                    },
                    child: Text('CONNECT'),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Google Drive Integration',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.setBool('unauthenticated', false);
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image.asset(
                          'assets/google_icon.png',
                          scale: 45,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                _isSigningOut
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          side: BorderSide(color: Colors.red, width: 1),
                        ),
                        onPressed: () async {
                          await Authentication.signOut(context: context);
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.setBool('unauthenticated', false);
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20.0),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.red,
                //       side: BorderSide(color: Colors.red, width: 1),
                //     ),
                //     onPressed: () {
                //       logout();
                //     },
                //     child: Text('LOGOUT'),
                //   ),
                // )
              ],
            ),
          ),
        ));
  }
}
