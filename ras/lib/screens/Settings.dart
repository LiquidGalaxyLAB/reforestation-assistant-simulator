import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ras/services/Authentication.dart';
import 'package:ras/services/Database.dart';
import 'package:ras/services/LGConnection.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ssh/ssh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ras/widgets/AppBar.dart';
import 'package:permission_handler/permission_handler.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isLoggedIn = false;
  bool obscurePassword = true;
  bool loaded = false;
  TextEditingController ipAddress = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _isSigningOut = false;
  User? currentUser = Authentication.currentUser();
  bool connectionStatus = false;

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
      setState(() {
        connectionStatus = true;
      });
      // open logos
      await LGConnection().openDemoLogos();
      await client.disconnect();
    } catch (e) {
      showAlertDialog('Oops!',
          '${ipAddress.text} Host is not reachable. Check if the information given is correct and if the host can be reached');
      setState(() {
        connectionStatus = false;
      });
    }
  }

  checkConnectionStatus() async {
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
      setState(() {
        connectionStatus = true;
      });
      await client.disconnect();
    } catch (e) {
      showAlertDialog('Oops!',
          '${ipAddress.text} Host is not reachable. Check if the information given is correct and if the host can be reached');
      setState(() {
        connectionStatus = false;
      });
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

  exportDb() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      try {
        await DatabaseService().exportDB();
        showAlertDialog('Success!',
            'Database exported! You can find the file in the Download\'s directory');
      } catch (e) {
        print(e);
        showAlertDialog('Error!',
            'An error occured while exporting the database. Please check if you have granted permissions to the app or try again later');
      }
    } else {
      var isGranted = await Permission.storage.request().isGranted;
      if (isGranted) {
        try {
          await DatabaseService().exportDB();
          showAlertDialog('Success!',
              'Database exported! You can find the file in the Download\'s directory');
        } catch (e) {
          print(e);
          showAlertDialog('Error!',
              'An error occured while exporting the database. Please check if you have granted permissions to the app or try again later');
        }
      }
    }
  }

  init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    ipAddress.text = preferences.getString('master_ip') ?? '';
    password.text = preferences.getString('master_password') ?? '';

    await checkConnectionStatus();

    loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) init();

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                currentUser != null
                    ? ListTile(
                        title: Text('${currentUser!.displayName}'),
                        subtitle: Text('${currentUser!.email}'),
                        contentPadding: EdgeInsets.zero,
                        trailing: _isSigningOut
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  side: BorderSide(color: Colors.red, width: 1),
                                ),
                                onPressed: () async {
                                  await Authentication.signOut(
                                      context: context);
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  preferences.setBool('unauthenticated', false);
                                  Navigator.of(context).pushNamed('/login');
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Text(
                                    'LOGOUT',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                        leading: currentUser!.photoURL != null
                            ? ClipOval(
                                child: Material(
                                  color: Colors.grey.shade100,
                                  child: Image.network(
                                    currentUser!.photoURL!,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              )
                            : ClipOval(
                                child: Material(
                                  color: Colors.grey.shade100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.person,
                                        size: 60, color: Colors.blue),
                                  ),
                                ),
                              ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'To Connect to Google Drive',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
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
                                      'assets/logos/google_icon.png',
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
                          ),
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                  child: Text(
                    'Liquid Galaxy Connection',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Status: ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        connectionStatus ? 'CONNECTED' : 'DISCONNECTED',
                        style: TextStyle(fontSize: 17),
                      ),
                      connectionStatus
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            )
                          : Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 20,
                            ),
                    ],
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
                ListTile(
                  leading: Text(
                    '🇺🇸',
                    style: TextStyle(fontSize: 20),
                  ),
                  title: Text('English (US)'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.language,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Export database',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          exportDb();
                        },
                        child: Text('EXPORT'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
