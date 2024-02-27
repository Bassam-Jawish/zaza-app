import 'package:flutter/material.dart';

AppBar customAppBar (BuildContext context , String text, bool isPopped, [IconData? iconData,VoidCallback? onPressed]){
    return AppBar(
      leading: isPopped ? IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ) : const SizedBox(),
      centerTitle: true,
      title: Text(text),
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      actions: [
        IconButton(onPressed: onPressed, icon: Icon(iconData))
      ],
    );
}