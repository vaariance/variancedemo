import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:variance_dart/interfaces.dart';
import 'package:variance_dart/utils.dart';
import 'package:variance_dart/variance.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as w3d;
import 'package:web3dart/crypto.dart' as w3d;

///
class WalletProvider extends ChangeNotifier {
  final Chain _chain;

  PassKeyPair? _keyPair;

  late SmartWallet _wallet;

  SmartWallet get wallet => _wallet;

  WalletProvider()
      : _chain = Chain(
            chainId: 31337,
            explorer: "http//localhost:8545",
            entrypoint: w3d.EthereumAddress.fromHex(
                "0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789"),
            accountFactory: w3d.EthereumAddress.fromHex(
                '0x218d850562cec77dd5DEC87b7FEE18824bC0f93C'))
          ..bundlerUrl = "https://ad7a-105-112-117-191.ngrok-free.app/rpc"
          ..ethRpcUrl = "https://ccf0-105-112-117-191.ngrok-free.app";

  void _createWalletWithSigner(MultiSignerInterface signer) {
    _wallet = SmartWallet(
        chain: _chain,
        signer: signer,
        bundler: BundlerProvider(_chain, RPCProvider(_chain.bundlerUrl!)));
  }

  Future registerWithPassKey(String name,
      {bool? requiresUserVerification}) async {
    final signer =
        PassKeySigner("webauthn.io", "webauthn", "https://webauthn.io");
    _createWalletWithSigner(signer);
    _keyPair = await signer.register(name, requiresUserVerification!);

    try {
      final salt = Uint256.fromHex(
          hexlify(w3d.keccak256(Uint8List.fromList(utf8.encode(name)))));
      await _wallet.createSimplePasskeyAccount(_keyPair!, salt);
      log("wallet created ${_wallet.address?.hex} ");
    } catch (e) {
      log("something happened: $e");
    }
  }

  Future registerWithHDWallet() async {
    final signer = HDWalletSigner.createWallet();
    _createWalletWithSigner(signer);
    try {
      final salt = Uint256.fromHex(hexlify(w3d.keccak256(
          Uint8List.fromList(utf8.encode(signer.zerothAddress.hexNo0x)))));
      await _wallet.createSimpleAccount(salt, index: 0);
      log("wallet created ${_wallet.address?.hex} ");
    } catch (e) {
      log("something happened: $e");
    }
  }

  Future<void> sendTransaction(String recipient, String amount) async {
    final amtToDb = double.parse(amount);
    final dbToWei = BigInt.from(amtToDb * math.pow(10, 18));
    final etherAmount = w3d.EtherAmount.fromBigInt(w3d.EtherUnit.wei, dbToWei);
    await wallet.send(EthereumAddress.fromHex(recipient), etherAmount);
  }
}
