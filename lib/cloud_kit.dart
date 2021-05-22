import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CloudKit {
  static const MethodChannel _channel =
      const MethodChannel('cloud_kit');

  String _containerId;

  CloudKit(String containerIdentifier) {
    _containerId = containerIdentifier;
  }

  /// Save a new entry to CloudKit using a key and value.
  /// The key need to be unique.
  Future<bool> save(String key, String value) async {
    if (!Platform.isIOS) {
      return false;
    }

    if (key == null || value == null || key.length == 0 || value.length == 0) {
      throw new FlutterError("Key or value not given but required");
    }

    bool status = await _channel.invokeMethod(
        'save',
        {
          "key": key,
          "value": value,
          "containerId": _containerId
        }
    );

    return status;
  }

  /// Loads a value from CloudKit by key.
  Future<String> get(String key) async {
    if (!Platform.isIOS) {
      return null;
    }

    if (key == null || key.length == 0) {
      throw new FlutterError("Key not given but required");
    }

    List<dynamic> records = await _channel.invokeMethod(
        'get',
        {
          "key": key,
          "containerId": _containerId
        }
    );

    if (records.length != 0) {
      return records[0];
    } else {
      return null;
    }
  }

  /// Delete a entry from CloudKit using the key.
  Future<void> delete(String key) async {
    if (!Platform.isIOS) {
      return;
    }

    if (key == null || key.length == 0) {
      throw new FlutterError("Key not given but required");
    }

    await _channel.invokeMethod(
        'delete',
        {
          "key": key,
          "containerId": _containerId
        }
    );
  }

  /// Deletes the entire user database.
  Future<void> clearDatabase() async {
    if (!Platform.isIOS) {
      return;
    }

    await _channel.invokeMethod(
        'deleteAll',
        {
          "containerId": _containerId
        }
    );
  }
}
