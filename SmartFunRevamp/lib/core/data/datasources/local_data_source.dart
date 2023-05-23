import 'package:dartz/dartz.dart';
import 'package:glutton/glutton.dart';

import 'package:logger/logger.dart';
import 'package:semnox/core/errors/failures.dart';
import 'package:semnox_core/modules/sites/model/site_view_dto.dart';

abstract class LocalDataSource {
  static String kSitesListKey = 'sites_list';
  static String kFirstTime = 'first_time';
  static String kSelectedSite = 'selected_site';
  static String kUserId = 'userId';
  Future<void> saveSites(List<SiteViewDTO> sites);
  Future<List<SiteViewDTO>> retrieveSites();
  // Future<bool> retrieveBool(String key);
  Future<void> saveValue(String key, dynamic value);
  Future<T?> retrieveValue<T>(String key);
  Future<void> deleteValue(String key);
  Future<void> saveCustomClass(String key, Map<String, dynamic> json);
  Future<void> deleteCustomClass(String key);
  Future<Either<Failure, Map<String, dynamic>>> retrieveCustomClass(String key);
}

class GluttonLocalDataSource implements LocalDataSource {
  @override
  Future<void> saveSites(List<SiteViewDTO> sites) async {
    try {
      final result = await Glutton.eat(LocalDataSource.kSitesListKey, sites.map((e) => e.toJson()).toList());
      Logger().d('Result->$result');
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Future<List<SiteViewDTO>> retrieveSites() async {
    try {
      final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(await Glutton.vomit(LocalDataSource.kSitesListKey, []));
      return list.map((e) => SiteViewDTO.fromJson(e)).toList();
    } catch (e) {
      Logger().e(e);
      return [];
    }
  }

  @override
  Future<void> saveValue(String key, dynamic value) async {
    try {
      await Glutton.eat(key, value);
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Future<T?> retrieveValue<T>(String key) async {
    try {
      return await Glutton.vomit(key) as T;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  @override
  Future<void> deleteValue(String key) async {
    try {
      await Glutton.digest(key);
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Future<void> saveCustomClass(String key, Map<String, dynamic> json) async {
    try {
      await Glutton.eat(key, json);
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> retrieveCustomClass(String key) async {
    try {
      return Right(await Glutton.vomit(key));
    } catch (e) {
      Logger().e(e);
      return Left(LocalDataSourceFailure('Error Retrieving Key'));
    }
  }

  @override
  Future<void> deleteCustomClass(String key) async {
    try {
      await Glutton.digest(key);
    } catch (e) {
      Logger().e(e);
    }
  }
}
