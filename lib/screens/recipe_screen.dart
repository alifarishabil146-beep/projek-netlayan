import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';

class RecipeScreen extends StatelessWidget {
  final NetlayanStore store;

  const RecipeScreen({super.key, required this.store});

  void _showRecipeDetail(BuildContext context, RecipeModel recipe) {
    // Find matching fish in catalog if available
    FishItem? matchingFish;
    try {
      matchingFish = store.fishList.firstWhere(
        (f) => f.title.toLowerCase().contains(recipe.targetFishName.toLowerCase().split(' ').first) || f.category == recipe.fishCategory,
      );
    } catch (_) {
      matchingFish = store.fishList.isNotEmpty ? store.fishList.first : null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  recipe.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    height: 180,
                    color: Colors.pink.shade50,
                    child: const Icon(Icons.restaurant_menu, size: 60, color: Color(0xFFE91E63)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                recipe.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.timer, size: 16, color: Color(0xFFE91E63)),
                  const SizedBox(width: 4),
                  Text(recipe.cookingTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(width: 16),
                  const Icon(Icons.bar_chart, size: 16, color: Color(0xFFE91E63)),
                  const SizedBox(width: 4),
                  Text('Tingkat: ${recipe.difficulty}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                recipe.description,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
              ),
              const SizedBox(height: 14),

              // Smart Freshness Tip Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tips_and_updates, color: Color(0xFFE91E63)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tips Pintar: ${recipe.smartTip}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF880E4F), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text('Bahan-Bahan Utama:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF880E4F))),
              const SizedBox(height: 6),
              ...recipe.ingredients.map((ing) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFFE91E63)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(ing, style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),

              const Text('Langkah Memasak:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF880E4F))),
              const SizedBox(height: 6),
              ...recipe.steps.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color(0xFFE91E63),
                          child: Text('${entry.key + 1}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),

              // Buy Matching Fresh Fish Button
              if (matchingFish != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      store.addToCart(matchingFish!, 1.0);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${matchingFish.title} (1 Kg) ditambahkan ke keranjang!'),
                          backgroundColor: const Color(0xFFE91E63),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag),
                    label: Text(
                      'Beli ${matchingFish.title} Segar (Rp ${matchingFish.pricePerKg.toStringAsFixed(0)}/Kg)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final smartFish = store.smartRecommendations;
    final recipes = store.recipes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Smart Catch Recommendation Today
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFF880E4F)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.yellowAccent, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'REKOMENDASI PINTAR TANGKAPAN SUBUS',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Analisis AI Kesegaran Hasil Laut Hari Ini:',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 12),

                // Top Recommended Fish Card
                if (smartFish.isNotEmpty)
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              smartFish.first.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(width: 80, height: 80, color: Colors.grey.shade300),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.pink.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Skor Kesegaran: ${smartFish.first.freshnessScore}%',
                                        style: const TextStyle(fontSize: 10, color: Color(0xFFE91E63), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  smartFish.first.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text(
                                  'Rp ${smartFish.first.pricePerKg.toStringAsFixed(0)} / Kg • ${smartFish.first.catchHoursAgo}',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE91E63),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onPressed: () {
                              store.addToCart(smartFish.first, 1.0);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${smartFish.first.title} ditambahkan ke keranjang!'),
                                  backgroundColor: const Color(0xFFE91E63),
                                ),
                              );
                            },
                            child: const Text('Beli', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 2: Recipe Recommendations
          const Text(
            'Resep & Olahan Masakan Ikan Segar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
          ),
          const Text(
            'Inspirasi resep pilihan yang cocok dengan tangkapan nelayan hari ini:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 14),

          ...recipes.map((recipe) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showRecipeDetail(context, recipe),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          recipe.imageUrl,
                          width: 95,
                          height: 95,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 95,
                            height: 95,
                            color: Colors.pink.shade50,
                            child: const Icon(Icons.restaurant, size: 40, color: Color(0xFFE91E63)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Cocok untuk: ${recipe.targetFishName}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFFE91E63), fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.timer, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(recipe.cookingTime, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                const SizedBox(width: 10),
                                const Icon(Icons.auto_awesome, size: 14, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(recipe.difficulty, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFE91E63)),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
