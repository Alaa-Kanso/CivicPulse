import 'package:frontend/features/operator/data/dataSources/municipality_remote_data_source.dart';
import 'package:frontend/features/operator/domain/entities/municipality.dart';
import 'package:frontend/features/operator/domain/repositories/municipality_repository.dart';

class MunicipalityRepositoryImpl extends MunicipalityRepository {
  final MunicipalityRemoteDataSource municipalityRemoteDataSource;

  MunicipalityRepositoryImpl({required this.municipalityRemoteDataSource});

  @override
  Future<List<Municipality>> getAllMunicipalities() async {
    return await municipalityRemoteDataSource.getAllMunicipalities();
  }

  @override
  Future<List<Municipality>> getAssignedMunicipalities() async{
    return await municipalityRemoteDataSource.getAssignedMunicipalities();
  }
}
