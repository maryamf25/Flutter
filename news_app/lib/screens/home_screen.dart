import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/news_provider.dart';
import '../widgets/news_tile.dart';
import 'article_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> categories = const [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  String _getCategoryDisplay(String category) {
    return category[0].toUpperCase() + category.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.transparent, // background none
              ),
              child: const Icon(
                Icons.newspaper, // new "news" icon
                color: Colors.white, // icon color white
                size: 28,
              ),
            ),

            const SizedBox(width: 12),
            Text(
              'DailyPulse',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 18, 49, 57), Color(0xFF0891B2)],
            ),),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF667eea).withValues(alpha: 0.08),
                  const Color(0xFFf093fb).withValues(alpha: 0.08),
                ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Discover amazing stories...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF0891B2),
                    size: 26,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
                onChanged: (query) {
                  provider.searchNews(query);
                },
              ),
            ),
          ),
          // Category selector
          Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF667eea).withValues(alpha: 0.08),
                  const Color(0xFFf093fb).withValues(alpha: 0.08),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = provider.selectedCategory == category;
                return GestureDetector(
                  onTap: () => provider.selectCategory(category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 18, 49, 57),
                                Color(0xFF0891B2),
                              ],
                            )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey[200]!,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF667eea,
                                ).withValues(alpha: 0.5),
                                blurRadius: 15,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _getCategoryDisplay(category),
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.grey[800],
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // News list with pull-to-refresh
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.errorMessage,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.fetchNews(),
                          child: Text('Retry', style: GoogleFonts.poppins()),
                        ),
                      ],
                    ),
                  )
                : provider.news.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No articles found',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await provider.fetchNews();
                    },
                    child: ListView.builder(
                      itemCount: provider.news.length,
                      itemBuilder: (context, index) {
                        final news = provider.news[index];
                        return NewsTile(
                          news: news,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ArticleScreen(news: news),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
