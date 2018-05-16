import 'package:HaltonBusAPI/HaltonBusAPI.dart';
import 'package:test/test.dart';

void main() {
  group('API tests', () {
    BusAPI busAPI;

    setUp(() {
     busAPI = new BusAPI();
    });

    test('XML parse validility', () async {
      expect((await busAPI.reqRaw()).toString(),startsWith("<"));
    });

    test("Cache filled", () async {
      //SHOULD fill cache if empty
      var payload = await busAPI.latest();
      expect(payload,isNotNull);
    });

  });
}
