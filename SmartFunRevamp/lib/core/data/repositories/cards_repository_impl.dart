import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:semnox/core/api/smart_fun_api.dart';
import 'package:semnox/core/domain/entities/card_details/account_credit_plus_dto_list.dart';
import 'package:semnox/core/domain/entities/card_details/account_game_dto_list.dart';
import 'package:semnox/core/domain/entities/card_details/card_activity.dart';
import 'package:semnox/core/domain/entities/card_details/card_activity_details.dart';
import 'package:semnox/core/domain/entities/card_details/card_details.dart';
import 'package:semnox/core/domain/entities/transfer/transfer_balance.dart';
import 'package:semnox/core/domain/repositories/cards_repository.dart';
import 'package:semnox/core/errors/failures.dart';
import 'package:semnox/features/splash/provider/splash_screen_notifier.dart';

class CardsRepositoryImpl implements CardsRepository {
  final SmartFunApi _api;

  CardsRepositoryImpl(this._api);
  @override
  Future<Either<Failure, List<CardDetails>>> getCards(String userId) async {
    try {
      final response = await _api.getUserCards(userId);
      List<CardDetails> allCards = response.data;
      //sorting all cards by date (descending)
      allCards.sort((b, a) => (a.expiryDate ?? DateTime.now().toIso8601String()).compareTo(b.expiryDate ?? DateTime.now().toIso8601String()));
      //creating 3 copies of the sorted list
      final List<CardDetails> blockedCards = [...allCards];
      final List<CardDetails> expiredCards = [...allCards];
      final List<CardDetails> activeCards = [...allCards];
      //removing all non expired cards
      expiredCards.removeWhere((element) => (!element.isExpired()));
      //removing all expired and non blocked cards
      blockedCards.removeWhere((element) => (!element.isBlocked()));
      blockedCards.removeWhere((element) => (element.isExpired()));
      //removing all expired and blocked cards
      activeCards.removeWhere((element) => (element.isExpired() || element.isBlocked()));
      //adding in desired group order
      final List<CardDetails> sortedCards = [...activeCards, ...blockedCards, ...expiredCards];
      return Right(sortedCards);
    } on DioException catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('Not Found')));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel(message['data'])));
    } catch (e) {
      Logger().e(e);
      return Left(ServerFailure(''));
    }
  }

  @override
  Future<Either<Failure, CardDetails>> getCardDetails(String accountNumber) async {
    try {
      final response = await _api.getCardDetails(accountNumber);
      Logger().d('Tarjetas ${response.data.length}');
      return Right(response.data.first);
    } on DioException catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('Not Found')));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel(message['data'])));
    } catch (e) {
      Logger().e(e);
      return Left(ServerFailure(''));
    }
  }

  @override
  Future<Either<Failure, List<AccountCreditPlusDTOList>>> getBonusSummary(String accountNumber) async {
    try {
      final response = await _api.getBonusSummary(accountNumber);
      final cleanList = response.data.first.accountCreditPlusDTOList;
      cleanList?.removeWhere((element) => element.periodFrom == null);
      return Right(cleanList ?? []);
    } on DioException catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('Not Found')));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel(message['data'])));
    } catch (e) {
      Logger().e(e);
      return Left(ServerFailure(''));
    }
  }

  @override
  Future<Either<Failure, List<AccountGameDTOList>>> getAccountGamesSummary(String accountNumber) async {
    try {
      final response = await _api.getBonusSummary(accountNumber);
      final cleanList = response.data.first.accountGameDTOList;
      cleanList?.removeWhere((element) => element.fromDate == null);
      Logger().d(response.data);
      return Right(cleanList ?? []);
    } on DioException catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('Not Found')));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel(message['data'])));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, void>> linkCardToUser(String cardNumber, String userId) async {
    try {
      final cardDetail = await _api.getCardDetails(cardNumber);
      if (cardDetail.data.isEmpty) {
        return Left(ServerFailure('Card has no info'));
      }
      if (cardDetail.data.first.customerId != -1) {
        return Left(ServerFailure('Card is already linked to another user'));
      }
      final response = await _api.linkCardToCustomer({
        "SourceAccountDTO": {"AccountId": cardDetail.data.first.accountId},
        "CustomerDTO": {"Id": userId}
      });
      Logger().d(response.data);
      return const Right(null);
    } on DioException catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('Not Found')));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel(message['data'])));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, List<CardActivity>>> getCardActivityLog(String cardId) async {
    try {
      final response = await _api.getCardActivityDetail(cardId);
      return Right(response.data);
    } on DioException catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('Not Found')));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel(message['data'])));
    } catch (e) {
      Logger().e(e);
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('This card has no activities')));
    }
  }

  @override
  Future<Either<Failure, void>> lostCard(Map<String, dynamic> body) async {
    try {
      await _api.lostCard(body);
      return const Right(null);
    } on DioException catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('Not Found')));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel(message['data'])));
    } catch (e) {
      Logger().e(e);
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('This card has no activities')));
    }
  }

  @override
  Future<Either<Failure, CardActivityDetails>> getCardActivityTransactionDetail(String transactionId, bool buildReceipt) async {
    try {
      final response = await _api.getTransactionDetail(transactionId, buildReceipt: buildReceipt);
      return Right(response.data.first);
    } on DioException catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('Not Found')));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel(message['data'])));
    } catch (e, s) {
      Logger().e(s);
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('This Activity has no details')));
    }
  }

  @override
  Future<Either<Failure, String>> transferBalance(TransferBalance transferBalance) async {
    try {
      if (transferBalance.to.accountId == null) {
        transferBalance.to = (await _api.getCardDetails(transferBalance.to.accountNumber ?? '')).data.first;
      }
      final response = await _api.transferBalance(transferBalance.toJson());

      return Right(response.data);
    } on DioException catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('Not Found')));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel(message['data'])));
    } catch (e) {
      Logger().e(e);
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('This Activity has no details')));
    }
  }

  @override
  Future<Either<Failure, void>> updateCardNickname(int cardId, String nickname) async {
    try {
      await _api.updateCardNickname(
        cardId.toString(),
        {
          "accountId": cardId,
          "accountIdentifier": nickname,
        },
      );
      // Logger().d(response.data);
      return const Right(null);
    } on DioException catch (e) {
      Logger().e(e);
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel('Not Found')));
      }
      final message = json.decode(e.response.toString());
      return Left(ServerFailure(SplashScreenNotifier.getLanguageLabel(message['data'])));
    } catch (e) {
      rethrow;
    }
  }
}
