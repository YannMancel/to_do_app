import 'dart:async';

import 'package:to_do_app/bloc_layer/base_bloc.dart';
import 'package:to_do_app/data_layer/item.dart';

/// A [BLoC] subclass.
class DatabaseBLoC extends BLoC {

  // FIELDS --------------------------------------------------------------------

  final _controller = StreamController<List<Item>>();
  Stream<List<Item>> get databaseStream => _controller.stream;

  // METHODS -------------------------------------------------------------------

  // -- BLoC --

  @override
  void dispose() => _controller.close();

  // -- StreamController --



}