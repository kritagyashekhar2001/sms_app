// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:sms_advanced/sms_advanced.dart';

// // backgrounMessageHandler(SmsMessage message) async {
// //   //Handle background message
// //   Telephony.backgroundInstance.listenIncomingSms(
// //       onNewMessage: (SmsMessage smsMessage) {
// //     print(smsMessage);
// //   });
// // }

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   // final telephony = Telephony.instance;
//   @override
//   void initState() {
//     SmsReceiver receiver = new SmsReceiver();
//     receiver.onSmsReceived?.listen((SmsMessage msg) => print(msg.body));

//     // initPlatformState();

//     // TODO: implement initState
//     super.initState();
//   }

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

// // Future<void> initPlatformState() async {

// //     final bool? result = await telephony.requestPhoneAndSmsPermissions;

// //     if (result != null && result) {
// //       telephony.listenIncomingSms(
// //           onNewMessage: (SmsMessage message) {
// //           if (kDebugMode) {
// //             print(message);
// //           }
// //           // Handle message
// //         }, onBackgroundMessage: backgrounMessageHandler);
// //     }

// //     if (!mounted) return;
// //   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "readSmsEvery30Minute":
        readsms();
        print("dasd");
        break;
    }
    print(task);
    return Future.value(true);
  });
}

String sms = 'no sms received';
String sender = 'no sms received';
String amount = 'no sms received';
double totalDayAmount = 0;
SmsQuery query = SmsQuery();
void readsms() async {
  print("dasdsadsadsa");
  print(query);
  List<SmsMessage> messages = [];
  try {
     messages = await query.querySms(
      kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
    );
  } catch (e) {
    print(e.toString());
  }
  print(messages.length);
  for (int i = 0; i < messages.length; i++) {
    print("asdsaassasssss");

    if (messages[i]
        .dateSent!
        .isAfter(DateTime.now().subtract(const Duration(hours: 24)))) {
      if (messages[i].body!.toLowerCase().contains("spent") ||
          messages[i].body!.toLowerCase().contains("debited") ||
          messages[i].body!.toLowerCase().contains("debit") ||
          messages[i].body!.toLowerCase().contains("payment of") ||
          messages[i].body!.toLowerCase().contains("Transaction successful")) {
        List<double> amounts = [];

        final regex = RegExp(r'(?:INR|Rs.)\s*(\d+(?:[.,]\d+)*)');
        final matches = regex.allMatches(messages[i].body!);
        String amountWithSymbols = "";
        for (final Match m in matches) {
          // setState(() {
          amountWithSymbols = amountWithSymbols + m[0]!;
          // });
        }
        final regexWithAvaliableBalance = RegExp(
            r'(?:avl bal rs:|avl bal inr:|avl limit rs:|avl limit inr:|avbl limit rs:|avbl limit inr:|avl bal: rs.|avl bal: inr|avl limit: rs.|avl limit: inr|avbl limit: rs|avbl limit: inr|avl lmt: rs|avl lmt: inr)\s*(\d+(?:[.,]\d+)*)');
        final matchOfAvalBalance = regexWithAvaliableBalance
            .allMatches(messages[i].body!.toLowerCase());
        String amountWithAvlBalance = "";
        for (final Match m in matchOfAvalBalance) {
          // setState(() {
          amountWithAvlBalance = amountWithAvlBalance + m[0]!;
          // });
        }

        final regexOfOnlyAmount = RegExp(r'(\d+(?:[.,]\d+)*)');
        final matchesOfAmount = regexOfOnlyAmount.allMatches(amountWithSymbols);
        for (final Match m in matchesOfAmount) {
          // setState(() {
          amounts.add(double.parse(m[0]!.replaceAll(RegExp(','), '')));
          // });
        }
        final matchesOfAvlAmount =
            regexOfOnlyAmount.allMatches(amountWithAvlBalance);
        for (final Match m in matchesOfAvlAmount) {
          amounts.remove(double.parse(m[0]!.replaceAll(RegExp(','), '')));
        }
        totalDayAmount = totalDayAmount + amounts.reduce(min);
      }
    }
  }
  print(totalDayAmount);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _plugin = Readsms();

  @override
  void initState() {
    super.initState();
    // readsms();

    getPermission().then((value) {
      Workmanager().initialize(callbackDispatcher);
      Workmanager().registerPeriodicTask(
        "readSms",
        "readSmsEvery30Minute",
        frequency: const Duration(minutes: 30),
      );
      Workmanager().registerPeriodicTask(
        "sendNotification",
        "sendNotificationEvery24Hour",
        frequency: const Duration(minutes: 30),
      );
      // if (value) {
      //   _plugin.read();
      //   _plugin.smsStream.listen((event) {
      //     if (event.body.toLowerCase().contains("spent") ||
      //         event.body.toLowerCase().contains("debited") ||
      //         event.body.toLowerCase().contains("debit") ||
      //         event.body.toLowerCase().contains("payment of") ||
      //         event.body.toLowerCase().contains("Transaction successful")) {
      //       final regex = RegExp(r'(?:INR|Rs.)\s*(\d+(?:[.,]\d+)*)');
      //       final matches = regex.allMatches(event.body);
      //       String amountWithSymbols = "";
      //       for (final Match m in matches) {
      //         setState(() {
      //           amountWithSymbols = amountWithSymbols + m[0]!;
      //         });
      //       }
      //       final regexWithAvaliableBalance = RegExp(
      //           r'(?:avl bal rs:|avl bal inr:|avl limit rs:|avl limit inr:|avbl limit rs:|avbl limit inr:|avl bal: rs.|avl bal: inr|avl limit: rs.|avl limit: inr|avbl limit: rs|avbl limit: inr|avl lmt: rs|avl lmt: inr)\s*(\d+(?:[.,]\d+)*)');
      //       final matchOfAvalBalance =
      //           regexWithAvaliableBalance.allMatches(event.body.toLowerCase());
      //       String amountWithAvlBalance = "";
      //       for (final Match m in matchOfAvalBalance) {
      //         setState(() {
      //           amountWithAvlBalance = amountWithAvlBalance + m[0]!;
      //         });
      //       }

      //       print(amountWithSymbols);
      //       final regexOfOnlyAmount = RegExp(r'(\d+(?:[.,]\d+)*)');
      //       final matchesOfAmount =
      //           regexOfOnlyAmount.allMatches(amountWithSymbols);
      //       for (final Match m in matchesOfAmount) {
      //         setState(() {
      //           amounts.add(double.parse(m[0]!.replaceAll(RegExp(','), '')));
      //         });
      //         print(m[0]);
      //       }
      //       final matchesOfAvlAmount =
      //           regexOfOnlyAmount.allMatches(amountWithAvlBalance);
      //       for (final Match m in matchesOfAvlAmount) {
      //         amounts.remove(double.parse(m[0]!.replaceAll(RegExp(','), '')));

      //         print(m[0]);
      //       }

      //       print("amount");
      //       print(amounts);
      //       print(amounts.reduce(min));
      //     }
      //     setState(() {
      //       sms = event.body;
      //       sender = event.sender;
      //       amount = amounts.reduce(min).toString();
      //     });
      //   });
      // }
    });
  }

  Future<bool> getPermission() async {
    if (await Permission.sms.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.sms.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _plugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('new sms received: $sms'),
              Text('new sms Sender: $sender'),
              Text('amount: $totalDayAmount'),
            ],
          ),
        ),
      ),
    );
  }
}
