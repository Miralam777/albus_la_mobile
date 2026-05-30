import 'package:albus_la_mobile/constants/icons.dart';
import 'package:flutter/material.dart';

class ViewIdsHelper {
  ViewIdsHelper._();

  static const List<String> viewIds = [
    'orders',
    'licenses',
    'genQrcodes',
    'products',
    'settings',
  ];

  static final List<ViewModel> viewsData = [
    ViewModel(
      selected: false,
      id: viewIds[0],
      name: 'Bestellungen',
      icon: I.cubeBox,
    ),
    ViewModel(
      selected: false,
      id: viewIds[1],
      name: 'Lizenzen',
      icon: I.license,
    ),
    ViewModel(
      selected: false,
      id: viewIds[2],
      name: 'Product-Qr-Codes',
      icon: I.qrCode,
    ),
    ViewModel(
      selected: false,
      id: viewIds[3],
      name: 'Produkte',
      icon: I.category,
    ),
    ViewModel(
      selected: false,
      id: viewIds[4],
      name: 'Einstellungen',
      icon: I.settings,
    ),
  ];

  static ViewModel? getViewFromId(String id) {
    for (var viewData in viewsData) {
      if (viewData.id == id) {
        return viewData;
      }
    }

    return null;
  }
}

class ViewModel {
  final bool selected;
  final String id;
  final String name;
  final IconData icon;

  const ViewModel({
    required this.selected,
    required this.id,
    required this.name,
    required this.icon,
  });

  factory ViewModel.fromMap(Map<String, dynamic> data) => ViewModel(
    selected: data['selected'] ?? false,
    id: data['id'] ?? '',
    name: data['name'] ?? '',
    icon: data['icon'] ?? '',
  );

  ViewModel copyWith({
    bool? selected,
    String? id,
    String? name,
    IconData? icon,
  }) {
    return ViewModel(
      selected: selected ?? this.selected,
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }
}
