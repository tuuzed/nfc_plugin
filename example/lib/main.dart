import 'package:flutter/material.dart';
import 'package:nfc_plugin/nfc_plugin.dart';

void main() => runApp(App());

void log(String msg) => debugPrint(msg);

class App extends StatelessWidget {
  App() {
    NfcPlugin.onTagDiscovered().listen((onData) async {
      log("onTagDiscovered: type= ${onData.type}");
      log("onTagDiscovered: success= ${onData.success}");
      log("onTagDiscovered: hexId= ${onData.hexId}");
      log("onTagDiscovered: techList= ${onData.techList}");
      if (onData.dataList != null) {
        onData.dataList.forEach((it) => log(
            "onTagDiscovered: dataList] sector=${it.sector},block=${it.block},hexData=${it.hexData}"));
      }
      if (onData.success) {
        switch (onData.type) {
          case TagResultType.none:
            break;
          case TagResultType.foundTag:
            break;
          case TagResultType.readTag:
            await NfcPlugin.cancel();
            break;
          case TagResultType.writeTag:
            await NfcPlugin.cancel();
            break;
        }
      }
    });
  }

  void _enable() async {
    var flags = NfcPlugin.FLAG_READER_NFC_A |
        NfcPlugin.FLAG_READER_NFC_B |
        NfcPlugin.FLAG_READER_NFC_V |
        NfcPlugin.FLAG_READER_NFC_F |
        NfcPlugin.FLAG_READER_NFC_BARCODE;
    var rst = await NfcPlugin.enableReaderMode(flags: flags);
    log("_enable: rst=$rst");
  }

  void _disable() async {
    var rst = await NfcPlugin.disableReaderMode();
    log("_disable: rst=$rst");
  }

  void _readTag() async {
    var args = <ReadTagArg>[];
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 4; j++) {
        args.add(ReadTagArg(sector: i, block: j));
      }
    }
    var rst = await NfcPlugin.readTag(args: args);
    log("_readTag: rst=$rst");
  }

  void _writeTag() async {
    var rst = await NfcPlugin.writeTag(args: [
      WriteTagArg(
          sector: 1, block: 0, hexData: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"),
      WriteTagArg(
          sector: 1, block: 1, hexData: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"),
      WriteTagArg(
          sector: 1, block: 2, hexData: "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"),
    ]);
    log("_writeTag: rst=$rst");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NFC Plugin app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Enable"),
                onPressed: () => _enable(),
              ),
              RaisedButton(
                child: Text("Disable"),
                onPressed: () => _disable(),
              ),
              RaisedButton(
                child: Text("ReadTag"),
                onPressed: () => _readTag(),
              ),
              RaisedButton(
                child: Text("WriteTag"),
                onPressed: () => _writeTag(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
