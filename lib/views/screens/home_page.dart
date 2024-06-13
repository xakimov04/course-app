import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/models/product.dart';
import 'package:online_shop/viewmodels/product_viewmodel.dart';
import 'package:online_shop/views/widgets/card_page_widget.dart';
import 'package:online_shop/views/widgets/custom_drawer.dart';
import 'package:online_shop/views/widgets/home_widget.dart';
import 'package:online_shop/views/widgets/saved_page_widget.dart';
import 'package:online_shop/views/widgets/search_view_delegate.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _formKey = GlobalKey<FormState>();
  final ProductViewmodel productViewmodel = ProductViewmodel();
  String? title, price, amount, imageUrl;

  void onFavoriteTapped(Product product) async {
    setState(() {
      product.isFavorite = !product.isFavorite;
    });
    await productViewmodel.updateProduct(product);
  }

  void onDeleteTapped(int index) async {
    await productViewmodel.onDeleteTapped(index);
    setState(() {});
  }

  void onCartTapped(Product product) async {
    await productViewmodel.addToCard(product);
  }

  Future<void> onAddTapped() async {
    final data = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context, {
                    "title": title,
                    "imageUrl": imageUrl,
                    "price": price,
                    'amount': amount,
                  });
                }
              },
              child: const Text("Save"),
            ),
          ],
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextFormField("Title", (value) => title = value),
                buildTextFormField("Price", (value) => price = value),
                buildTextFormField("Amount", (value) => amount = value),
                buildTextFormField("Image URL", (value) => imageUrl = value),
              ],
            ),
          ),
        );
      },
    );
    if (data != null) {
      productViewmodel.addProduct(
        data['title'],
        data['imageUrl'],
        double.parse(data["price"]),
        int.parse(data['amount']),
      );
    }
    setState(() {});
  }

  TextFormField buildTextFormField(String label, Function(String) onSaved) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter $label";
        }
        onSaved(value);
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchViewDelegate(
                  onCartTapped: onCartTapped,
                  onFavoriteTapped: onFavoriteTapped,
                  productViewmodel: productViewmodel,
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
        centerTitle: true,
        title:  Text(
         AppLocalizations.of(context)!.appHome,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _getPage(_currentIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(CupertinoIcons.cart, size: 30, color: Colors.white),
          Icon(Icons.favorite_border_rounded, size: 30, color: Colors.white),
        ],
        color: Colors.deepPurple,
        buttonBackgroundColor: Colors.purple,
        backgroundColor: Colors.purple.shade500.withOpacity(.5),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.purple,
              onPressed: onAddTapped,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      drawer: const SpiderDrawer(),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomeWidget(
          onCartTapped: onCartTapped,
          onFavoriteTapped: onFavoriteTapped,
          productViewmodel: productViewmodel,
        );
      case 1:
        return CardPageWidget(
          onDeleteTapped: onDeleteTapped,
          onFavoriteTapped: onFavoriteTapped,
          productViewmodel: productViewmodel,
        );
      case 2:
        return SavedPageWidget(
          onCartTapped: onCartTapped,
          onFavoriteTapped: onFavoriteTapped,
          productViewmodel: productViewmodel,
        );
      default:
        return const Center(child: Text("Profile"));
    }
  }
}
