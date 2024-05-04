import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:variancedemo/providers/constants.dart';
import 'package:web3_signers/web3_signers.dart';
import 'package:variance_dart/variance_dart.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as w3d;

// nft token contract address
final EthereumAddress nft =
    EthereumAddress.fromHex("0x4B509a7e891Dc8fd45491811d67a8B9e7ef547B9");

// erc20 token contract address
final EthereumAddress erc20 =
    EthereumAddress.fromHex("0xAEaF19097D8a8da728438D6B57edd9Bc5DAc4795");

// address that deployed the token contracts
final EthereumAddress deployer =
    EthereumAddress.fromHex("0x218F6Bbc32Ef28F547A67c70AbCF8c2ea3b468BA");

// bundler/paymaster rpc url
const String pimlicoUrl =
    "https://api.pimlico.io/v2/11155111/rpc?apikey=$apikey";

class WalletProvider extends ChangeNotifier {
  final Chain _chain; // chain configurations

  SmartWallet? wallet;

  WalletProvider()
      : _chain = Chains.getChain(Network.sepolia)
          ..accountFactory = Constants
              .simpleAccountFactoryAddressv06 // sets the factory for safe accounts
          ..bundlerUrl = pimlicoUrl
          ..paymasterUrl = pimlicoUrl;

  Future<void> createSmartWallet() async {
    // creates an EOA wallet as a signer.
    final signer = EOAWallet.createWallet();

    // creates a smart wallet factory using the eoa as a signer and the specified chain configurations
    final SmartWalletFactory walletFactory = SmartWalletFactory(_chain, signer);

    // a salt for deterministic deployment
    final salt = Uint256.zero;

    // creates a determinsitic simple smart wallet
    wallet = await walletFactory.createSimpleAccount(salt);
    log("safe wallet created ${wallet?.address.hex} ");
  }

  Future<void> mintNFt() async {
    // creates an encoded mint calldata
    final mintCallData = Contract.encodeFunctionCall("safeMint", nft,
        ContractAbis.get("ERC721_SafeMint"), [wallet?.address]);
    // sents a  mint transaction to the wallet
    final mintTx = await wallet?.sendTransaction(nft, mintCallData);
    // waits for transaction to be finalized
    final receipt = await mintTx?.wait();
    log("Transaction receipt Hash: ${receipt?.userOpHash}");
  }

  Future<void> sendBatchedTransaction() async {
    // creates an encoded mint calldata for erc20 token
    final erc20MintCalldata = Contract.encodeFunctionCall(
        "mint", erc20, ContractAbis.get("ERC20_Mint"), [
      wallet?.address,
      w3d.EtherAmount.fromInt(w3d.EtherUnit.ether, 20).getInWei
    ]);

    // creates an encoded transfer calldata for erc20 token
    final erc20TransferCalldata = Contract.encodeERC20TransferCall(
        erc20, deployer, w3d.EtherAmount.fromInt(w3d.EtherUnit.ether, 20));

    // sends a batch transaction to the wallet
    final tx = await wallet?.sendBatchedTransaction(
        [erc20, erc20], [erc20MintCalldata, erc20TransferCalldata]);

    // waits for transaction to be finalized
    final receipt = await tx?.wait();
    log("Transaction receipt Hash: ${receipt?.userOpHash}");
  }

  Future<void> sendEther(String recipient, String amount) async {
    // gets the amount to send in wei
    final etherAmount = w3d.EtherAmount.fromBigInt(w3d.EtherUnit.wei,
        BigInt.from(double.parse(amount) * math.pow(10, 18)));

    // sends the transaction
    final response =
        await wallet?.send(EthereumAddress.fromHex(recipient), etherAmount);
    final receipt = await response?.wait();

    log("Transaction receipt Hash: ${receipt?.userOpHash}");
  }
}
