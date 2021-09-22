import 'package:flutter/cupertino.dart';

class BaseBackGroundWidget extends StatelessWidget {
  final Widget child;
  const BaseBackGroundWidget({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getBackgroundImage(),
        child
      ],
    );
  }

  Widget _getBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/bg_A.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
    );
  }

}