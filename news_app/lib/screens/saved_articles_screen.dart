import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news.dart';
import 'article_screen.dart';

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  List<News> _savedArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedArticles();
  }

  Future<void> _loadSavedArticles() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getStringList('saved_articles') ?? [];

      _savedArticles = savedJson
          .map((json) {
            try {
              final map = jsonDecode(json) as Map<String, dynamic>;
              return News(
                title: map['title'] ?? '',
                description: map['description'] ?? '',
                content: map['content'] ?? '',
                imageUrl: map['imageUrl'] ?? '',
                category: map['category'] ?? 'General',
                author: map['author'] ?? 'Unknown',
                source: map['source'] ?? 'Unknown',
                publishedAt: map['publishedAt'] ?? '',
              );
            } catch (e) {
              return null;
            }
          })
          .whereType<News>()
          .toList();
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeArticle(int index) async {
    setState(() => _savedArticles.removeAt(index));

    final prefs = await SharedPreferences.getInstance();
    final savedJson = _savedArticles
        .map(
          (news) => jsonEncode({
            'title': news.title,
            'description': news.description,
            'content': news.content,
            'imageUrl': news.imageUrl,
            'category': news.category,
            'author': news.author,
            'source': news.source,
            'publishedAt': news.publishedAt,
          }),
        )
        .toList();
    await prefs.setStringList('saved_articles', savedJson);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Article removed from saved'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Saved Articles',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 22),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 18, 49, 57), Color(0xFF0891B2)],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedArticles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved articles yet',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start saving articles to read later',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _savedArticles.length,
              itemBuilder: (context, index) {
                final article = _savedArticles[index];
                return Dismissible(
                  key: Key(article.title + index.toString()),
                  background: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _removeArticle(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticleScreen(news: article),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          article.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Icon(Icons.article),
                          ),
                        ),
                      ),
                      title: Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          article.category,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF667eea),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
