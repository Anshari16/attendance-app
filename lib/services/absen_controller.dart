import 'package:absen/models/absen_model.dart';
import 'package:absen/services/repository.dart';

class AbsenController {
  final Repository _repository;

  AbsenController(this._repository);

  // get
  Future<List<Absen>> fetchAbsenList() async {
    return _repository.getAbsen();
  }

}