import 'dart:convert';

class Vpn {
  final int? id;
  final int? serverId;
  final String? userId;
  final String? deviceId;
  final ResponseData? responseData;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Server? server;
  final KeyPair? serverKeys;
  final KeyPair? peerKeys;
  final int? port;

  Vpn({
    this.id,
    this.serverId,
    this.userId,
    this.deviceId,
    this.responseData,
    this.createdAt,
    this.updatedAt,
    this.server,
    this.serverKeys,
    this.peerKeys,
    this.port,
  });

  factory Vpn.fromJson(Map<String, dynamic> json) {
    return Vpn(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      serverId: json['server_id'] != null
          ? int.tryParse(json['server_id'].toString())
          : null,
      userId: json['user_id'].toString(),
      deviceId: json['device_id'],
      responseData:
          json['response_data'] != null && json['server']?['server_ip'] != null
              ? ResponseData.fromJson(
                  jsonDecode(json['response_data']),
                  json['server']['server_ip'],
                  json['server_keys'] == null
                      ? ""
                      : jsonDecode(json['server_keys'])['publicKey'],
                )
              : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      server: json['server'] != null ? Server.fromJson(json['server']) : null,
      serverKeys: json['server_keys'] != null
          ? KeyPair.fromJson(jsonDecode(json['server_keys']))
          : null,
      peerKeys: json['peer_keys'] != null
          ? KeyPair.fromJson(jsonDecode(json['peer_keys']))
          : null,
      port: json['port'] != null ? int.tryParse(json['port'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'server_id': serverId,
      'user_id': userId,
      'device_id': deviceId,
      'response_data':
          responseData != null ? jsonEncode(responseData!.toJson()) : null,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'server': server?.toJson(),
      'server_keys':
          serverKeys != null ? jsonEncode(serverKeys!.toJson()) : null,
      'peer_keys': peerKeys != null ? jsonEncode(peerKeys!.toJson()) : null,
      'port': port,
    };
  }
}

class ResponseData {
  final bool? success;
  final String? msg;
  final Obj? obj;

  ResponseData({this.success, this.msg, this.obj});

  factory ResponseData.fromJson(
    Map<String, dynamic> json,
    String endpoStringIp,
    String serverPublicKey,
  ) {
    return ResponseData(
      success: json['success'],
      msg: json['msg'],
      obj: json['obj'] != null
          ? Obj.fromJson(json['obj'], endpoStringIp, serverPublicKey)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'msg': msg, 'obj': obj?.toJson()};
  }
}

class Obj {
  final int? id;
  final int? up;
  final int? down;
  final int? total;
  final String? remark;
  final bool? enable;
  final int? expiryTime;
  final dynamic clientStats;
  final String? listen;
  final int? port;
  final String? protocol;
  final Settings? settings;
  final String? streamSettings;
  final String? tag;
  final Sniffing? sniffing;
  final Allocate? allocate;
  final String? wireguardConfig;

  Obj({
    this.id,
    this.up,
    this.down,
    this.total,
    this.remark,
    this.enable,
    this.expiryTime,
    this.clientStats,
    this.listen,
    this.port,
    this.protocol,
    this.settings,
    this.streamSettings,
    this.tag,
    this.sniffing,
    this.allocate,
    this.wireguardConfig,
  });

  factory Obj.fromJson(
    Map<String, dynamic> json,
    String endpoStringIp,
    String serverPublicKey,
  ) {
    final settingsJson = json['settings'] is String
        ? jsonDecode(json['settings'])
        : json['settings'];
    final sniffingJson = json['sniffing'] is String
        ? jsonDecode(json['sniffing'])
        : json['sniffing'];
    final allocateJson = json['allocate'] is String
        ? jsonDecode(json['allocate'])
        : json['allocate'];

    final settings =
        settingsJson != null ? Settings.fromJson(settingsJson) : null;
    final peer =
        settings?.peers?.isNotEmpty == true ? settings?.peers?.first : null;
    final address =
        peer?.allowedIPs?.isNotEmpty == true ? peer?.allowedIPs?.first : null;
    final port = json['port'];

    final wireguardConfig = (peer != null &&
            address != null &&
            port != null &&
            serverPublicKey != null)
        ? '''
    [Interface]
    PrivateKey = ${peer.privateKey}
    Address = $address
    MTU = ${settings?.mtu}
    DNS = 1.1.1.1, 1.0.0.1

    [Peer]
    PublicKey = $serverPublicKey
    AllowedIPs = 0.0.0.0/0, ::/0
    Endpoint = $endpoStringIp:$port
    PersistentKeepalive = ${peer.keepAlive}
    '''
            .trim()
        : null;

    return Obj(
      id: json['id'],
      up: json['up'],
      down: json['down'],
      total: json['total'],
      remark: json['remark'],
      enable: json['enable'],
      expiryTime: json['expiryTime'],
      clientStats: json['clientStats'],
      listen: json['listen'],
      port: port,
      protocol: json['protocol'],
      settings: settings,
      streamSettings: json['streamSettings'],
      tag: json['tag'],
      sniffing: sniffingJson != null ? Sniffing.fromJson(sniffingJson) : null,
      allocate: allocateJson != null ? Allocate.fromJson(allocateJson) : null,
      wireguardConfig: wireguardConfig,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'up': up,
      'down': down,
      'total': total,
      'remark': remark,
      'enable': enable,
      'expiryTime': expiryTime,
      'clientStats': clientStats,
      'listen': listen,
      'port': port,
      'protocol': protocol,
      'settings': settings?.toJson(),
      'streamSettings': streamSettings,
      'tag': tag,
      'sniffing': sniffing?.toJson(),
      'allocate': allocate?.toJson(),
      'wireguardConfig': wireguardConfig,
    };
  }
}

class Settings {
  final int? mtu;
  final String? secretKey;
  final List<Peer>? peers;
  final bool? noKernelTun;

  Settings({this.mtu, this.secretKey, this.peers, this.noKernelTun});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      mtu: json['mtu'],
      secretKey: json['secretKey'],
      peers: json['peers'] != null
          ? List<Peer>.from(json['peers'].map((x) => Peer.fromJson(x)))
          : null,
      noKernelTun: json['noKernelTun'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mtu': mtu,
      'secretKey': secretKey,
      'peers': peers?.map((x) => x.toJson()).toList(),
      'noKernelTun': noKernelTun,
    };
  }
}

class Peer {
  final String? privateKey;
  final String? publicKey;
  final List<String>? allowedIPs;
  final int? keepAlive;

