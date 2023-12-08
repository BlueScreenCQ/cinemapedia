// To parse this JSON data, do
//
//     final watchProvidersResponse = watchProvidersResponseFromJson(jsonString);

import 'dart:convert';

WatchProvidersResponse watchProvidersResponseFromJson(String str) => WatchProvidersResponse.fromJson(json.decode(str));

String watchProvidersResponseToJson(WatchProvidersResponse data) => json.encode(data.toJson());

class WatchProvidersResponse {
  // int id;
  // List<WatchProviderInfo> rent;
  // List<WatchProviderInfo> buy;
  List<WatchProviderInfo> flatrate;

  WatchProvidersResponse({
    // required this.id,
    // required this.rent,
    // required this.buy,
    required this.flatrate,
  });

  factory WatchProvidersResponse.fromJson(Map<String, dynamic> json) => WatchProvidersResponse(
        // id: int.parse(json["link"]),
        // rent: List<WatchProviderInfo>.from(json["rent"].map((x) => WatchProviderInfo.fromJson(x))),
        // buy: List<WatchProviderInfo>.from(json["buy"].map((x) => WatchProviderInfo.fromJson(x))),
        flatrate: List<WatchProviderInfo>.from(json["flatrate"].map((x) => WatchProviderInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        // "rent": List<dynamic>.from(rent.map((x) => x.toJson())),
        // "buy": List<dynamic>.from(buy.map((x) => x.toJson())),
        "flatrate": List<dynamic>.from(flatrate.map((x) => x.toJson())),
      };
}

class WatchProviderInfo {
  String logoPath;
  int providerId;
  String providerName;
  int displayPriority;

  WatchProviderInfo({
    required this.logoPath,
    required this.providerId,
    required this.providerName,
    required this.displayPriority,
  });

  factory WatchProviderInfo.fromJson(Map<String, dynamic> json) => WatchProviderInfo(
        logoPath: json["logo_path"],
        providerId: json["provider_id"],
        providerName: json["provider_name"],
        displayPriority: json["display_priority"],
      );

  Map<String, dynamic> toJson() => {
        "logo_path": logoPath,
        "provider_id": providerId,
        "provider_name": providerName,
        "display_priority": displayPriority,
      };
}
