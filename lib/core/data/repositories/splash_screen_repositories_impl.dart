import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:semnox/core/api/smart_fun_api.dart';
import 'package:semnox/core/domain/entities/splash_screen/authenticate_system_user.dart';
import 'package:semnox/core/domain/repositories/splash_screen_repositories.dart';
import 'package:semnox/core/errors/failures.dart';
import 'package:semnox/core/utils.dart';

class SplashScreenRepositoryImpl implements SplashScreenRepository {
  final SmartFunApi _api;

  SplashScreenRepositoryImpl(this._api);

  @override
  Future<Either<Failure, void>> getAllSites() async {
    try {
      final response = await _api.getAllSites();
      Logger().d(response);
      return const Right(null);
    } on DioError catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Not Found'));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(message['data']));
    }
  }

  @override
  Future<Either<Failure, void>> getAppImages({required String imageType, required String lastModifiedDate}) async {
    try {
      final response = await _api.getAppImages(imageType, lastModifiedDate);
      Logger().d(response);
      return const Right(null);
    } on DioError catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Not Found'));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(message['data']));
    }
  }

  @override
  Future<Either<Failure, void>> getAppProductsImages({required String imageType, required String lastModifiedDate}) async {
    try {
      final response = await _api.getAppProductsImages(lastModifiedDate, imageType);
      Logger().d(response);
      return const Right(null);
    } on DioError catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Not Found'));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(message['data']));
    }
  }

  @override
  Future<Either<Failure, void>> getContactType() async {
    try {
      final response = await _api.getContactType();
      Logger().d(response);
      return const Right(null);
    } on DioError catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Not Found'));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(message['data']));
    }
  }

  @override
  Future<Either<Failure, void>> getHomePageCMS({required String moduleName, required String isActive, required String buildChildRecords, required String activeChildRecords}) async {
    try {
      final response = await _api.getHomePageCMS(moduleName, isActive, buildChildRecords, activeChildRecords);
      Logger().d(response);
      return const Right(null);
    } on DioError catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Not Found'));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(message['data']));
    }
  }

  @override
  Future<Either<Failure, void>> getParafaitDefaults({required String siteId, required String userPkId, required String machineId}) async {
    try {
      final response = await _api.getParafaitDefaults(siteId, userPkId, machineId);
      Logger().d(response);
      return const Right(null);
    } on DioError catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Not Found'));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(message['data']));
    }
  }

  @override
  Future<Either<Failure, void>> getParafaitLanguages({required String siteId}) async {
    try {
      final response = await _api.getParafaitLanguages(siteId);
      Logger().d(response);
      return const Right(null);
    } on DioError catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Not Found'));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(message['data']));
    }
  }

  @override
  Future<Either<Failure, void>> getStringsForLocalization({required String siteId, required String languageId, String outputForm = 'JSON'}) async {
    try {
      final response = await _api.getStringsForLocalization(siteId, languageId, outputForm);
      Logger().d(response);
      return const Right(null);
    } on DioError catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Not Found'));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(message['data']));
    }
  }

  @override
  Future<Either<Failure, void>> getBaseURLFromCentral({required String appId, required String buildNumber, required String generatedTime, required String securityCode}) async {
    try {
      Logger().d(generatedTime);
      final response = await _api.getBaseURLFromCentral(
        appId,
        buildNumber,
        generatedTime,
        securityCode,
        {
          "codeHash": await generateHashCode(generatedTime: generatedTime),
        },
      );
      Logger().d(response);
      return const Right(null);
    } on DioError catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Not Found'));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(message['data']));
    }
  }

  @override
  Future<Either<Failure, SystemUser>> authenticateBaseURL() async {
    try {
      final response = await _api.authenticateSystemUser(
        {
          "LoginId": "ParafaitPOS",
          "Password": "semnoX!1",
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Not Found'));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(message['data']));
    }
  }
}