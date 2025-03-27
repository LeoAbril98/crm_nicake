import 'package:flutter/material.dart';

class FeaturedItemCard extends StatelessWidget {
  final String imageUrl;
  final String name;

  const FeaturedItemCard({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              // color: Colors.grey[200], // Remova ou altere esta linha
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(imageUrl), //alteração aqui
                fit: BoxFit.cover, //alteração aqui
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