  Peer({this.privateKey, this.publicKey, this.allowedIPs, this.keepAlive});

  factory Peer.fromJson(Map<String, dynamic> json) {
    return Peer(
      privateKey: json['privateKey'],
      publicKey: json['publicKey'],
      allowedIPs: json['allowedIPs'] != null
          ? List<String>.from(json['allowedIPs'])
          : null,
      keepAlive: json['keepAlive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'privateKey': privateKey,
      'publicKey': publicKey,
      'allowedIPs': allowedIPs,
      'keepAlive': keepAlive,
    };
  }
}

class Sniffing {
  final bool? enabled;
  final List<String>? destOverride;
  final bool? metadataOnly;
  final bool? routeOnly;

  Sniffing({
    this.enabled,
    this.destOverride,
    this.metadataOnly,
    this.routeOnly,
  });

  factory Sniffing.fromJson(Map<String, dynamic> json) {
    return Sniffing(
      enabled: json['enabled'],
      destOverride: json['destOverride'] != null
          ? List<String>.from(json['destOverride'])
          : null,
      metadataOnly: json['metadataOnly'],
      routeOnly: json['routeOnly'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'destOverride': destOverride,
      'metadataOnly': metadataOnly,
      'routeOnly': routeOnly,
    };
  }
}

class Allocate {
  final String? strategy;
  final int? refresh;
  final int? concurrency;

  Allocate({this.strategy, this.refresh, this.concurrency});

  factory Allocate.fromJson(Map<String, dynamic> json) {
    return Allocate(
      strategy: json['strategy'],
      refresh: json['refresh'],
      concurrency: json['concurrency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strategy': strategy,
      'refresh': refresh,
      'concurrency': concurrency,
    };
  }
}

class Server {
  final int? id;
  final String? countryCode;
  final String? countryName;
  final String? serverType;
  final String? serverIp;
  final bool? provideTo;

  Server({
    this.id,
    this.countryCode,
    this.countryName,
    this.serverType,
    this.serverIp,
    this.provideTo,
  });

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
      id: json['id'],
      countryCode: json['country_code'],
      countryName: json['country_name'],
      serverType: json['server_type'],
      serverIp: json['server_ip'],
      provideTo: json['provide_to'] == "Pro User",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_code': countryCode,
      'country_name': countryName,
      'server_type': serverType,
      'server_ip': serverIp,
      'provide_to': provideTo,
    };
  }
}

class KeyPair {
  final String? privateKey;
  final String? publicKey;

  KeyPair({this.privateKey, this.publicKey});

  factory KeyPair.fromJson(Map<String, dynamic> json) {
    return KeyPair(
      privateKey: json['privateKey'],
      publicKey: json['publicKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'privateKey': privateKey, 'publicKey': publicKey};
  }
}
