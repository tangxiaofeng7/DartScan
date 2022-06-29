import 'dart:io';
import 'package:args/args.dart';

const portFlagName = 'port';
void main(List<String> args) {
  var parser = new ArgParser()
    ..addOption(portFlagName, abbr: 'p', defaultsTo: '1-65535');
  ArgResults results = parser.parse(args);
  if (args.isEmpty) {
    print('Usage: dart main.dart 127.0.0.1 -p <port>');
    return;
  }

  String ipRangeArg = results.rest.isEmpty ? '127.0.0.1' : results.rest[0];

  List portRanges = getPortRangesFromArg(results['port']);

  print('Scanning $ipRangeArg');

  Scanner scanner = new Scanner();

  scanner.scan(ipRangeArg, portRanges);
}

List getPortRangesFromArg(String portArg) {
  var rangeStrings = portArg.split(',');

  List rangeTuples = [];
  for (String range in rangeStrings) {
    var split = range.split('-').map((p) => int.parse(p)).toList();

    if (split.length > 1) {
      rangeTuples.add(split);
    } else {
      rangeTuples.add([split[0], split[0]]);
    }
  }
  return rangeTuples;
}

class Scanner {
  void scan(String host, List<dynamic> portRanges) {
    for (var portRange in portRanges) {
      for (int port = portRange[0]; port <= portRange[1]; port++) {
        (_scanPort(host, port));
      }
    }
  }

  void _scanPort(String host, int port) async {
    final socket = Socket.connect(host, port).then((socket) {
      print('$host:$port is open');
      socket.destroy();
    }).catchError((e) {});
  }
}
