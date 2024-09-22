import 'package:flutter/material.dart';
import 'package:myapp/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialiog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'Cannot share an empty note',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
