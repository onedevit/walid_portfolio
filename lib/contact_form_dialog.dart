import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'web_helper.dart' as web_helper;

/// Boîte de dialogue du formulaire de contact sécurisé avec protection Anti-Bot multicouche
/// (Honeypot Trap, Smart Math Verification, Time-Gate, et Rate-Limiting Cooldown)
class ContactFormDialog extends StatefulWidget {
  final Map<String, String> translations;
  final bool isRtl;

  const ContactFormDialog({
    super.key,
    required this.translations,
    required this.isRtl,
  });

  @override
  State<ContactFormDialog> createState() => _ContactFormDialogState();
}

class _ContactFormDialogState extends State<ContactFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _captchaController = TextEditingController();
  final _honeypotController = TextEditingController();

  static DateTime? _lastSubmissionTime;
  late final DateTime _openedAt;
  late int _num1;
  late int _num2;

  bool _isSubmitting = false;
  bool _isSuccess = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _openedAt = DateTime.now();
    _generateMathChallenge();
  }

  void _generateMathChallenge() {
    final random = math.Random();
    _num1 = random.nextInt(6) + 2; // 2..7
    _num2 = random.nextInt(6) + 1; // 1..6
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _captchaController.dispose();
    _honeypotController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final t = widget.translations;

    // 1. Protection Anti-Bot : Honeypot Trap (champ invisible rempli uniquement par les robots)
    if (_honeypotController.text.trim().isNotEmpty) {
      if (mounted) {
        setState(() => _isSuccess = true);
      }
      return;
    }

    // 2. Protection Anti-Bot : Submission Speed Gate (< 3 secondes = bot automatisé)
    final elapsedSeconds = DateTime.now().difference(_openedAt).inSeconds;
    if (elapsedSeconds < 3) {
      if (mounted) {
        setState(() {
          _errorMessage = t['formErrorCaptcha'];
        });
      }
      return;
    }

    // 3. Validation des champs obligatoires
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 4. Protection Anti-Bot : Smart Math Challenge
    final enteredAnswer = int.tryParse(_captchaController.text.trim());
    if (enteredAnswer != (_num1 + _num2)) {
      if (mounted) {
        setState(() {
          _errorMessage = t['formErrorCaptcha'];
          _generateMathChallenge();
          _captchaController.clear();
        });
      }
      return;
    }

    // 5. Protection Anti-Bot : Cooldown / Rate Limiting (1 message par 45s)
    if (_lastSubmissionTime != null &&
        DateTime.now().difference(_lastSubmissionTime!).inSeconds < 45) {
      if (mounted) {
        setState(() {
          _errorMessage = t['formErrorCooldown'];
        });
      }
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse('https://formsubmit.co/ajax/hasseniwalid@gmail.com');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          '_subject': _subjectController.text.trim().isNotEmpty
              ? 'Portfolio Contact: ${_subjectController.text.trim()}'
              : 'Nouveau message depuis le portfolio',
          'message': _messageController.text.trim(),
          '_template': 'table',
          '_captcha': 'false',
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _lastSubmissionTime = DateTime.now();
        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _isSuccess = true;
          });
        }
      } else {
        throw Exception('HTTP Status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Erreur lors de l'envoi du formulaire: $e");
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = t['formErrorSend'];
        });
      }
    }
  }

  void _openMailFallback() {
    final String subject = Uri.encodeComponent(
      _subjectController.text.trim().isNotEmpty
          ? _subjectController.text.trim()
          : 'Prise de contact via portfolio',
    );
    final String body = Uri.encodeComponent(
      'Bonjour Walid,\n\n${_messageController.text.trim()}\n\nCordialement,\n${_nameController.text.trim()} (${_emailController.text.trim()})',
    );
    final String mailto = 'mailto:hasseniwalid@gmail.com?subject=$subject&body=$body';
    try {
      web_helper.openUrl(mailto);
    } catch (e) {
      debugPrint("Erreur lors de l'ouverture du client mail: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.translations;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dialogWidth = screenWidth < 620 ? (screenWidth - 24) : 560.0;
    final String securityQuestion = t['formSecurity']!
        .replaceAll('%s', '$_num1')
        .replaceFirst('%s', '$_num2');

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header supérieur moderne
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueGrey.shade900, const Color(0xFF0D1B2A)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.4)),
                    ),
                    child: const Icon(Icons.mark_email_read_outlined, color: Colors.tealAccent, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t['contactDialogTitle']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t['contactDialogSubtitle']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                    tooltip: t['closeModal']!,
                  ),
                ],
              ),
            ),

            // Contenu du formulaire ou écran de succès
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: _isSuccess
                    ? _buildSuccessView(t)
                    : _buildFormView(t, securityQuestion),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(Map<String, String> t) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.tealAccent, width: 2),
          ),
          child: const Icon(Icons.check_circle_rounded, color: Colors.teal, size: 52),
        ),
        const SizedBox(height: 20),
        Text(
          t['formSuccessTitle']!,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          t['formSuccessDesc']!,
          style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: Text(t['closeModal']!),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFormView(Map<String, String> t, String securityQuestion) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Champ Honeypot invisible (Piege à bots)
          SizedBox(
            width: 0,
            height: 0,
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _honeypotController,
                focusNode: FocusNode(skipTraversal: true),
              ),
            ),
          ),

          // Message d'erreur éventuel
          if (_errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(fontSize: 13, color: Colors.red.shade800),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Champ Nom complet
          _buildTextField(
            label: t['formName']!,
            hint: t['formNameHint']!,
            controller: _nameController,
            icon: Icons.person_outline,
            validator: (v) => (v == null || v.trim().isEmpty) ? t['formErrorRequired'] : null,
          ),
          const SizedBox(height: 14),

          // Champ Email
          _buildTextField(
            label: t['formEmail']!,
            hint: t['formEmailHint']!,
            controller: _emailController,
            icon: Icons.alternate_email,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return t['formErrorRequired'];
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(v.trim())) return t['formErrorEmail'];
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Champ Sujet
          _buildTextField(
            label: t['formSubject']!,
            hint: t['formSubjectHint']!,
            controller: _subjectController,
            icon: Icons.title,
          ),
          const SizedBox(height: 14),

          // Champ Message
          _buildTextField(
            label: t['formMessage']!,
            hint: t['formMessageHint']!,
            controller: _messageController,
            icon: Icons.chat_bubble_outline,
            maxLines: 4,
            validator: (v) => (v == null || v.trim().isEmpty) ? t['formErrorRequired'] : null,
          ),
          const SizedBox(height: 18),

          // Boîte de protection Anti-Spam / Math Challenge
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.shade50.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.security, color: Colors.teal, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        securityQuestion,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 18, color: Colors.teal),
                      tooltip: 'Changer la question',
                      onPressed: () {
                        setState(() {
                          _generateMathChallenge();
                          _captchaController.clear();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _captchaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: t['formSecurityHint']!,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.teal.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.teal, width: 2),
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? t['formErrorRequired'] : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Boutons d'action
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                child: Text(t['closeModal']!),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitForm,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(_isSubmitting ? t['formSending']! : t['formSubmit']!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),

          // Option de repli vers le client mail
          const SizedBox(height: 14),
          Center(
            child: TextButton.icon(
              onPressed: _openMailFallback,
              icon: const Icon(Icons.open_in_new, size: 15, color: Colors.blueGrey),
              label: Text(
                t['formOpenMailClient']!,
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            prefixIcon: maxLines == 1 ? Icon(icon, size: 18, color: Colors.blueGrey) : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.teal, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
