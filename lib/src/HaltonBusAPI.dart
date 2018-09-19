import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';
import 'package:HaltonBusAPI/HaltonBusAPI.dart';

///URL to resource/website which bus delay information is retrieved from. Only English is supported (for now)
const reportResource = "https://geoquery.haltonbus.ca/rss/Transportation-en-CA.xml";
///Index in raw data ([String]) of [reportResource]'s XML where data starts to be relevant and properly formatted (in XML)
const payloadStart = 3;

/**
 * API which interfaces with https://haltonbus.ca/, specifically [reportResource], to
 * provide information on bus delays in Halton District School Board. This API mainly acts
 * as a wrapper to formulate easy, organized, optimized, and relevant access to the bus reports.
 * 
 * DISCLAIMER: if the [reportResource] is down, this library MAY NOT FUNCTION CORRECTLY
 */
class BusAPI {
  ///global BusAPI instance, there can only be ONE
  static BusAPI _instance;
  ///response cache, refreshed every ~4 minutes
  _Cache _cache;
  ///Singleton, which returns [_instance] on call, or lazy initializes it if null
  factory BusAPI() {
    return (_instance ??= new BusAPI._internal());
  }
  ///internal constructor used by [BusAPI]'s Singleton
  BusAPI._internal();

  /**
   * Returns a raw [xml.XmlDocument] straight from [reportResource]
   * This method does NOT cache it's results
  **/
  Future<XmlDocument> reqRaw() async {
    var response = await http.get(reportResource);
    return parse(response.body.substring(payloadStart));
  }

  /**
   * Returns a non-growable/immutable list of [Delay] objects for each transportation delay which is reported
   * This method uses [_cache] to retrieve its information, limiting the amount of requests
   * to a maximum of once every 4 minutes. Takes an optional parameter [invalidate] to force-replenish the cache of delays with
   * updated data.
   */
  Future<List<Delay>> latest({invalidate = false}) async {
    _cache?.invalidated = invalidate;
    if(_cache == null || _cache.isExpired()) {
      _cache = new _Cache(await reqRaw());
    }
    return _cache.response.findAllElements("item")
        .map((el) => new Delay(el.text)).toList(growable: false);
  }

  /**
   * Retrieves the latest 'lastBuildDate', which is meant to be the last time the
   * [reportResource] report was updated. Note, this will return null if the cache is empty (meaning
   * [latest] was never called)
   */
  reportLastUpdated() => new DateFormat("EEE, dd MMM yyyy hh:mm:ss zzz")
      .parse(_cache?.response?.findAllElements("lastBuildDate")?.first?.text);

}

/**
 * Caches an XML response from [reportResource] for [lifeDuration]
 * milliseconds until needing to be replaced. This is put in to prevent redundant
 * uses of resources and time, as cache can be accessed instead of a costly new request
 */
class _Cache {
  ///Duration until cache expires
  static const lifeDuration = 240000;
  ///Time (since Epoch) of cache creation
  final _timestamp;
  ///Where the requested document ([reportResource]) is stored
  final XmlDocument response;

  bool invalidated = false;

  /**
   * Constructs a new cache, setting the [_timestamp] to the current time
   */
  _Cache(this.response) : _timestamp = new DateTime.now().millisecondsSinceEpoch;

  /**
   * Returns a [bool],
   * true => cache is expired, needs to be replaced
   * false => cache is relevant/safe to use
   */
  isExpired() => invalidated || ((_timestamp+lifeDuration) < DateTime.now().millisecondsSinceEpoch);
}
