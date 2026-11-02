import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

/// Represents an online or market price offer for an agricultural product
class ProductOffer {
  final String id;
  final String sellerName;
  final String marathiSellerName;
  final double price;
  final String packSize;
  final bool inStock;
  final String stockStatusText;
  final String stockStatusTextMarathi;
  final String deliveryEstimate;
  final String deliveryEstimateMarathi;
  final String? offerUrl;
  final bool isOnline;
  final double rating;

  const ProductOffer({
    required this.id,
    required this.sellerName,
    this.marathiSellerName = '',
    required this.price,
    required this.packSize,
    this.inStock = true,
    this.stockStatusText = 'In Stock',
    this.stockStatusTextMarathi = 'उपलब्ध आहे',
    this.deliveryEstimate = '2-3 Business Days',
    this.deliveryEstimateMarathi = '२-३ दिवसांत डिलिव्हरी',
    this.offerUrl,
    this.isOnline = true,
    this.rating = 4.7,
  });

  String getLocalizedSellerName(AppLanguage lang) {
    if (lang == AppLanguage.marathi && marathiSellerName.isNotEmpty) {
      return marathiSellerName;
    }
    return sellerName;
  }

  String getLocalizedStockStatus(AppLanguage lang) {
    if (lang == AppLanguage.marathi && stockStatusTextMarathi.isNotEmpty) {
      return stockStatusTextMarathi;
    }
    return stockStatusText;
  }
}

/// Represents an agricultural product recommended for crop protection
class RecommendedProduct {
  final String id;
  final String diseaseId;
  final String name;
  final String marathiName;
  final String categoryTag;
  final String marathiCategoryTag;
  final String packSize;
  final double verifiedMrp;
  final String purpose;
  final String purposeMarathi;
  final String imageAsset;
  final String activeIngredient;
  final String cibrcRegistration;
  final String dosageSugarcane;
  final String dosageSugarcaneMarathi;
  final String applicationMethod;
  final String applicationMethodMarathi;
  final String safetyPrecautions;
  final String safetyPrecautionsMarathi;
  final Color categoryColor;
  final List<ProductOffer> onlineOffers;
  final List<ProductOffer> offlineOffers;

  const RecommendedProduct({
    required this.id,
    required this.diseaseId,
    required this.name,
    required this.marathiName,
    required this.categoryTag,
    required this.marathiCategoryTag,
    required this.packSize,
    required this.verifiedMrp,
    required this.purpose,
    required this.purposeMarathi,
    required this.imageAsset,
    required this.activeIngredient,
    this.cibrcRegistration = 'CIBRC Registered Class-III/Bio',
    required this.dosageSugarcane,
    required this.dosageSugarcaneMarathi,
    required this.applicationMethod,
    required this.applicationMethodMarathi,
    required this.safetyPrecautions,
    required this.safetyPrecautionsMarathi,
    this.categoryColor = const Color(0xFF1B5E20),
    this.onlineOffers = const [],
    this.offlineOffers = const [],
  });

  String getLocalizedName(AppLanguage lang) {
    if (lang == AppLanguage.marathi && marathiName.isNotEmpty) {
      return marathiName;
    }
    return name;
  }

  String getLocalizedCategory(AppLanguage lang) {
    if (lang == AppLanguage.marathi && marathiCategoryTag.isNotEmpty) {
      return marathiCategoryTag;
    }
    return categoryTag;
  }

  String getLocalizedPurpose(AppLanguage lang) {
    if (lang == AppLanguage.marathi && purposeMarathi.isNotEmpty) {
      return purposeMarathi;
    }
    return purpose;
  }

  String getLocalizedDosage(AppLanguage lang) {
    if (lang == AppLanguage.marathi && dosageSugarcaneMarathi.isNotEmpty) {
      return dosageSugarcaneMarathi;
    }
    return dosageSugarcane;
  }

  String getLocalizedApplication(AppLanguage lang) {
    if (lang == AppLanguage.marathi && applicationMethodMarathi.isNotEmpty) {
      return applicationMethodMarathi;
    }
    return applicationMethod;
  }

  String getLocalizedPrecautions(AppLanguage lang) {
    if (lang == AppLanguage.marathi && safetyPrecautionsMarathi.isNotEmpty) {
      return safetyPrecautionsMarathi;
    }
    return safetyPrecautions;
  }
}

/// Represents a local Krishi Seva Kendra / Agro shop
class KrishiKendra {
  final String id;
  final String name;
  final String marathiName;
  final bool isLicensed;
  final String licenseNumber;
  final String address;
  final String marathiAddress;
  final String region;
  final double distanceKm;
  final String phoneNumber;
  final String inStockSummary;
  final String inStockSummaryMarathi;
  final double latitude;
  final double longitude;
  final double rating;
  final String operatingHours;
  final String operatingHoursMarathi;

  const KrishiKendra({
    required this.id,
    required this.name,
    required this.marathiName,
    this.isLicensed = true,
    required this.licenseNumber,
    required this.address,
    required this.marathiAddress,
    required this.region,
    required this.distanceKm,
    required this.phoneNumber,
    required this.inStockSummary,
    required this.inStockSummaryMarathi,
    required this.latitude,
    required this.longitude,
    this.rating = 4.8,
    this.operatingHours = '8:00 AM - 8:30 PM',
    this.operatingHoursMarathi = 'सकाळी ८:०० ते रात्री ८:३०',
  });

  String getLocalizedName(AppLanguage lang) {
    if (lang == AppLanguage.marathi && marathiName.isNotEmpty) {
      return marathiName;
    }
    return name;
  }

  String getLocalizedAddress(AppLanguage lang) {
    if (lang == AppLanguage.marathi && marathiAddress.isNotEmpty) {
      return marathiAddress;
    }
    return address;
  }

  String getLocalizedInStock(AppLanguage lang) {
    if (lang == AppLanguage.marathi && inStockSummaryMarathi.isNotEmpty) {
      return inStockSummaryMarathi;
    }
    return inStockSummary;
  }
}

/// Action steps shown under "What should I do next?"
class DiseaseActionStep {
  final int stepNumber;
  final String title;
  final String titleMarathi;
  final String description;
  final String descriptionMarathi;

  const DiseaseActionStep({
    required this.stepNumber,
    required this.title,
    required this.titleMarathi,
    required this.description,
    required this.descriptionMarathi,
  });

  String getLocalizedTitle(AppLanguage lang) {
    if (lang == AppLanguage.marathi && titleMarathi.isNotEmpty) {
      return titleMarathi;
    }
    return title;
  }

  String getLocalizedDescription(AppLanguage lang) {
    if (lang == AppLanguage.marathi && descriptionMarathi.isNotEmpty) {
      return descriptionMarathi;
    }
    return description;
  }
}
