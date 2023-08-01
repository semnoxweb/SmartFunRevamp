import 'package:dartz/dartz.dart';
import 'package:semnox/core/domain/repositories/select_location_repository.dart';
import 'package:semnox/core/errors/failures.dart';
import 'package:semnox_core/modules/sites/model/site_view_dto.dart';

class GetMasterSiteUseCase {
  final SelectLocationRepository _repository;
  GetMasterSiteUseCase(this._repository);
  Future<Either<Failure, List<SiteViewDTO>>> call() async {
    return await _repository.getMasterSite();
  }
}
