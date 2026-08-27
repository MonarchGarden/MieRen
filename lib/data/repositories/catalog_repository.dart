import 'package:flutter/material.dart';
import '../models/product_variant.dart';

class CompanyInfo {
  final String name;
  final String tagline;
  final String aboutText;
  final String contactPerson;
  final String whatsappNumber;
  final String formattedPhone;
  final String email;
  final List<String> advantages;
  final String shelfLife;
  final String weightStandard;
  final String pricingPolicy;
  final String pirtStatus;
  final String halalStatus;

  const CompanyInfo({
    required this.name,
    required this.tagline,
    required this.aboutText,
    required this.contactPerson,
    required this.whatsappNumber,
    required this.formattedPhone,
    required this.email,
    required this.advantages,
    required this.shelfLife,
    required this.weightStandard,
    required this.pricingPolicy,
    required this.pirtStatus,
    required this.halalStatus,
  });
}

class CatalogRepository {
  static const CompanyInfo companyInfo = CompanyInfo(
    name: 'MieRen',
    tagline: 'Produsen Mie Kering Berbahan Sayuran Segar Alami',
    aboutText:
        'Kami adalah produsen mie kering berbahan sayuran segar alami yang berfokus pada kualitas premium, konsistensi produksi, dan hadir untuk memberikan opsi alternatif kepada restoran untuk menyajikan hidangan karbohidrat (mie) namun dengan berbahan sayuran.',
    contactPerson: 'Irene',
    whatsappNumber: '628212633288',
    formattedPhone: '+62-8212-633-288',
    email: 'pinawatywijaya@gmail.com',
    advantages: [
      '100% bahan alami, tanpa pewarna, pengawet, dan air abu',
      'Shelf life ±3 bulan (dry product)',
      'Tampilan produk menarik dengan bentuk unik & premium',
    ],
    shelfLife: '±3 Bulan (Dry Product)',
    weightStandard: '38 gram / pc (Bisa Custom)',
    pricingPolicy: 'Fleksibel sesuai volume kuantitas pembelian (Grosir & Restoran)',
    pirtStatus: 'P-IRT: 2053671091478-31',
    halalStatus: 'Sedang dalam proses sertifikasi Halal',
  );

