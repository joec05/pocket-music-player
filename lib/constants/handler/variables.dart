import 'package:flutter/material.dart';

/// Duration in seconds in which the snackbar will be displayed
Duration duration = const Duration(seconds: 3);

/// The behavior of the snackbar. Currently set to float.
SnackBarBehavior behavior = SnackBarBehavior.floating;

/// A fixed padding for the snackbar
EdgeInsets padding = const EdgeInsets.all(15);

/// A fixed margin for the snackbar
EdgeInsets margin = const EdgeInsets.all(10);

/// A fixed border radius for the snackbar
ShapeBorder shape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12.5)
);