import 'package:HaltonBusAPI/HaltonBusAPI.dart';
import 'package:xml/xml.dart' as xml;

main() async {

  //initialize API. It's instance is managed by a Singleton, so you may reinitialize multiple times with little cost.
  var api = new BusAPI();

  //get 'latest' (may be cached) version of delays.
  var latest = await api.latest();

  //metadata: print out when the bus report was last updated. BusAPI#latest must be called at least once before doing this
  print(api.reportLastUpdated());

  //print each delays route
  latest.forEach((delay) => print(delay.route));

  //print each delays' affected schools
  latest.forEach((delay) => delay.schools.forEach(print));

  //print the routes and their status which affect a certain school (eg. ROBERT BATEMAN HS)
  print("\nBuses late for Robert Bateman: ");
  var sampleSchoolName = "ROBERT BATEMAN HS";
  latest.where((delay) => delay.schools.contains(sampleSchoolName))
      .forEach((delay) => print("Bus route ${delay.route} is ${delay.status}"));

  //Current general status
  print(await api.currentStatus());

  //Access and print raw response data (never cached!)
  //This is commonly used for **DEBUGGING** purposes
  print(await api.reqRaw());

}
