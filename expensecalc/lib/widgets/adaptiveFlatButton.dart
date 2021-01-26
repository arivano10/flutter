import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String anytext;
  final Function handler;
  const AdaptiveFlatButton(this.anytext,this.handler);
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS?CupertinoButton(child: Text(
                        anytext,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: handler,):FlatButton(
                      child: Text(
                        anytext,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: handler,
                    );
  }
}