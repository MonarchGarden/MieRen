import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/product_variant.dart';
import '../../data/repositories/catalog_repository.dart';
import '../widgets/contact_section.dart';
import '../widgets/product_card.dart';
import '../widgets/product_detail_sheet.dart';
import '../widgets/chatbot_sheet.dart';

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
  final CatalogRepository _catalogRepository = CatalogRepository();
  ProductCategory _selectedCategory = ProductCategory.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _didPrecacheImages = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecacheImages) {
      _didPrecacheImages = true;
      for (final p in CatalogRepository.products) {
        precacheImage(AssetImage(p.imageAsset), context);
      }
      precacheImage(const AssetImage('assets/images/logo-badge-centered.png'), context);
      precacheImage(const AssetImage('assets/images/logo-badge-centered.jpg'), context);
      precacheImage(const AssetImage('assets/images/logo-badge-transparent.png'), context);
      precacheImage(const AssetImage('assets/images/logo.png'), context);
      precacheImage(const AssetImage('assets/images/hero_noodle.png'), context);
    }
  }

  List<ProductVariant> get _filteredProducts {
    final categoryProducts = _catalogRepository.getProductsByCategory(_selectedCategory);
    if (_searchQuery.trim().isEmpty) {
      return categoryProducts;
    }
    final q = _searchQuery.toLowerCase();
    return categoryProducts.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.highlights.any((h) => h.toLowerCase().contains(q)) ||
          p.ingredients.any((i) => i.toLowerCase().contains(q));
    }).toList();
  }

  void _openProductDetail(ProductVariant product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailSheet(product: product),
    );
  }

  void _openChatbot() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChatbotSheet(),
    );
  }

  Future<void> _launchWA(String message) async {
    final Uri uri = Uri.parse(
      'https://wa.me/${CatalogRepository.companyInfo.whatsappNumber}?text=${Uri.encodeComponent(message)}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode;
    final company = CatalogRepository.companyInfo;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF140A0A) : const Color(0xFFFFFDF8),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF140A0A), const Color(0xFF1F0E0E), const Color(0xFF120808)]
                : [const Color(0xFFFFFDF8), const Color(0xFFFBF4E6), const Color(0xFFF5ECE0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Oriental Background Wave & Motif Pattern
            Positioned.fill(
              child: CustomPaint(
                painter: OrientalBackgroundPainter(isDark: isDark),
              ),
            ),

            // Main Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                // 1. HERO BANNER
                _buildHeroBanner(context, company, theme, isDark),

                const SizedBox(height: 24),

                // 2. KEY ADVANTAGES / FEATURES GRID
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildAdvantagesSection(context, company, theme, isDark),
                ),

                const SizedBox(height: 32),

                // 3. PRODUCT CATALOG HEADER & SEARCH
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Katalog Varian Produk',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pilih varian mie berkualitas tinggi untuk kebutuhan menu usaha Anda',
                        style: theme.textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 16),

                      // Search Field
                      TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'Cari varian mie atau bahan (cth: Caisim, Wortel)...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Category Selector Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ProductCategory.values.map((cat) {
                            final isSelected = _selectedCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                selected: isSelected,
                                label: Text(cat.label),
                                selectedColor: theme.colorScheme.primary,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white70 : Colors.black87),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                checkmarkColor: Colors.white,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => _selectedCategory = cat);
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 4. PRODUCT GRID
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _filteredProducts.isEmpty
                      ? _buildEmptyState(context, theme)
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = 1;
                            double itemWidth = constraints.maxWidth;

                            if (constraints.maxWidth > 1100) {
                              crossAxisCount = 4;
                              itemWidth = (constraints.maxWidth - (16 * 3)) / 4;
                            } else if (constraints.maxWidth > 800) {
                              crossAxisCount = 3;
                              itemWidth = (constraints.maxWidth - (16 * 2)) / 3;
                            } else if (constraints.maxWidth > 550) {
                              crossAxisCount = 2;
                              itemWidth = (constraints.maxWidth - 16) / 2;
                            } else {
                              crossAxisCount = 1;
                              itemWidth = constraints.maxWidth;
                            }

                            // Target card height is around 360px to fit content comfortably
                            final double childAspectRatio = (itemWidth / 360).clamp(0.65, 1.2);

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: childAspectRatio,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = _filteredProducts[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () => _openProductDetail(product),
                                );
                              },
                            );
                          },
                        ),
                ),

                const SizedBox(height: 40),

                // 5. CONTACT & INQUIRY SECTION
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ContactSection(),
                ),

                const SizedBox(height: 32),

                // 6. FOOTER (Green gradient matching the top Hero Banner)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF061507), const Color(0xFF143B16), const Color(0xFF0B210D)]
                          : [const Color(0xFF154318), const Color(0xFF1B5E20), const Color(0xFF2E7D32), const Color(0xFF0F4318)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo-badge-centered.png',
                        height: 56,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/logo.png',
                            height: 56,
                            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        company.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        company.tagline,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFA5D6A7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '© 2026 MieRen. All rights reserved.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating MieRen Chatbot Trigger Button on Bottom Right Corner
          Positioned(
            right: 20,
            bottom: 20,
            child: Material(
              color: Colors.transparent,
              elevation: 6,
              shape: const CircleBorder(),
              shadowColor: Colors.black45,
              child: InkWell(
                onTap: _openChatbot,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo-badge-centered.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/logo-badge-centered.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.support_agent_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildHeroBanner(
    BuildContext context,
    CompanyInfo company,
    ThemeData theme,
    bool isDark,
  ) {
    return Stack(
      children: [
        // Multi-stop Rich Gradient Background
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0B210D), const Color(0xFF143B16), const Color(0xFF061507)]
                    : [const Color(0xFF0F4318), const Color(0xFF1B5E20), const Color(0xFF2E7D32), const Color(0xFF154318)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        // Custom Organic Pattern & Floating Ambient Glows
        Positioned.fill(
          child: CustomPaint(
            painter: HeroBackgroundPainter(isDark: isDark),
          ),
        ),

        // Hero Content
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
          child: SafeArea(
            bottom: false,
            child: Column(
          children: [
            // Top Header Actions
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: isDark ? 'Mode Terang' : 'Mode Gelap',
                    icon: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: Colors.white,
                    ),
                    onPressed: widget.onToggleTheme,
                  ),
                  IconButton(
                    tooltip: 'Chat WhatsApp',
                    icon: const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Color(0xFF25D366),
                    ),
                    onPressed: () => _launchWA(
                      'Halo Bu Irene, saya tertarik dengan katalog produk MieRen.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final content = Column(
              crossAxisAlignment:
                  isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                // Certifications Pill
                Wrap(
                  alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildHeroBadge(
                      icon: Icons.verified_rounded,
                      label: company.pirtStatus,
                    ),
                    _buildHeroBadge(
                      icon: Icons.schedule_rounded,
                      label: company.halalStatus,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Logo & Brand Name
                Row(
                  mainAxisAlignment:
                      isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo-badge-centered.png',
                      height: 76,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/logo.png',
                          height: 76,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.eco_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Text(
                      company.name,
                      textAlign: isWide ? TextAlign.left : TextAlign.center,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  company.tagline,
                  textAlign: isWide ? TextAlign.left : TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFA5D6A7),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  company.aboutText,
                  textAlign: isWide ? TextAlign.left : TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // CTA Buttons
                Wrap(
                  alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _launchWA(
                        'Halo Bu Irene, saya tertarik untuk diskusi kemitraan suplai mie restoran.',
                      ),
                      icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18),
                      label: const Text('Hubungi Bu Irene via WA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _launchWA(
                          'Halo Bu Irene, mohon kirimkan katalog PDF lengkap MieRen.',
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                      label: const Text(
                        'Minta Katalog PDF',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );

            if (isWide) {
              return Row(
                children: [
                  Expanded(flex: 3, child: content),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 240,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        'assets/images/hero_noodle.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.ramen_dining_rounded,
                          size: 100,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return content;
          },
        ),
      ],
    ),
  ),
),
],
);
}

  Widget _buildHeroBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvantagesSection(
    BuildContext context,
    CompanyInfo company,
    ThemeData theme,
    bool isDark,
  ) {
    final advantages = [
      {
        'icon': Icons.nature_people_rounded,
        'title': '100% Bahan Alami',
        'desc': 'Tanpa pewarna & pengawet sintetis. Warna asli dari Caisim, Wortel, Buah Naga & Bit.',
        'color': const Color(0xFF2E7D32),
      },
      {
        'icon': Icons.clean_hands_rounded,
        'title': 'Tanpa Air Abu',
        'desc': 'Formulasi khusus tanpa air abu (alkali water), lebih ramah pencernaan & rasa murni.',
        'color': const Color(0xFFE65100),
      },
      {
        'icon': Icons.timer_rounded,
        'title': 'Tahan ±3 Bulan',
        'desc': 'Shelf life ideal untuk persediaan bahan baku (dry product) tanpa mengurangi rasa.',
        'color': const Color(0xFF1976D2),
      },
      {
        'icon': Icons.tune_rounded,
        'title': 'Custom Gramasi',
        'desc': 'Standar 38 gram/pc & fleksibel disesuaikan porsi kebutuhan menu resto Anda.',
        'color': const Color(0xFF8E24AA),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Oriental Section Header Title with Gold Seal Line
        Row(
          children: [
            Container(
              width: 5,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Mengapa Memilih MieRen?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
                color: isDark ? const Color(0xFFE8F5E9) : const Color(0xFF1E2E1E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 650;
            const double spacing = 12;
            final int crossAxisCount = isWide ? 4 : 2;
            final double itemWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: advantages.map((adv) {
                final Color advColor = adv['color'] as Color;
                return SizedBox(
                  width: itemWidth,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F1212) : const Color(0xFFFFFDF8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withValues(alpha: isDark ? 0.08 : 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: advColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: advColor.withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            adv['icon'] as IconData,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          adv['title'] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFFF5ECE0) : const Color(0xFF2A1C1C),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          adv['desc'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            height: 1.35,
                            color: isDark ? Colors.white70 : const Color(0xFF5A4A4A),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Varian tidak ditemukan',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Coba ubah kata kunci pencarian atau pilih kategori lain.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
                _selectedCategory = ProductCategory.all;
              });
            },
            child: const Text('Tampilkan Semua Varian'),
          ),
        ],
      ),
    );
  }
}

class HeroBackgroundPainter extends CustomPainter {
  final bool isDark;
  HeroBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.04 : 0.08)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.06 : 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Ambient floating circles
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.15), 140, glowPaint);
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.75), 180, glowPaint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.1), 90, glowPaint);

    // Organic botanical wave lines across background
    final path1 = Path();
    path1.moveTo(0, size.height * 0.75);
    path1.cubicTo(
      size.width * 0.35, size.height * 0.45,
      size.width * 0.65, size.height * 0.95,
      size.width, size.height * 0.65,
    );
    canvas.drawPath(path1, linePaint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.25);
    path2.cubicTo(
      size.width * 0.4, size.height * 0.05,
      size.width * 0.7, size.height * 0.55,
      size.width, size.height * 0.15,
    );
    canvas.drawPath(path2, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OrientalBackgroundPainter extends CustomPainter {
  final bool isDark;
  OrientalBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: isDark ? 0.08 : 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final cloudPaint = Paint()
      ..color = const Color(0xFF8B0000).withValues(alpha: isDark ? 0.06 : 0.04)
      ..style = PaintingStyle.fill;

    // Draw traditional Seigaiha / Oriental concentric wave arches
    const double radius = 36;
    for (double y = 0; y < size.height + radius * 2; y += radius * 1.2) {
      final double xOffset = ((y / (radius * 1.2)).floor() % 2 == 0) ? 0 : radius;
      for (double x = -radius + xOffset; x < size.width + radius * 2; x += radius * 2) {
        for (int r = 1; r <= 3; r++) {
          final rect = Rect.fromCircle(center: Offset(x, y), radius: radius * (r / 3.0));
          canvas.drawArc(rect, 3.14159, 3.14159, false, goldPaint);
        }
      }
    }

    // Draw subtle oriental seal cloud motif accents
    canvas.drawCircle(Offset(size.width * 0.08, size.height * 0.25), 60, cloudPaint);
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.75), 80, cloudPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
