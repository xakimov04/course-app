import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/models/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final Function(Product) onFavoriteTapped;

  ProductDetailPage({
    super.key,
    required this.onFavoriteTapped,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: () {
              widget.onFavoriteTapped(widget.product);
              setState(() {});
            },
            icon: widget.product.isFavorite
                ? const Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                  )
                : const Icon(CupertinoIcons.heart),
          ),
        ],
        title: Text(widget.product.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.product.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "\$${widget.product.price}",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onFavoriteTapped(widget.product);
          setState(() {});
        },
        backgroundColor: Colors.blueGrey,
        child: widget.product.isFavorite
            ? const Icon(
                CupertinoIcons.heart_fill,
                color: Colors.red,
              )
            : const Icon(CupertinoIcons.heart),
      ),
    );
  }
}
