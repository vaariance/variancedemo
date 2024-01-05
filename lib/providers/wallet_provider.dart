import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:variance_dart/utils.dart';
import 'package:variance_dart/variance.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as w3d;

///
class WalletProvider extends ChangeNotifier {
  PassKeySigner? _passKey;
  late SmartWallet _wallet;
  PassKeyPair? _keyPair;
  late RPCProvider _provider;
  late Uint256 _salt;
  final Chain _chain = Chain(
      chainId: 1337,
      explorer: "http//localhost:8545",
      entrypoint: w3d.EthereumAddress.fromHex(
          "0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789"),
      accountFactory: w3d.EthereumAddress.fromHex(
          '0x690832791538Ff4DD15407817B0DAc54456631bc'))
    ..bundlerUrl = "https://1f88-41-190-3-151.ngrok-free.app/rpc"
    ..ethRpcUrl = "https://74ea-41-190-3-151.ngrok-free.app";

  PassKeySigner? get passKey => _passKey;
  Chain get chain => _chain;
  SmartWallet get wallet => _wallet;
  PassKeyPair? get keyPair => _keyPair;
  Uint256 get salt => _salt;
  RPCProvider get rpcProvider => _provider;

  WalletProvider() {
    _passKey = PassKeySigner("webauthn.io", "webauthn", "https://webauthn.io");
    _provider = RPCProvider(chain.bundlerUrl!);
    _wallet = SmartWallet.init(
        chain: chain,
        signer: _passKey!,
        bundler: BundlerProvider(chain, RPCProvider(chain.bundlerUrl!)));
  }

  Future registerWithPassKey(String name,
      {bool? requiresUserVerification}) async {
    _keyPair = await _passKey!.register(name, requiresUserVerification!);

    try {
      _salt = Uint256.fromHex(hexlify(utf8.encode(name)));
      await _wallet.createSimplePasskeyAccount(_keyPair!, _salt);
      log("wallet created ${_wallet.address?.hex} ");
    } catch (e) {
      log("something happened: $e");
    }
  }

  Future sendTransaction(String recipient, String amount) async {
    final amtToDb = double.parse(amount);
    final dbToWei = BigInt.from(amtToDb * math.pow(10, 18));

    await wallet.send(EthereumAddress.fromHex(recipient),
        w3d.EtherAmount.fromBigInt(w3d.EtherUnit.wei, dbToWei));
  }
}
