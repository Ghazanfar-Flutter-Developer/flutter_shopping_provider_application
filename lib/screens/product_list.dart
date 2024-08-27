import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';
import 'package:provider_shopping/components/reuseable_widget.dart';
import 'package:provider_shopping/database/db_helper.dart';
import 'package:provider_shopping/models/cart_model.dart';
import 'package:provider_shopping/provider/cart_provider.dart';
import 'package:provider_shopping/screens/cart_screen.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DbHelper dbHelper = DbHelper();

  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Cherry',
    'Peach',
    'Mixed Fruit Basket',
  ];
  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  List<int> productPrice = [
    10,
    20,
    30,
    40,
    50,
    60,
    70,
  ];
  List<String> productImages = [
    'assets/images/mango.png',
    'assets/images/orange.png',
    'assets/images/grapes.png',
    'assets/images/banana.png',
    'assets/images/cherry.png',
    'assets/images/peach.png',
    'assets/images/mixed_fruits.png',
  ];
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title: const Text(
          "Product List",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ));
            },
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              badgeAnimation: const BadgeAnimation.rotation(
                animationDuration: Duration(milliseconds: 300),
              ),
              badgeStyle: const BadgeStyle(
                badgeColor: Colors.black,
              ),
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.orange.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                                height: 100,
                                width: 100,
                                image: AssetImage(
                                  productImages[index].toString(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName[index].toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      " ${productUnit[index]} \$${productPrice[index]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          dbHelper
                                              .insert(
                                            Cart(
                                              id: index,
                                              productID: index.toString(),
                                              productName:
                                                  productName[index].toString(),
                                              initialPrice: productPrice[index],
                                              productPrice: productPrice[index],
                                              quantity: 1,
                                              unitTag:
                                                  productUnit[index].toString(),
                                              image: productImages[index]
                                                  .toString(),
                                            ),
                                          )
                                              .then((value) {
                                            cart.addTotalPrice(double.parse(
                                                productPrice[index]
                                                    .toString()));
                                            cart.addCounter();
                                          }).onError((error, stackTrace) {});
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade800,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Add to Cart",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Consumer<CartProvider>(
              builder: (context, value, child) {
                return Visibility(
                  visible: value.getTotalPrice().toStringAsFixed(2) == '0.00'
                      ? false
                      : true,
                  child: Column(
                    children: [
                      ReuseableWidget(
                        title: 'Sub Total',
                        value: r' $' + value.getTotalPrice().toStringAsFixed(2),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
