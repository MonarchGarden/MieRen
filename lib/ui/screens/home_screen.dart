import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/product_variant.dart';
import '../../data/repositories/catalog_repository.dart';
import '../widgets/product_card.dart';
import '../widgets/product_detail_sheet.dart';
import '../widgets/full_screen_image_viewer.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CompanyInfo company = CatalogRepository.companyInfo;

  Future<void> _launchWA(String message) async {
    final Uri uri = Uri.parse(
      'https://wa.me/${company.whatsappNumber}?text=${Uri.encodeComponent(message)}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _launchEmail() async {
    final Uri uri = Uri.parse('mailto:${company.email}');
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  void _openProductDetail(ProductVariant product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailSheet(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    tooltip: isDark ? 'Mode Terang' : 'Mode Gelap',
                    icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                    onPressed: widget.onToggleTheme,
                  ),
                ),
              ),
              const SizedBox(height: 8),

            // --- HALAMAN 1: COVER KATALOG (PDF Page 1) ---
            RepaintBoundary(child: _buildPage1Cover(context, isDark)),

            const SizedBox(height: 32),

            // --- HALAMAN 2: PROFIL USAHA (PDF Page 2) ---
            RepaintBoundary(child: _buildPage2ProfilUsaha(context, isDark)),

            const SizedBox(height: 32),

            // --- HALAMAN 3: VARIAN PRODUK (PDF Page 3) ---
            RepaintBoundary(child: _buildPage3VarianProduk(context, isDark)),

            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

  // --- HALAMAN 1: COVER KATALOG (Mirroring Page 1 of PDF) ---
  Widget _buildPage1Cover(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B1F1C) : const Color(0xFFF7FAF7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;

              final leftImageSection = Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      FullScreenImageViewer.show(
                        context,
                        imageAsset: 'assets/images/hero_noodle.png',
                        title: 'MieRen Premium Quality',
                        subtitle: 'Spesialis Mie Kering Tanpa Air Abu',
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/hero_noodle.png',
                        height: isWide ? 220 : 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/caisim.jpg',
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      FullScreenImageViewer.show(
                        context,
                        imageAsset: 'assets/images/caisim.jpg',
                        title: 'Mie Sayur Caisim',
                        subtitle: 'Warna Alami Dari Ekstrak Caisim Segar',
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/caisim.jpg',
                        height: isWide ? 180 : 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              );

              final rightInfoSection = Column(
                crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo-badge-centered.png',
                    height: 110,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.eco_rounded,
                      size: 90,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    company.name,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2E7D32),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    company.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    company.subtitle,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2E7D32),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF262C27) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildContactRow(
                          iconWidget: const Icon(Icons.person_rounded, size: 18, color: Color(0xFF2E7D32)),
                          label: 'Contact Person',
                          value: company.contactPerson,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () => _launchWA('Halo Bu Irene, saya tertarik dengan Katalog MieRen.'),
                          child: _buildContactRow(
                            iconWidget: const FaIcon(FontAwesomeIcons.whatsapp, size: 18, color: Color(0xFF25D366)),
                            label: 'Whatsapp',
                            value: company.formattedPhone,
                            isDark: isDark,
                            isLink: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: _launchEmail,
                          child: _buildContactRow(
                            iconWidget: const Icon(Icons.email_rounded, size: 18, color: Color(0xFF2E7D32)),
                            label: 'E-mail',
                            value: company.email,
                            isDark: isDark,
                            isLink: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: leftImageSection),
                    const SizedBox(width: 32),
                    Expanded(flex: 6, child: rightInfoSection),
                  ],
                );
              }

              return Column(
                children: [
                  rightInfoSection,
                  const SizedBox(height: 24),
                  leftImageSection,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // --- HALAMAN 2: PROFIL USAHA & KEUNGGULAN (Mirroring Page 2 of PDF) ---
  Widget _buildPage2ProfilUsaha(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B1F1C) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              const Text(
                'Profil Usaha',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 16),

              // Tentang MieRen Box
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 650;
                  final aboutTextWidget = Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF28241D) : const Color(0xFFFAF6EE),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tentang MieRen',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: isDark ? Colors.white70 : const Color(0xFF333333),
                            ),
                            children: const [
                              TextSpan(text: 'Kami adalah produsen '),
                              TextSpan(text: 'mie kering ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: 'berbahan '),
                              TextSpan(
                                text: 'sayuran segar alami ',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                              ),
                              TextSpan(
                                  text:
                                      'yang berfokus pada kualitas premium, konsistensi produksi, dan hadir untuk memberikan '),
                              TextSpan(text: 'opsi alternatif ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: 'kepada restoran untuk menyajikan '),
                              TextSpan(
                                  text: 'hidangan karbohidrat (mie) namun dengan berbahan sayuran.',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

                  final logoBadgeWidget = Image.asset(
                    'assets/images/logo-badge-centered.png',
                    height: 140,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.eco_rounded,
                      size: 90,
                      color: Color(0xFF2E7D32),
                    ),
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 3, child: logoBadgeWidget),
                        const SizedBox(width: 24),
                        Expanded(flex: 7, child: aboutTextWidget),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      logoBadgeWidget,
                      const SizedBox(height: 16),
                      aboutTextWidget,
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),

              // Keunggulan Produk Header
              const Text(
                'Keunggulan Produk',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 16),

              // 3 Keunggulan Cards (Pills matching PDF Page 2)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;

                  if (isWide) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _buildAdvantageCard(
                              icon: Icons.eco_rounded,
                              text: company.advantages[0],
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildAdvantageCard(
                              icon: Icons.inventory_2_rounded,
                              text: company.advantages[1],
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildAdvantageCard(
                              icon: Icons.thumb_up_alt_rounded,
                              text: company.advantages[2],
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        _buildAdvantageCard(
                          icon: Icons.eco_rounded,
                          text: company.advantages[0],
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        _buildAdvantageCard(
                          icon: Icons.inventory_2_rounded,
                          text: company.advantages[1],
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        _buildAdvantageCard(
                          icon: Icons.thumb_up_alt_rounded,
                          text: company.advantages[2],
                          isDark: isDark,
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HALAMAN 3: VARIAN PRODUK (Mirroring Page 3 of PDF) ---
  Widget _buildPage3VarianProduk(BuildContext context, bool isDark) {
    final products = CatalogRepository.products;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B1F1C) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header with Sample Request Starburst Callout
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: [
                  const Text(
                    'Varian Produk',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  InkWell(
                    onTap: () => _launchWA('Halo Bu Irene, saya berminat meminta sampel varian produk MieRen.'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            company.sampleInfo,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 5 Products Grid (1..5)
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  double itemWidth = constraints.maxWidth;

                  if (constraints.maxWidth > 850) {
                    crossAxisCount = 3;
                    itemWidth = (constraints.maxWidth - 32) / 3;
                  } else if (constraints.maxWidth > 550) {
                    crossAxisCount = 2;
                    itemWidth = (constraints.maxWidth - 16) / 2;
                  } else {
                    crossAxisCount = 1;
                    itemWidth = constraints.maxWidth;
                  }

                  double childAspectRatio = 0.8;
                  if (crossAxisCount == 3) {
                    childAspectRatio = (itemWidth / 340).clamp(0.68, 0.82);
                  } else if (crossAxisCount == 2) {
                    childAspectRatio = (itemWidth / 330).clamp(0.68, 0.82);
                  } else {
                    childAspectRatio = (itemWidth / 340).clamp(0.75, 1.1);
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => _openProductDetail(product),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 28),

              // Bottom Info Box (Mirroring PDF Page 3 Info Icon Box)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF282828) : const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoBullet(
                            title: 'Berat/pc',
                            detail: company.weightStandard,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoBullet(
                            title: 'Harga',
                            detail: company.pricingPolicy,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoBullet(
                            title: 'Sertifikasi',
                            detail: '${company.pirtStatus}, ${company.halalStatus}',
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvantageCard({
    double? width,
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF223023) : const Color(0xFFC5E1A5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required Widget iconWidget,
    required String label,
    required String value,
    required bool isDark,
    bool isLink = false,
  }) {
    return Row(
      children: [
        SizedBox(width: 20, child: Center(child: iconWidget)),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isLink ? const Color(0xFF2E7D32) : (isDark ? Colors.white : Colors.black87),
              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBullet({
    required String title,
    required String detail,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.5, right: 10.0),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: isDark ? Colors.white : Colors.black87,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: detail),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
