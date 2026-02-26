import 'package:flutter/material.dart';

import 'web_view_page.dart';

class FloatingButtonChatSupport extends StatelessWidget {
  final String version;
  final String route;
  final String botToken;
  final String chatId;
  final String? threadIdFeedback;
  final String? threadIdComplaint;
  final String? threadIdNewFeature;

  const FloatingButtonChatSupport({
    super.key,
    required this.version,
    required this.route,
    required this.botToken,
    required this.chatId,
    this.threadIdFeedback,
    this.threadIdComplaint,
    this.threadIdNewFeature,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 16,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WebViewPage(
                version: version,
                route: route,
                botToken: botToken,
                chatId: chatId,
                threadIdFeedback: threadIdFeedback,
                threadIdComplaint: threadIdComplaint,
                threadIdNewFeature: threadIdNewFeature,
              ),
            ),
          );
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4F46E5),
                Color(0xFF06B6D4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: const Icon(
            Icons.forum,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
