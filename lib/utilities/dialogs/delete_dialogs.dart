import 'package:flutter/material.dart';
import 'package:myapp/utilities/dialogs/generic_dialog.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3719094588.
Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete",
    content: "Are you sure want to delete this item",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
