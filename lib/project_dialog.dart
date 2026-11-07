import 'package:flutter/material.dart';

/// Boîte de dialogue modale affichant les détails d'un projet marquant
void showProjectDetailsDialog(
  BuildContext context, {
  required String title,
  required String desc,
  required String techStack,
  required String closeBtnText,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              desc,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 15),
            const Text(
              'Technologies & Stack:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                techStack,
                style: TextStyle(
                  color: Colors.blueGrey.shade800,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(closeBtnText),
          ),
        ],
      );
    },
  );
}

/// Carte de projet interactive responsive avec modal de détails au clic
class ProjectCard extends StatelessWidget {
  final String title;
  final String desc;
  final String tech;
  final String btnText;
  final String closeBtnText;
  final double screenWidth;

  const ProjectCard({
    super.key,
    required this.title,
    required this.desc,
    required this.tech,
    required this.btnText,
    required this.closeBtnText,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = screenWidth < 400 ? (screenWidth - 32) : 350.0;
    return InkWell(
      onTap: () => showProjectDetailsDialog(
        context,
        title: title,
        desc: desc,
        techStack: tech,
        closeBtnText: closeBtnText,
      ),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: cardWidth,
        height: 230,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blueGrey.shade100),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.open_in_new, size: 18, color: Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                desc,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.4,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.touch_app, size: 16, color: Colors.teal),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    btnText,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
