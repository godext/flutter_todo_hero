import 'package:flutter/cupertino.dart';

class CupertinoScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const CupertinoScaffold({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        navigationBar: CupertinoNavigationBar(
          middle: Text(title,
              style: const TextStyle(
                fontSize: 28,
                color: CupertinoColors.white,
              )),
          backgroundColor: CupertinoColors.systemBlue,
        ),
        child: child);
  }
}
