import 'package:flutter/material.dart';

mixin SettingsViewMixin<T extends StatefulWidget> on State<T> {
  final Map<String, String> topics = {
    "bildirimleri_goster": "Bildirimleri Göster",
    "uygulama_bildirimleri": "Uygulama Bildirimleri",
    "duyurular": "Duyurular",
    "portfoy_bildirimleri": "Portföy Bildirimleri",
    "haber_bildirimleri": "Haber Bildirimleri",
    "model_portfoy": "Model Portföy",
    "arastirma_raporlari": "Araştırma Raporları",
    "teknik_oneriler": "Teknik Öneriler",
    "fiyat_bildirimleri": "Fiyat Bildirimleri",
    "emir_bildirimleri": "Emir Bildirimleri",
    "bilanco_bildirimleri": "Bilanço Bildirimleri",
  };
}
