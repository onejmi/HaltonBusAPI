# HaltonBusAPI [![Build Status](https://travis-ci.org/scarger/HaltonBusAPI.svg?branch=master)](https://travis-ci.org/scarger/HaltonBusAPI)

A Dart library created as an easy way to interface with [halton busses][bus-site].

This API is by no means official, and is not endorsed by Halton Buses and/or
Halton District School Board.

Also, please aknowledge the fact that this README is
based off of a template made available by Stagehand
under a BSD-style [license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).


## Usage

HaltonBusAPI is quite simple to use, and is capable of interfacing with
Halton busses to suit your needs.

Adding to pub:
```yaml
dependencies:
  HaltonBusAPI:
    git: 
      url: https://github.com/scarger/HaltonBusAPI.git
```


Initialization:
```dart
import 'package:HaltonBusAPI/HaltonBusAPI.dart';

    main() {
      //define singleton instance of BusAPI
      var api = new BusAPI();
      //invoke api methods
      api...
    }
```
Examples can be found [here][examples].

## Documentation
Please refer to [this][docs] dart docs for more depth on the api
and its methods.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/scarger/HaltonBusAPI/issues/
[examples]: https://github.com/scarger/HaltonBusAPI/tree/master/example/
[bus-site]: https://haltonbus.ca/
[docs]: https://scarger.github.io/hbapi/