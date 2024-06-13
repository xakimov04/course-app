import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/models/product.dart';
import 'package:online_shop/viewmodels/product_viewmodel.dart';
import 'package:online_shop/views/widgets/product_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SavedPageWidget extends StatefulWidget {
  ProductViewmodel productViewmodel;
  Function(Product) onFavoriteTapped;
  Function(Product) onCartTapped;
  SavedPageWidget(
      {required this.onCartTapped,
      required this.onFavoriteTapped,
      required this.productViewmodel,
      super.key});

  @override
  State<SavedPageWidget> createState() => _SavedPageWidgetState();
}

class _SavedPageWidgetState extends State<SavedPageWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.productViewmodel.list,
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

        final response = snapshot.data;
        List<Product> data = [];
        if (response != null) {
          print(response);
          for (var i in response) {
            if (i.isFavorite) {
              data.add(i);
            }
          }
        }

        return data == null || data.isEmpty
            ?  Center(
                child: Text(AppLocalizations.of(context)!.savedempty),
              )
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
                            onFavoriteTapped: widget.onFavoriteTapped,
                          ),
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
                            borderRadius: const BorderRadius.only(
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
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null
                                        ? child
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          );
                                  },
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
                                          : Colors.white,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    widget.onCartTapped(product);
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.shopping_cart,
                                    color: Colors.green,
                                  ),
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
