import 'package:flutter/material.dart';
import '../screens/produtos_page.dart';

class PlantItemCard extends StatefulWidget {
  final Plant plant;
  final Function(Map<String, dynamic>)? onAddToBudget;
  final VoidCallback? onProductTap;

  const PlantItemCard({
    Key? key,
    required this.plant,
    this.onAddToBudget,
    this.onProductTap,
  }) : super(key: key);

  @override
  State<PlantItemCard> createState() => _PlantItemCardState();
}

class _PlantItemCardState extends State<PlantItemCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onProductTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage(widget.plant.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.plant.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.onAddToBudget != null) {
                            widget.onAddToBudget!(_createOrderItem());
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.green,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'A partir de R\$${widget.plant.price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _createOrderItem() {
    return {
      'productName': widget.plant.name,
      'imageUrl': widget.plant.imageUrl,
      'price': widget.plant.price,
      'category': widget.plant.category,
    };
  }
}
