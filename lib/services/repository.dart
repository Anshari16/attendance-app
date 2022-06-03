
import 'package:absen/models/absen_model.dart';

abstract class Repository {
  Future<List<Absen>> getAbsen();
}