  static final List<ProductVariant> products = [
    const ProductVariant(
      id: 'mie_putih',
      name: 'Mie Putih',
      category: ProductCategory.standard,
      badgeText: 'Standar Premium',
      shortDescription:
          'Mie kering tekstur kenyal alami berbahan dasar tepung pilihan tanpa air abu.',
      description:
          'Mie Putih MieRen diformulasikan khusus untuk kebutuhan restoran dan katering yang menginginkan mie original berkualitas tinggi. Tanpa tambahan air abu dan pengawet, menjadikannya pilihan sehat dan aman dikonsumsi harian.',
      imageAsset: 'assets/images/original.jpg',
      colorHex: '#8D6E63',
      primaryColor: Color(0xFF8D6E63),
      ingredients: ['Tepung Terigu Berprotein High-Quality', 'Air Murni', 'Garam Alami'],
      highlights: [
        'Tekstur kenyal lembut alami',
        'Tanpa air abu (bebas pengawet buatan)',
        'Sangat cocok untuk mie goreng, mie kuah, maupun ramen',
      ],
      isPopular: true,
    ),
    const ProductVariant(
      id: 'mie_caisim',
      name: 'Mie Sayur Caisim',
      category: ProductCategory.sayur,
      badgeText: 'Best Seller',
      shortDescription:
          'Mie kering sehat dengan warna hijau segar dari olahan caisim (sawi hijau) alami.',
      description:
          'Mie Sayur Caisim menghadirkan kesegaran sayur sawi hijau pilihan dalam setiap untaian mie. Menggunakan 100% serat caisim segar tanpa pewarna sintetis, memberikan daya tarik visual yang tinggi bagi sajian restoran Anda.',
      imageAsset: 'assets/images/caisim.jpg',
      colorHex: '#2E7D32',
      primaryColor: Color(0xFF2E7D32),
      ingredients: [
        'Tepung Terigu Pilihan',
        'Ekstrak Caisim Segar Alami (Sawi Hijau)',
        'Air Murni',
        'Garam Alami'
      ],
      highlights: [
        'Warna hijau 100% alami dari Caisim',
        'Kaya akan serat dan vitamin alami',
        'Mempercantik plating hidangan mie',
      ],
      isPopular: true,
    ),
    const ProductVariant(
      id: 'mie_wortel',
      name: 'Mie Sayur Wortel',
      category: ProductCategory.sayur,
      badgeText: 'Favorit Sehat',
      shortDescription:
          'Mie kering dengan warna oranye cerah bernutrisi dari ekstrak wortel segar.',
      description:
          'Dibuat dengan memadukan tepung terigu berkualitas dan ekstrak wortel segar murni. Mie Sayur Wortel MieRen memberikan rona oranye hangat yang memikat dan kaya akan kebaikan Beta-Karoten.',
      imageAsset: 'assets/images/wortel.jpg',
      colorHex: '#E65100',
      primaryColor: Color(0xFFE65100),
      ingredients: [
        'Tepung Terigu Pilihan',
        'Ekstrak Wortel Segar Alami',
        'Air Murni',
        'Garam Alami'
      ],
      highlights: [
        'Warna oranye cerah alami',
        'Mengandung Beta-Karoten & Antioksidan',
        'Sangat disukai anak-anak dan keluarga',
      ],
      isPopular: false,
    ),
    const ProductVariant(
      id: 'mie_naga',
      name: 'Mie Buah Naga',
      category: ProductCategory.buah,
      badgeText: 'Eksotis & Unik',
      shortDescription:
          'Mie kering eksotis berwarna pink magenta anggun dari ekstrak buah naga merah.',
      description:
          'Mie Buah Naga menghadirkan sentuhan mewah dan unik pada menu restoran. Warna pink anggun terpancar secara alami dari konsentrat buah naga merah tanpa sedikitpun pewarna buatan.',
      imageAsset: 'assets/images/buah_naga.jpg',
      colorHex: '#D81B60',
      primaryColor: Color(0xFFD81B60),
      ingredients: [
        'Tepung Terigu Pilihan',
        'Sari Buah Naga Merah Segar',
        'Air Murni',
        'Garam Alami'
      ],
      highlights: [
        'Warna magenta pink anggun & eksotis',
        'Menambah nilai jual menu cafe & resto',
        'Kaya antioksidan alami',
      ],
      isPopular: true,
    ),
    const ProductVariant(
      id: 'mie_bit',
      name: 'Mie Buah Bit',
      category: ProductCategory.buah,
      badgeText: 'Nutrisi Super',
      shortDescription:
          'Mie kering bernutrisi tinggi dengan warna ungu murni dari buah bit segar.',
      description:
          'Buah Bit dikenal sebagai superfood kaya nutrisi. Mie Buah Bit MieRen memadukan kebaikan zat besi dan antioksidan buah bit ke dalam sajian mie yang kenyal dan menggugah selera.',
      imageAsset: 'assets/images/bit.jpg',
      colorHex: '#6A1B9A',
      primaryColor: Color(0xFF6A1B9A),
      ingredients: [
        'Tepung Terigu Pilihan',
        'Ekstrak Buah Bit Segar (Beetroot)',
        'Air Murni',
        'Garam Alami'
      ],
      highlights: [
        'Warna ungu gelap alami nan elegan',
        'Tinggi zat besi & antioksidan',
        'Cita rasa gurih alami yang khas',
      ],
      isPopular: false,
    ),
  ];

  List<ProductVariant> getProductsByCategory(ProductCategory category) {
    if (category == ProductCategory.all) {
      return products;
    }
    return products.where((p) => p.category == category).toList();
  }
}
