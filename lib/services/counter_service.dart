import 'package:flutter/foundation.dart';
import 'package:my_storage/i_local_storage_repository.dart';
import 'package:my_storage/local_storage_service.dart';

class CounterService {
  final LocalStorageService _localStorageService;
  final String _countKey = "count";

  CounterService({
    @required ILocalStorageRepository localStorageRepository,
  }) : _localStorageService =
            LocalStorageService(localStorageRepository: localStorageRepository);

  Future<int> getCount() async {
    return await _localStorageService.getAll(_countKey) ?? 0;
  }

  Future<int> incrementAndSave(int count) async {
    count += 1;
    await _localStorageService.save(_countKey, count);

    return count;
  }

  Future<int> decrementAndSave(int count) async {
    count -= 1;
    await _localStorageService.save(_countKey, count);

    return count;
  }
}
