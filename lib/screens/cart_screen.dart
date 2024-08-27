import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';
import 'package:provider_shopping/components/reuseable_widget.dart';
import 'package:provider_shopping/database/db_helper.dart';
import 'package:provider_shopping/models/cart_model.dart';
import 'package:provider_shopping/provider/cart_provider.dart';
import 'package:badges/badges.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DbHelper dbHelper = DbHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Added Cart",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Badge(
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
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: [
            FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/empty.png'),
                        ),
                        Center(
                          child: Text(
                            "No items in your cart.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
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
                                        snapshot.data![index].image.toString(),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot
                                                    .data![index].productName
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  dbHelper.delete(snapshot
                                                      .data![index].id!);
                                                  cart.removeCounter();
                                                  cart.removeTotalPrice(
                                                      double.parse(
                                                    snapshot.data![index]
                                                        .productPrice
                                                        .toString(),
                                                  ));
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.orange.shade800,
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            " ${snapshot.data![index].unitTag.toString()} \$${snapshot.data![index].productPrice.toString()}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                height: 35,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.orange.shade800,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        int quantity = snapshot
                                                            .data![index]
                                                            .quantity!;
                                                        int price = snapshot
                                                            .data![index]
                                                            .initialPrice!;
                                                        quantity--;
                                                        int? newPrice =
                                                            price * quantity;

                                                        if (quantity > 0) {
                                                          dbHelper
                                                              .updateQuantity(
                                                            Cart(
                                                              id: snapshot
                                                                  .data![index]
                                                                  .id!,
                                                              productID: snapshot
                                                                  .data![index]
                                                                  .productID
                                                                  .toString(),
                                                              productName: snapshot
                                                                  .data![index]
                                                                  .productName,
                                                              initialPrice: snapshot
                                                                  .data![index]
                                                                  .initialPrice!,
                                                              productPrice:
                                                                  newPrice,
                                                              quantity:
                                                                  quantity,
                                                              unitTag: snapshot
                                                                  .data![index]
                                                                  .unitTag
                                                                  .toString(),
                                                              image: snapshot
                                                                  .data![index]
                                                                  .image
                                                                  .toString(),
                                                            ),
                                                          )
                                                              .then((value) {
                                                            newPrice = 0;
                                                            quantity = 0;
                                                            cart.removeTotalPrice(
                                                                double.parse(
                                                              snapshot
                                                                  .data![index]
                                                                  .initialPrice
                                                                  .toString(),
                                                            ));
                                                          }).onError(
                                                            (error,
                                                                stackTrace) {},
                                                          );
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data![index].quantity
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        int quantity = snapshot
                                                            .data![index]
                                                            .quantity!;
                                                        int price = snapshot
                                                            .data![index]
                                                            .initialPrice!;
                                                        quantity++;
                                                        int? newPrice =
                                                            price * quantity;

                                                        dbHelper
                                                            .updateQuantity(
                                                          Cart(
                                                            id: snapshot
                                                                .data![index]
                                                                .id!,
                                                            productID: snapshot
                                                                .data![index]
                                                                .productID
                                                                .toString(),
                                                            productName: snapshot
                                                                .data![index]
                                                                .productName,
                                                            initialPrice: snapshot
                                                                .data![index]
                                                                .initialPrice!,
                                                            productPrice:
                                                                newPrice,
                                                            quantity: quantity,
                                                            unitTag: snapshot
                                                                .data![index]
                                                                .unitTag
                                                                .toString(),
                                                            image: snapshot
                                                                .data![index]
                                                                .image
                                                                .toString(),
                                                          ),
                                                        )
                                                            .then((value) {
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.addTotalPrice(
                                                              double.parse(
                                                            snapshot
                                                                .data![index]
                                                                .initialPrice
                                                                .toString(),
                                                          ));
                                                        }).onError(
                                                          (error,
                                                              stackTrace) {},
                                                        );
                                                      },
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
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
                    // ... your existing ListView.builder code
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error fetching cart items: ${snapshot.error}"),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
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
