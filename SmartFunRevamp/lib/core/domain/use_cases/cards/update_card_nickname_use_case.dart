import 'package:dartz/dartz.dart';
import 'package:semnox/core/domain/repositories/cards_repository.dart';
import 'package:semnox/core/errors/failures.dart';

class UpdateCardNicknameUseCase {
  final CardsRepository _repository;
  UpdateCardNicknameUseCase(this._repository);
  Future<Either<Failure, void>> call(int cardId, String nickname) async {
    return await _repository.updateCardNickname(cardId, nickname);
  }
}
