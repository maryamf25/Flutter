import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news.dart';

class ArticleScreen extends StatefulWidget {
  final News news;

  const ArticleScreen({super.key, required this.news});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool _isSaved = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = prefs.getStringList('saved_articles') ?? [];
    setState(() {
      _isSaved = savedArticles.any((article) {
        final decoded = jsonDecode(article);
        return decoded['title'] == widget.news.title &&
            decoded['publishedAt'] == widget.news.publishedAt;
      });
      _isLoading = false;
    });
  }

  Future<void> _toggleSave() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = prefs.getStringList('saved_articles') ?? [];

    if (_isSaved) {
      // Remove from saved
      savedArticles.removeWhere((article) {
        final decoded = jsonDecode(article);
        return decoded['title'] == widget.news.title &&
            decoded['publishedAt'] == widget.news.publishedAt;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Article removed from saved',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      // Add to saved
      final articleJson = jsonEncode({
        'title': widget.news.title,
        'description': widget.news.description,
        'imageUrl': widget.news.imageUrl,
        'publishedAt': widget.news.publishedAt,
        'content': widget.news.content,
        'author': widget.news.author,
        'source': widget.news.source,
        'category': widget.news.category,
      });
      savedArticles.add(articleJson);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Article saved successfully',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    await prefs.setStringList('saved_articles', savedArticles);
    setState(() => _isSaved = !_isSaved);
  }

  int _calculateReadTime(String content) {
    final wordCount = content.split(' ').length;
    final minutes = (wordCount / 200).ceil(); // Average reading speed
    return minutes;
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

  @override
  Widget build(BuildContext context) {
    final readTime = _calculateReadTime(widget.news.content);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Floating App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.news.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getCategoryColor(widget.news.category)
                                .withValues(alpha: 0.4),
                            _getCategoryColor(widget.news.category)
                                .withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.article_rounded,
                              size: 120,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'DailyPulse - ${widget.news.category.toUpperCase()}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  // Category badge at bottom
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(widget.news.category),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.news.category.toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: _isSaved
                        ? _getCategoryColor(widget.news.category)
                        : Colors.black,
                  ),
                  onPressed: _isLoading ? null : _toggleSave,
                ),
              ),
            ],
          ),
          // Article Content
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFFAFAFA),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main content container
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                widget.news.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                  color: const Color(0xFF0A0A0A),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Description/Subtitle
                              Text(
                                widget.news.description,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  height: 1.6,
                                  color: const Color(0xFF555555),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Author and Meta Info
                              Row(
                                children: [
                                  _buildAuthorAvatar(),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.news.author,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0A0A0A),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              _getTimeAgo(widget.news.publishedAt),
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              child: Container(
                                                width: 4,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[400],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.schedule,
                                              size: 14,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '$readTime min read',
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
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
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                        // Article Content
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First paragraph
                              Text(
                                widget.news.content.split('.').first + '.',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  height: 1.8,
                                  color: const Color(0xFF2A2A2A),
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 28),
                              // Pull quote
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(
                                    widget.news.category,
                                  ).withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border(
                                    left: BorderSide(
                                      color: _getCategoryColor(widget.news.category),
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.format_quote,
                                      size: 32,
                                      color: _getCategoryColor(
                                        widget.news.category,
                                      ).withValues(alpha: 0.5),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        widget.news.description,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          height: 1.6,
                                          fontStyle: FontStyle.italic,
                                          color: const Color(0xFF1A1A1A),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),
                              // Rest of content
                              Text(
                                widget.news.content,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  height: 1.8,
                                  color: const Color(0xFF2A2A2A),
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 40),
                              // Tags
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildTag(widget.news.category),
                                  _buildTag('Breaking News'),
                                  _buildTag('Featured'),
                                ],
                              ),
                              const SizedBox(height: 50),
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
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        tag,
        style: GoogleFonts.inter(
          fontSize: 13,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAuthorAvatar() {
    // Check if author is actually a source/publication name
    final isSource = widget.news.author == widget.news.source || 
                     widget.news.author.toLowerCase().contains('news') ||
                     widget.news.author.toLowerCase().contains('times') ||
                     widget.news.author.toLowerCase().contains('post') ||
                     widget.news.author.toLowerCase().contains('bbc') ||
                     widget.news.author.toLowerCase().contains('cnn') ||
                     widget.news.author.toLowerCase().contains('dailypulse');

    if (isSource) {
      // Show newspaper/source icon for publications
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              _getCategoryColor(widget.news.category).withValues(alpha: 0.2),
              _getCategoryColor(widget.news.category).withValues(alpha: 0.1),
            ],
          ),
          border: Border.all(
            color: _getCategoryColor(widget.news.category).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.newspaper_rounded,
          size: 28,
          color: _getCategoryColor(widget.news.category),
        ),
      );
    } else {
      // Show initials for actual authors
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _getCategoryColor(widget.news.category),
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: _getCategoryColor(widget.news.category).withValues(alpha: 0.1),
          child: Text(
            widget.news.author[0].toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _getCategoryColor(widget.news.category),
            ),
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
}
