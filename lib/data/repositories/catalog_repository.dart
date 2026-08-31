import 'package:flutter/material.dart';
import '../models/product_variant.dart';

class CompanyInfo {
  final String name;
  final String title;
  final String subtitle;
  final String tagline;
  final String contactPerson;
  final String whatsappNumber;
  final String formattedPhone;
  final String email;
  final String aboutText;
  final List<String> advantages;
  final String shelfLife;
  final String weightStandard;
  final String pricingPolicy;
  final String pirtStatus;
  final String halalStatus;
  final String sampleInfo;

  const CompanyInfo({
    required this.name,
    required this.title,
    required this.subtitle,
    required this.tagline,
    required this.contactPerson,
    required this.whatsappNumber,
    required this.formattedPhone,
    required this.email,
    required this.aboutText,
    required this.advantages,
    required this.shelfLife,
    required this.weightStandard,
    required this.pricingPolicy,
    required this.pirtStatus,
    required this.halalStatus,
    required this.sampleInfo,
  });
}

class CatalogRepository {
  static const CompanyInfo companyInfo = CompanyInfo(
    name: 'MieRen',
    title: 'Katalog Produk',
    subtitle: 'MIE SAYUR',
    tagline: 'Produsen Mie Kering Berbahan Sayuran Segar Alami',
    contactPerson: 'Irene',
    whatsappNumber: '628212633288',
    formattedPhone: '628212633288',
    email: 'pinawatywijaya@gmail.com',
    aboutText:
        'Kami adalah produsen mie kering berbahan sayuran segar alami yang berfokus pada kualitas premium, konsistensi produksi, dan hadir untuk memberikan opsi alternatif kepada restoran untuk menyajikan hidangan karbohidrat (mie) namun dengan berbahan sayuran.',
    advantages: [
      '100% bahan alami, tanpa pewarna, pengawet, dan air abu',
      'Shelf life 6 bulan (dry product)',
      'Tampilan produk menarik dengan bentuk unik & premium',
    ],
    shelfLife: '6 bulan (dry product)',
    weightStandard: '30 gr (bisa custom)',
    pricingPolicy: 'Fleksibel sesuai volume kuantitas pembelian',
    pirtStatus: 'Telah memiliki PIRT',
    halalStatus: 'sedang dalam proses sertifikasi Halal',
    sampleInfo: 'Hubungi CP untuk pengiriman sample',
  );

  static final List<ProductVariant> products = [
    const ProductVariant(
      number: 1,
      id: 'mie_putih',
      name: 'Mie Putih',
      category: ProductCategory.standard,
      badgeText: 'Mie Original',
      shortDescription: 'Mie kering original berkualitas tanpa air abu.',
      description:
          'Mie Putih MieRen diformulasikan khusus untuk kebutuhan restoran yang menginginkan mie original berkualitas tinggi. Tanpa pengawet dan tanpa air abu.',
      imageAsset: 'assets/images/original.jpg',
      colorHex: '#8D6E63',
      primaryColor: Color(0xFF8D6E63),
      ingredients: ['Tepung Terigu Pilihan', 'Air Murni', 'Garam Alami'],
      highlights: ['Kenyal Alami', 'Tanpa Air Abu', 'Serbaguna'],
    ),
    const ProductVariant(
      number: 2,
      id: 'mie_caisim',
      name: 'Mie Sayur Caisim',
      category: ProductCategory.sayur,
      badgeText: 'Best Seller',
      shortDescription: 'Mie kering sehat dengan warna hijau dari caisim segar.',
      description:
          'Mie Sayur Caisim menggunakan 100% serat caisim (sawi hijau) segar alami tanpa pewarna sintetis.',
      imageAsset: 'assets/images/caisim.jpg',
      colorHex: '#2E7D32',
      primaryColor: Color(0xFF2E7D32),
      ingredients: ['Sayur caisim', 'Tepung terigu', 'Telur', 'Air', 'Garam'],
      highlights: ['100% Caisim Alami', 'Kaya Serat', 'Warna Hijau Segar'],
      isPopular: true,
    ),
    const ProductVariant(
      number: 3,
      id: 'mie_wortel',
      name: 'Mie Sayur Wortel',
      category: ProductCategory.sayur,
      badgeText: 'Oranye Alami',
      shortDescription: 'Mie kering warna oranye cerah bernutrisi dari wortel segar.',
      description:
          'Mie Sayur Wortel memadukan tepung terigu berkualitas dan ekstrak wortel segar murni kaya Beta-Karoten.',
      imageAsset: 'assets/images/wortel.jpg',
      colorHex: '#E65100',
      primaryColor: Color(0xFFE65100),
      ingredients: ['Wortel', 'Tepung terigu', 'Telur', 'Air', 'Garam'],
      highlights: ['Warna Oranye Alami', 'Beta-Karoten', 'Favorit Restoran'],
    ),
    const ProductVariant(
      number: 4,
      id: 'mie_naga',
      name: 'Mie Buah Naga',
      category: ProductCategory.buah,
      badgeText: 'Magenta Eksotis',
      shortDescription: 'Mie kering berwarna pink magenta anggun dari buah naga merah.',
      description:
          'Mie Buah Naga memberikan tampilan visual mewah & unik dengan konsentrat buah naga merah alami.',
      imageAsset: 'assets/images/buah_naga.jpg',
      colorHex: '#D81B60',
      primaryColor: Color(0xFFD81B60),
      ingredients: ['Buah naga', 'Tepung terigu', 'Telur', 'Air', 'Garam'],
      highlights: ['Magenta Pink Alami', 'Visual Premium', 'Antioksidan'],
      isPopular: true,
    ),
    const ProductVariant(
      number: 5,
      id: 'mie_bit',
      name: 'Mie Buah Bit',
      category: ProductCategory.buah,
      badgeText: 'Ungu Elegan',
      shortDescription: 'Mie kering bernutrisi tinggi dengan warna ungu murni buah bit.',
      description:
          'Mie Buah Bit memadukan kebaikan zat besi & antioksidan buah bit segar murni.',
      imageAsset: 'assets/images/mie_buah_bit.jpeg',
      colorHex: '#6A1B9A',
      primaryColor: Color(0xFF6A1B9A),
      ingredients: ['Tepung Terigu', 'Ekstrak Buah Bit Segar', 'Air Murni', 'Garam'],
      highlights: ['Warna Ungu Alami', 'Tinggi Zat Besi', 'Rasa Gurih Alami'],
    ),
  ];
}
