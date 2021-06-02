import 'package:flutter/material.dart';
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
            title: Text('$title'),
            content: Text('$msg'),
            actions: <Widget>[
              OutlinedButton(
                child: Text("CLOSE"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.blue,
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
              ),
            ],
          );
        });
  }

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
          child: MyAppBar(),
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
                  child: TextField(
                    controller: ipAddress,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'eg. 192.168.0.115',
                      labelText: 'Master machine IP Address',
                    ),
                  ),
                ),
                TextField(
                  controller: password,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
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
                !isLoggedIn
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            // TODO: Implement signin with google
                            isLoggedIn = true;
                          });
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
                      )
                    : SizedBox(),
                isLoggedIn
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          'You are logged in as XXXXXXXX',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ))
                    : SizedBox(),
                isLoggedIn
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.red,
                            side: BorderSide(color: Colors.red, width: 1),
                          ),
                          onPressed: () {
                            setState(() {
                              // TODO: Implement Logout
                              isLoggedIn = false;
                            });
                          },
                          child: Text('LOGOUT'),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ));
  }
}
