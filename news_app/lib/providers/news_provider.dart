import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/news_service.dart';

class NewsProvider with ChangeNotifier {
  List<News> _news = [];
  List<News> _allNews = [];
  String _selectedCategory = 'general';
  String _searchQuery = '';
  bool _isLoading = false;
  String _errorMessage = '';

  NewsProvider() {
    fetchNews();
  }

  List<News> get news {
    if (_searchQuery.isEmpty) {
      return _news;
    }

    return _news
        .where(
          (n) =>
              n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              n.description.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void selectCategory(String category) {
    _selectedCategory = category;
    _searchQuery = ''; // Clear search when changing category
    fetchNews();
  }

  void searchNews(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchNews() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allNews = await NewsService.fetchNews(category: _selectedCategory);
      _news = _allNews;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _news = [];
      print('Error fetching news: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
