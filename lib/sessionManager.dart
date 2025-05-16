// import 'package:flutter/material.dart';
// import 'main.dart';

// class SessionManager {
//   static final SessionManager _instance = SessionManager._internal();
//   factory SessionManager() => _instance;
//   SessionManager._internal();

//   Timer? _logoutTimer;
//   final timeoutDuration = Duration(minutes: 30);

//   void startSession(BuildContext context) {
//     _logoutTimer?.cancel();
//     _logoutTimer = Timer(timeoutDuration, () async {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.clear();
//       Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//     });
//   }

//   void resetSession(BuildContext context) {
//     startSession(context);
//   }

//   void stopSession() {
//     _logoutTimer?.cancel();
//   }
// }



// // 2. Create a wrapper that listens to all user activity:
// // dart
// // Copy
// // Edit
// // class AutoLogoutWrapper extends StatelessWidget {
// //   final Widget child;

// //   const AutoLogoutWrapper({required this.child});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Listener(
// //       onPointerDown: (_) => SessionManager().resetSession(context),
// //       child: child,
// //     );
// //   }
// // }