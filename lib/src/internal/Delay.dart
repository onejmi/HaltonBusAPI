import 'package:intl/intl.dart';

/**
 * Wraps items from https://haltonbus.ca/ bus delays
 * in an obscure-free and simple manner.
 * Route, Schools, Time and status may be accessed through this API
 */
class Delay {

  //private members
  int _route;
  List<String> _schools;
  DateTime _time;
  String _status;

  ///route of bus which is delayed
  int get route => _route;
  ///Schools potentially affected by this delay (late bus is to bring kids to the specified schools)
  List<String> get schools => _schools;
  ///Time of notice (GMT)
  DateTime get time => _time;
  ///Delay status (example: 10-15 minutes)
  String get status => _status;

  ///Build a delay object, wrapping [delayData] as the payload from an HTTP request to the site
  Delay(String delayData) {
    _route = int.parse(delayData.substring(delayData.indexOf("Route:")+7,delayData.indexOf("&nbsp;")));
    _schools = delayData.substring(delayData.indexOf("Schools potentially affected: ")+30,delayData.indexOf("https")-12).split(",");
    _time = new DateFormat("EEE, dd MMM yyyy hh:mm:ss zzz")
              .parse(delayData.substring(delayData.indexOf("Cancellations.aspx")+26,delayData.indexOf("GMT")+3));
    _status = delayData.substring(delayData.indexOf("Status:")+8,delayData.indexOf("<"));
  }

  ///Returns a formatted string which includes the [route], [status], [schools] and [time] of this delay
  @override
  toString() {
    return "Delay at route $route, resulting in a $status.\n"
        "Affeced schools include ${schools.reduce((sch1,sch2) => "$sch1, $sch2")} [$time]";
  }

  ///[other] is equal to this object if [other] has the same route, as their can only be one delay report per route
  @override
  bool operator ==(other) {
    return other is Delay && other.route==this.route;
  }

  ///Unique hash of this Delay object is of the same value as [route]
  @override
  int get hashCode {
    return route;
  }
}