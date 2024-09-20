//Show Error dialog
import 'package:flutter/material.dart';
import 'package:myapp/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context, 
  String text,
  ){
  return showGenericDialog<void>(
    context: context,
    title: 'An Error Occured',
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
} 

