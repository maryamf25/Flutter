import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;
  final Color cardColor;

  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
    required this.cardColor,
  });

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final PokemonService _pokemonService = PokemonService();
  Map<String, dynamic>? _pokemonDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPokemonDetails();
  }

  Future<void> _loadPokemonDetails() async {
    try {
      final details = await _pokemonService.getPokemonDetails(
        widget.pokemon.id,
      );
      if (mounted) {
        setState(() {
          _pokemonDetails = details;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.deepOrange;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.amber;
      case 'psychic':
        return Colors.purple;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.brown;
      case 'fairy':
        return Colors.pink;
      case 'normal':
        return Colors.grey;
      case 'fighting':
        return Colors.red;
      case 'flying':
        return Colors.lightBlue;
      case 'poison':
        return Colors.deepPurple;
      case 'ground':
        return Colors.orange;
      case 'rock':
        return Colors.blueGrey;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.deepPurple.shade300;
      case 'steel':
        return Colors.blueGrey.shade300;
      default:
        return Colors.grey;
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
            colors: [
              widget.cardColor.withOpacity(0.8),
              widget.cardColor.withOpacity(0.6),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(context, widget.cardColor),
                      _buildImageSection(widget.cardColor),
                      _buildDetailsCard(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.black26),
          ),
          const Spacer(),
          Text(
            '#${widget.pokemon.id.toString().padLeft(3, '0')}',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(Color primaryColor) {
    return Hero(
      tag: widget.pokemon.name,
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(20),
        child: CachedNetworkImage(
          imageUrl: widget.pokemon.imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.catching_pokemon,
                size: 100,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Image not available',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.pokemon.name.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_pokemonDetails != null) ...[
              _buildTypesSection(),
              const SizedBox(height: 24),
              _buildPhysicalInfo(),
              const SizedBox(height: 24),
              _buildStatsSection(),
              const SizedBox(height: 24),
              _buildAbilitiesSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypesSection() {
    final types = _pokemonDetails!['types'] as List;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: types.map((type) {
        final typeName = type['type']['name'] as String;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: _getTypeColor(typeName),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _getTypeColor(typeName).withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            typeName.toUpperCase(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhysicalInfo() {
    final height = (_pokemonDetails!['height'] as int) / 10;
    final weight = (_pokemonDetails!['weight'] as int) / 10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoCard(
          'Height',
          '${height.toStringAsFixed(1)} m',
          Icons.height,
        ),
        _buildInfoCard(
          'Weight',
          '${weight.toStringAsFixed(1)} kg',
          Icons.fitness_center,
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.redAccent),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final stats = _pokemonDetails!['stats'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Base Stats',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...stats.map((stat) {
          final statName = stat['stat']['name'] as String;
          final statValue = stat['base_stat'] as int;
          return _buildStatBar(statName, statValue);
        }).toList(),
      ],
    );
  }

  Widget _buildStatBar(String name, int value) {
    final displayName = name.toUpperCase().replaceAll('-', ' ');
    final percentage = (value / 255).clamp(0.0, 1.0);
    final color = percentage > 0.7
        ? Colors.green
        : percentage > 0.4
        ? Colors.orange
        : Colors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayName,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                value.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilitiesSection() {
    final abilities = _pokemonDetails!['abilities'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Abilities',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: abilities.map((ability) {
            final abilityName = ability['ability']['name'] as String;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent.shade100, Colors.redAccent],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                abilityName.replaceAll('-', ' ').toUpperCase(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
