import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/news.dart';

class NewsTile extends StatelessWidget {
  final News news;
  final VoidCallback onTap;

  const NewsTile({super.key, required this.news, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _getCategoryColor(news.category).withValues(alpha: 0.25),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      news.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _getCategoryColor(
                                news.category,
                              ).withValues(alpha: 0.3),
                              _getCategoryColor(
                                news.category,
                              ).withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 64,
                              color: _getCategoryColor(
                                news.category,
                              ).withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              news.category.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getCategoryColor(news.category),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[100],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: _getCategoryColor(news.category),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getCategoryColor(
                              news.category,
                            ).withValues(alpha: 0.95),
                            _getCategoryColor(
                              news.category,
                            ).withValues(alpha: 0.75),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getCategoryColor(
                              news.category,
                            ).withValues(alpha: 0.6),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(news.category),
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            news.category.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      news.title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: const Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      news.description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Author and Date
                    Row(
                      children: [
                        _buildAuthorAvatar(),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            news.author,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getTimeAgo(news.publishedAt),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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

  Widget _buildAuthorAvatar() {
    // Check if author is actually a source/publication name
    final isSource =
        news.author == news.source ||
        news.author.toLowerCase().contains('news') ||
        news.author.toLowerCase().contains('times') ||
        news.author.toLowerCase().contains('post') ||
        news.author.toLowerCase().contains('bbc') ||
        news.author.toLowerCase().contains('cnn') ||
        news.author.toLowerCase().contains('dailypulse');

    if (isSource) {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _getCategoryColor(news.category).withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.newspaper_rounded,
          size: 14,
          color: _getCategoryColor(news.category),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 12,
        backgroundColor: _getCategoryColor(
          news.category,
        ).withValues(alpha: 0.2),
        child: Text(
          news.author[0].toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _getCategoryColor(news.category),
          ),
        ),
      );
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technology':
        return const Color(0xFF667eea);
      case 'business':
      case 'finance':
        return const Color(0xFF06d6a0);
      case 'sports':
        return const Color(0xFFef476f);
      case 'health':
        return const Color(0xFFab47bc);
      case 'science':
        return const Color(0xFF26c6da);
      case 'entertainment':
        return const Color(0xFFff6f91);
      case 'general':
        return const Color(0xFF5c6bc0);
      default:
        return const Color(0xFF78909c);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'technology':
        return Icons.devices_rounded;
      case 'business':
      case 'finance':
        return Icons.business_center_rounded;
      case 'sports':
        return Icons.sports_soccer_rounded;
      case 'health':
        return Icons.favorite_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'general':
        return Icons.public_rounded;
      default:
        return Icons.article_rounded;
    }
  }

  String _getTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }
}
