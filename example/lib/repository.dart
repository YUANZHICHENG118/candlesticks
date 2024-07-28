import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceRepository {
  Future<List<Candle>> fetchCandles(
      {required String symbol, required String interval, int? endTime}) async {
    final uri = Uri.parse(
        "https://api.moogarden.io/api/market/v2/history?symbol=BTC%2FUSDT&resolution=15&size=2000&from=1720662017000&to=1721958017000");
    print("url===${uri}");
    final res = await http.get(uri);
    print("res===${(jsonDecode(res.body) as List<dynamic>).length}");

     var list = <Candle>[];
    // res.body.forEach((item) {
    //   list.add(KLineEntity.fromCustom(
    //       open: double.parse(item[1].toString()),
    //       close: double.parse(item[4].toString()),
    //       time: item[0],
    //       high: double.parse(item[2].toString()),
    //       low: double.parse(item[3].toString()),
    //       vol: double.parse(item[5].toString())));
    // });
    (jsonDecode(res.body) as List<dynamic>)
        .forEach((e){
          print("e===${e}");
          try{
            list.add(Candle.fromJson(e));
          }catch(err){
            print("error===${err}");

          }
    });
    // List<Candle> list=(jsonDecode(res.body) as List<dynamic>)
    //     .map((e) => Candle.fromJson(e))
    //     .toList();
     print("list===${list.length}");

    return list.reversed.toList();
  }

  Future<List<String>> fetchSymbols() async {
    final uri = Uri.parse("https://api.binance.com/api/v3/ticker/price");
    final res = await http.get(uri);
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => e["symbol"] as String)
        .toList();
  }

  WebSocketChannel establishConnection(String symbol, String interval) {
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/ws'),
    );
    channel.sink.add(
      jsonEncode(
        {
          "method": "SUBSCRIBE",
          "params": [symbol + "@kline_" + interval],
          "id": 1
        },
      ),
    );
    return channel;
  }
}
