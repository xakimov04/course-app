import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/models/product.dart';
import 'package:online_shop/viewmodels/product_viewmodel.dart';
import 'package:online_shop/views/widgets/product_widget.dart';

class CardPageWidget extends StatefulWidget {
  ProductViewmodel productViewmodel;
  Function(Product) onFavoriteTapped;
  Function(int) onDeleteTapped;
  CardPageWidget(
      {required this.onDeleteTapped,
      required this.onFavoriteTapped,
      required this.productViewmodel,
      super.key});

  @override
  State<CardPageWidget> createState() => _CardPageWidgetState();
}

class _CardPageWidgetState extends State<CardPageWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.productViewmodel.cartList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text("Apida muammo bor"),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Apida error keldi"),
          );
        }

        final data = snapshot.data;
        return data == null || data.isEmpty
            ? Center(
                child: Image.asset(
                "images/not.png",
                width: 300,
                height: 300,
              ))
            : GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5,
                  crossAxisCount: 2,
                  mainAxisExtent: 250,
                ),
                itemBuilder: (context, index) {
                  final product = data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                              product: product,
                              onFavoriteTapped: widget.onFavoriteTapped),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: Colors.grey.withOpacity(0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 150,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.onFavoriteTapped(product);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      product.isFavorite
                                          ? CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      color: product.isFavorite
                                          ? Colors.red
                                          : Colors.grey.shade300,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${product.price}\$",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    widget.onDeleteTapped(index);
                                  },
                                  icon: const Icon(CupertinoIcons.delete,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
