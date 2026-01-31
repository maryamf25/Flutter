import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pokemon.dart';
import '../screens/pokemon_detail_screen.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  Color _getPrimaryColor(int id) {
    final colors = [
      Colors.red.shade400,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.amber.shade400,
      Colors.purple.shade400,
      Colors.orange.shade400,
      Colors.teal.shade400,
      Colors.pink.shade400,
      Colors.indigo.shade400,
      Colors.cyan.shade400,
    ];
    return colors[id % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _getPrimaryColor(pokemon.id);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardColor.withOpacity(0.8), cardColor],
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PokemonDetailScreen(pokemon: pokemon, cardColor: cardColor),
              ),
            );
          },
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  Icons.catching_pokemon,
                  size: 120,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '#${pokemon.id.toString().padLeft(3, '0')}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Hero(
                      tag: pokemon.name,
                      child: CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.catching_pokemon,
                          color: Colors.white70,
                          size: 60,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      pokemon.name.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
