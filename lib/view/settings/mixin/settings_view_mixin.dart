import 'package:flutter/material.dart';

mixin SettingsViewMixin<T extends StatefulWidget> on State<T> {
  final Map<String, String> topics = {
    "main": "Bildirimleri Göster",
    "app": "Uygulama Bildirimleri",
    "announcements": "Duyurular",
    "invest": "Portföy Bildirimleri",
    "news": "Haber Bildirimleri",
    "portfoy": "Model Portföy",
    "research": "Araştırma Raporları",
    "technicalSuggestions": "Teknik Öneriler",
    "price": "Fiyat Bildirimleri",
    "order": "Emir Bildirimleri",
    "balance_sheet": "Bilanço Bildirimleri",
  };
}
