import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/product_variant.dart';
import '../../data/repositories/catalog_repository.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatbotSheet extends StatefulWidget {
  const ChatbotSheet({super.key});

  @override
  State<ChatbotSheet> createState() => _ChatbotSheetState();
}

class _ChatbotSheetState extends State<ChatbotSheet> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Halo! 👋 Saya Asisten Virtual MieRen. Siap membantu Anda mendapatkan informasi produk mie sayur alami, harga grosir, & kemitraan restoran.',
      isUser: false,
    ),
  ];

  final List<String> _quickPrompts = [
    '🥬 Apa saja varian produk MieRen?',
    '📦 Berapa minimal order & harga?',
    '⚖️ Bisakah custom gramasi porsi?',
    '📜 Bagaimana status PIRT & Halal?',
    '📱 Hubungi Bu Irene via WA',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _launchWA([String? customMsg]) async {
    final info = CatalogRepository.companyInfo;
    final String msg = customMsg ??
        'Halo Bu Irene, saya berbincang dengan chatbot di website dan ingin diskusi lebih lanjut.';
    final Uri uri = Uri.parse(
      'https://wa.me/${info.whatsappNumber}?text=${Uri.encodeComponent(msg)}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _handleSendMessage([String? predefinedText]) {
    String query = (predefinedText ?? _inputController.text).trim();
    if (query.isEmpty) return;

    // Security input clamping: max 200 characters
    if (query.length > 200) {
      query = query.substring(0, 200);
    }

    if (predefinedText == null) {
      _inputController.clear();
    }

    setState(() {
      _messages.add(ChatMessage(text: query, isUser: true));
    });

    _scrollToBottom();

    // Generate intelligent response after short delay
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      final botResponse = _generateResponse(query);
      setState(() {
        _messages.add(ChatMessage(text: botResponse, isUser: false));
      });
      _scrollToBottom();
    });
  }

  String _generateResponse(String userQuery) {
    final q = userQuery.toLowerCase().trim();
    final info = CatalogRepository.companyInfo;
    final products = CatalogRepository.products;

    // 1. Check for specific product names (Caisim, Wortel, Buah Naga, Bit, Original)
    if (q.contains('caisim') || q.contains('sawit') || q.contains('hijau')) {
      final p = products.firstWhere((element) => element.id == 'mie_caisim');
      return '🥬 ${p.name}:\n${p.description}\n\n• Bahan: ${p.ingredients.join(", ")}\n• Keunggulan: ${p.highlights.join(", ")}';
    }
    if (q.contains('wortel') || q.contains('oranye') || q.contains('orange')) {
      final p = products.firstWhere((element) => element.id == 'mie_wortel');
      return '🥕 ${p.name}:\n${p.description}\n\n• Bahan: ${p.ingredients.join(", ")}\n• Keunggulan: ${p.highlights.join(", ")}';
    }
    if (q.contains('naga') || q.contains('merah') || q.contains('pink')) {
      final p = products.firstWhere((element) => element.id == 'mie_buah_naga');
      return '🌺 ${p.name}:\n${p.description}\n\n• Bahan: ${p.ingredients.join(", ")}\n• Keunggulan: ${p.highlights.join(", ")}';
    }
    if (q.contains('bit') || q.contains('beetroot') || q.contains('ungu') || q.contains('purple')) {
      final p = products.firstWhere((element) => element.id == 'mie_bit');
      return '💜 ${p.name}:\n${p.description}\n\n• Bahan: ${p.ingredients.join(", ")}\n• Keunggulan: ${p.highlights.join(", ")}';
    }
    if (q.contains('original') || q.contains('putih') || q.contains('biasa')) {
      final p = products.firstWhere((element) => element.id == 'mie_putih');
      return '🍜 ${p.name}:\n${p.description}\n\n• Bahan: ${p.ingredients.join(", ")}\n• Keunggulan: ${p.highlights.join(", ")}';
    }

    // 2. Greetings / Salutations
    if (q == 'halo' || q == 'hai' || q == 'pagi' || q == 'siang' || q == 'sore' || q == 'malam' ||
        q.startsWith('halo') || q.startsWith('hai') || q.startsWith('selamat')) {
      return 'Halo! 👋 Saya Asisten Virtual MieRen. Saya siap membantu Anda mengenai varian mie sayur alami, harga grosir, custom porsi gramasi, dan kemitraan resto dengan MieRen.';
    }

    // 3. Gratitude & Courtesy
    if (q.contains('terima kasih') || q.contains('makasih') || q.contains('thanks') || q.contains('thx')) {
      return 'Sama-sama! 🙏 Senang bisa membantu Anda. Jika ada pertanyaan lain seputar produk MieRen atau ingin memesan sampel, silakan hubungi Bu Irene via WhatsApp.';
    }

    // 4. Contact / WhatsApp / Bu Irene
    if (q.contains('hubungi') || q.contains('wa') || q.contains('whatsapp') || q.contains('kontak') ||
        q.contains('telepon') || q.contains('phone') || q.contains('irene') || q.contains('email')) {
      return 'Anda dapat menghubungi Bu Irene (${info.contactPerson}) secara langsung:\n• WhatsApp / HP: ${info.formattedPhone}\n• Email: ${info.email}\n\nKlik icon WhatsApp di sudut kanan bawah untuk otomatis memulai percakapan!';
    }

    // 5. Variants / Flavors / Product List
    if (q.contains('varian') || q.contains('produk') || q.contains('rasa') || q.contains('jenis') || q.contains('katalog')) {
      final names = products.map((p) => '• ${p.name} (${p.category.label})').join('\n');
      return 'MieRen menyediakan 5 varian mie kering berbahan sayuran alami:\n$names\n\nSemua varian dibuat dari ekstrak sayur alami tanpa pewarna buatan!';
    }

    // 6. Pricing, Order, Minimum Quantity, Wholesale
    if (q.contains('harga') || q.contains('order') || q.contains('minimal') || q.contains('grosir') ||
        q.contains('beli') || q.contains('pesan') || q.contains('biaya') || q.contains('diskon') || q.contains('murah')) {
      return 'Kebijakan Penawaran Harga MieRen:\n${info.pricingPolicy}.\n\nKami melayani pasokan grosir untuk restoran, cafe, catering, maupun ritel. Hubungi Bu Irene via WA untuk list harga lengkap!';
    }

    // 7. Custom Portion & Grammage
    if (q.contains('gramasi') || q.contains('porsi') || q.contains('berat') || q.contains('custom') || q.contains('ukuran')) {
      return 'Spesifikasi Gramasi MieRen:\n• Standar: ${info.weightStandard}\n• Custom: Kami menerima permintaan penyesuaian porsi/gramasi khusus sesuai standar hidangan di resto Anda.';
    }

    // 8. Legalities & Certificates (PIRT & Halal)
    if (q.contains('pirt') || q.contains('halal') || q.contains('izin') || q.contains('sertifikat') || q.contains('bpom') || q.contains('resmi')) {
      return 'Status Legalitas Produk MieRen:\n• PIRT: ${info.pirtStatus}\n• Sertifikasi Halal: ${info.halalStatus}\n\nProduk dijamin higienis, terdaftar, dan aman dikonsumsi.';
    }

    // 9. Ingredients, Health & Quality
    if (q.contains('pengawet') || q.contains('air abu') || q.contains('sehat') || q.contains('sayur') ||
        q.contains('bahan') || q.contains('komposisi') || q.contains('alami') || q.contains('organik') || q.contains('nutrisi')) {
      return 'Keunggulan Alami MieRen:\n• 100% Menggunakan bahan & ekstrak sayur segar alami\n• Bebas pewarna sintetis & bebas pengawet buatan\n• Formulasi khusus TANPA AIR ABU (alkali water) sehingga lebih aman & ramah di pencernaan!';
    }

    // 10. Shelf Life & Storage
    if (q.contains('tahan') || q.contains('shelf life') || q.contains('kadaluarsa') || q.contains('exp') ||
        q.contains('simpan') || q.contains('awet') || q.contains('expired')) {
      return 'Daya Tahan & Penyimpanan:\n• Shelf Life: ${info.shelfLife}\n• Sifat Produk: Mie kering (dry product) yang praktis disimpan dan tidak mudah rusak dalam stok operasional resto.';
    }

    // 11. Company & About MieRen
    if (q.contains('mieren') || q.contains('perusahaan') || q.contains('pabrik') || q.contains('produsen') || q.contains('siapa') || q.contains('profil')) {
      return 'Profil MieRen:\n${info.aboutText}';
    }

    // 12. Strict Domain Bounding Rule: If query relates to MieRen context
    final isMieRenRelated = q.contains('mie') ||
        q.contains('ren') ||
        q.contains('kuliner') ||
        q.contains('makanan') ||
        q.contains('dapur') ||
        q.contains('masak') ||
        q.contains('menu') ||
        q.contains('sampel') ||
        q.contains('sample');

    if (isMieRenRelated) {
      return 'Terima kasih atas pertanyaannya! MieRen adalah ${info.tagline}. Anda dapat menanyakan varian rasa, harga grosir, custom gramasi, atau menekan tombol WhatsApp untuk diskusi dengan Bu Irene.';
    }

    // Out-of-parameter refusal message:
    return 'Maaf, saya adalah Asisten Virtual khusus MieRen. Saya hanya dapat menjawab pertanyaan seputar produk mie sayur alami, varian, harga grosir, dan informasi terkait MieRen.\n\nSilakan tanyakan hal seputar produk atau layanan MieRen! 😊';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle & Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF242424) : const Color(0xFFE8F5E9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/logo-badge-centered.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'MieRen Assistant',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2E7D32),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Online • Layanan Informasi Mieren',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? Colors.white60 : Colors.black54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg, theme, isDark);
              },
            ),
          ),

          // Quick Prompts Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _quickPrompts.length,
              itemBuilder: (context, index) {
                final prompt = _quickPrompts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    label: Text(
                      prompt,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white70 : theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: isDark
                        ? const Color(0xFF2A2A2A)
                        : theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    onPressed: () {
                      if (prompt.contains('WA')) {
                        _launchWA();
                      } else {
                        _handleSendMessage(prompt);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Input text area
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      maxLength: 200,
                      buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) =>
                          null,
                      onSubmitted: (_) => _handleSendMessage(),
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Ketik pertanyaan (maks. 200 karakter)...',
                        hintStyle: const TextStyle(fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF2C2C2C)
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _handleSendMessage(),
                    icon: const Icon(Icons.send_rounded, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Diskusi via WA',
                    icon: const FaIcon(FontAwesomeIcons.whatsapp,
                        color: Color(0xFF25D366), size: 24),
                    onPressed: () => _launchWA(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, ThemeData theme, bool isDark) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/logo-badge-centered.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary
                    : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  color: isUser
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black87),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
