import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonService _pokemonService = PokemonService();
  final ScrollController _scrollController = ScrollController();

  List<Pokemon> _pokemonList = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _isOffline = false;
  String? _errorMessage;
  int _currentOffset = 0;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore &&
        _hasMoreData &&
        !_isLoading) {
      _loadMorePokemon();
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _pokemonList.clear();
      _currentOffset = 0;
      _hasMoreData = true;
    });

    try {
      // Load random Pokemon on refresh
      final (data, isOffline) = await _pokemonService.getRandomPokemon(
        count: 50,
      );

      if (mounted) {
        setState(() {
          _pokemonList = data;
          _isOffline = isOffline;
          _isLoading = false;
        });

        if (isOffline) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.wifi_off, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    'No Internet. Showing cached data.',
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.shuffle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text('Loaded random Pokémon!', style: GoogleFonts.poppins()),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Could not load data. Check connection.';
        });
      }
    }
  }

  Future<void> _loadMorePokemon() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentOffset += _pokemonService.pageSize;

      if (_currentOffset >= _pokemonService.totalPokemon) {
        setState(() {
          _hasMoreData = false;
          _isLoadingMore = false;
        });
        return;
      }

      final (data, isOffline) = await _pokemonService.getPokemon(
        offset: _currentOffset,
      );

      if (mounted) {
        setState(() {
          _pokemonList.addAll(data);
          _isOffline = isOffline;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade400, Colors.red.shade300, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _fetchData,
        backgroundColor: Colors.red.shade600,
        elevation: 6,
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: Text(
          'Refresh',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.catching_pokemon,
              color: Colors.red.shade600,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pokédex',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_pokemonList.length} Pokémon',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_isOffline)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wifi_off, color: Colors.white, size: 24),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade600),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading Pokémon...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.red.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: Text(
                  'Retry',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _pokemonList.length,
              itemBuilder: (context, index) {
                return PokemonCard(pokemon: _pokemonList[index]);
              },
            ),
          ),
          if (_isLoadingMore)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.red.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading more Pokémon...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          if (!_hasMoreData && _pokemonList.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'All Pokémon loaded! 🎉',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
