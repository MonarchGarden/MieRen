import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repositories/catalog_repository.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchWA(BuildContext context, [String? customMsg]) async {
    final info = CatalogRepository.companyInfo;
    final String defaultMsg =
        'Halo Bu ${info.contactPerson}, saya berminat dengan produk MieRen. Bisakah saya mendapatkan katalog dan daftar harga grosir?';
    final String msg = customMsg ?? defaultMsg;
    final Uri uri = Uri.parse(
      'https://wa.me/${info.whatsappNumber}?text=${Uri.encodeComponent(msg)}',
    );

    try {
      final bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _launchCall(BuildContext context) async {
    final info = CatalogRepository.companyInfo;
    final Uri uri = Uri.parse('tel:+${info.whatsappNumber}');
    try {
      await launchUrl(uri);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat melakukan panggilan: $e')),
        );
      }
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    final info = CatalogRepository.companyInfo;
    final Uri uri = Uri.parse(
      'mailto:${info.email}?subject=${Uri.encodeComponent('Inquiry Produk MieRen Grosir')}',
    );
    try {
      await launchUrl(uri);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka aplikasi email: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final info = CatalogRepository.companyInfo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1010) : const Color(0xFFFFFDF7),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: isDark ? 0.08 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.45),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hubungi Produsen MieRen',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Layanan Kemitraan Restoran & Grosir',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),

          // Contact Details List
          _buildInfoRow(
            iconWidget: Icon(Icons.person_outline_rounded, size: 20, color: theme.colorScheme.primary),
            title: 'Contact Person',
            value: info.contactPerson,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            iconWidget: FaIcon(FontAwesomeIcons.whatsapp, size: 20, color: theme.colorScheme.primary),
            title: 'WhatsApp',
            value: '${info.formattedPhone} (${info.contactPerson})',
            theme: theme,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            iconWidget: Icon(Icons.email_outlined, size: 20, color: theme.colorScheme.primary),
            title: 'Email Official',
            value: info.email,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            iconWidget: Icon(Icons.verified_outlined, size: 20, color: theme.colorScheme.primary),
            title: 'Izin & Sertifikasi',
            value: '${info.pirtStatus} | ${info.halalStatus}',
            theme: theme,
          ),

          const SizedBox(height: 24),
          Text(
            'Topik Pertanyaan Cepat:',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const FaIcon(FontAwesomeIcons.whatsapp, size: 14, color: Color(0xFF25D366)),
                label: const Text('Price List Grosir'),
                onPressed: () => _launchWA(
                  context,
                  'Halo Bu Irene, saya ingin meminta pricelist resmi pemesanan grosir MieRen.',
                ),
              ),
              ActionChip(
                avatar: const FaIcon(FontAwesomeIcons.whatsapp, size: 14, color: Color(0xFF25D366)),
                label: const Text('Sampel untuk Restoran'),
                onPressed: () => _launchWA(
                  context,
                  'Halo Bu Irene, saya pemilik / pengelola restoran dan berminat meminta sampel varian MieRen.',
                ),
              ),
              ActionChip(
                avatar: const FaIcon(FontAwesomeIcons.whatsapp, size: 14, color: Color(0xFF25D366)),
                label: const Text('Custom Gramasi / Bentuk'),
                onPressed: () => _launchWA(
                  context,
                  'Halo Bu Irene, mau tanya mengenai pemesanan custom gramasi / spesifikasi khusus mie.',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Primary Contact Action Buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _launchWA(context),
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18),
                  label: const Text('Chat WA Bu Irene'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: 'Telepon Langsung',
                onPressed: () => _launchCall(context),
                icon: const Icon(Icons.phone_outlined),
              ),
              const SizedBox(width: 4),
              IconButton.filledTonal(
                tooltip: 'Kirim Email',
                onPressed: () => _launchEmail(context),
                icon: const Icon(Icons.email_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required Widget iconWidget,
    required String title,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        SizedBox(width: 24, child: Center(child: iconWidget)),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ],
    );
  }
}
