import 'package:cleandex/core/network/error/app_exceptions.dart';
import 'package:cleandex/data/model/response/pokedex_response.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_base_helper.dart';
import '../../../../core/network/network_service.dart';
import '../path_remote.dart';
import '../remote_data_source.dart';

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final NetworkService client;
  CharacterRemoteDataSourceImpl({required this.client});

  @override
  Future<ResponsePokedex> getAllCharacter(int page) async {
    try {
      var url = "${PathRemote.pokedexPath}/$page";
      var response = await client.getRequest(url);
      response = returnResponse(response);
      return ResponsePokedex.fromMap(response.data);
    } on DioException catch (err) {
      throw DioCustomException(
        type: err,
        message: err.message ?? '',
      );
    }
  }
}
