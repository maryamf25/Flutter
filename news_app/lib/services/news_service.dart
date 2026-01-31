import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news.dart';

class NewsService {
  static String get apiKey {
    try {
      final key = dotenv.env['NEWS_API_KEY'] ?? '';
      if (key.isEmpty || key == 'your_api_key_here') {
        return '';
      }
      return key;
    } catch (e) {
      print('Error accessing API key: $e');
      return '';
    }
  }

  static const String baseUrl = 'https://newsapi.org/v2';

  static Future<List<News>> fetchNews({String category = 'general'}) async {
    final key = apiKey;

    if (key.isEmpty) {
      throw Exception(
        '📢 NewsAPI Key Required!\n\n'
        'To fetch real news, please:\n'
        '1. Get a free API key from: https://newsapi.org/register\n'
        '2. Add it to your .env file:\n'
        '   NEWS_API_KEY=your_api_key_here\n'
        '3. Restart the app',
      );
    }

    final url = Uri.parse(
      '$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<News> articles = [];

        for (var item in data['articles']) {
          if (item['title'] == null ||
              item['title'] == '[Removed]' ||
              item['description'] == null) {
            continue;
          }

          String sourceName = 'DailyPulse';
          if (item['source'] != null && item['source']['name'] != null) {
            sourceName = item['source']['name'];
            if (sourceName.toLowerCase().endsWith('.com')) {
              sourceName = sourceName.substring(0, sourceName.length - 4);
            }
          }

          String authorName = item['author'] ?? sourceName;

          if (authorName.contains('http') || authorName.length > 50) {
            authorName = sourceName;
          }

          articles.add(
            News(
              title: item['title'] ?? 'No Title',
              description: item['description'] ?? 'No description available',
              content:
                  item['content'] ??
                  item['description'] ??
                  'No content available',
              imageUrl:
                  item['urlToImage'] ??
                  'https://picsum.photos/800/600?random=${articles.length}',
              category: _formatCategory(category),
              author: authorName,
              source: sourceName,
              publishedAt: item['publishedAt'] ?? '',
            ),
          );
        }

        return articles;
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key. Please check your NewsAPI key in the .env file.',
        );
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        throw Exception('Failed to fetch news: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('API key') ||
          e.toString().contains('rate limit')) {
        rethrow;
      }
      throw Exception('Network error. Please check your internet connection.');
    }
  }

  static String _formatCategory(String category) {
    return category[0].toUpperCase() + category.substring(1);
  }
}
