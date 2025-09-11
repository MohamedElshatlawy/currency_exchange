import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:x_transfer/core/util/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  final InternetConnectionChecker connectionChecker =
      MockInternetConnectionChecker();
  NetworkInfo networkInfo = NetworkInfoImpl(connectionChecker);

  test('should call NetworkInfo Check Network Connection', () async {
    when(connectionChecker.hasConnection).thenAnswer((_) => Future.value(true));
    bool isConnected = await networkInfo.isConnected;
    expect(isConnected, true);
  });
}
