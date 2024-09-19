import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'auth.dart';
import 'home.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<Map<String, dynamic>> cartDetailsFuture;
  late Map<int, Map<String, dynamic>> productsInfo = {};
  int _currentIndex = 2;

  Future<void> onTabTapped(int index) async {
    if (index == 1) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>HomePage(),
        ),
      );
    } else if (index == 2) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            );
          }
      }


  @override
  void initState() {
    super.initState();
    cartDetailsFuture = _fetchCartDetails();
  }

  Future<Map<String, dynamic>> _fetchCartDetails() async {
    try {
      final response = await http.get(
          Uri.parse('https://fakestoreapi.com/carts/1'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load cart details');
      }
    } catch (e) {
      print('Error fetching cart details: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> _fetchProductDetails(int productId) async {
    try {
      final response = await http.get(
          Uri.parse('https://fakestoreapi.com/products/$productId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      print('Error fetching product details: $e');
      return {};
    }
  }

  double calculateTotalPrice(List<Map<String, dynamic>> products) {
    double total = 0.0;
    for (var product in products) {
      final int quantity = product['quantity'] ?? 0;
      final double price = (productsInfo[product['productId']]?['price'] ?? 0.0) * quantity;
      total += price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<Map<String, dynamic>>(
                  future: cartDetailsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final Map<String, dynamic> cartDetails = snapshot.data!;
                      final List<Map<String, dynamic>> products =
                      List<Map<String, dynamic>>.from(cartDetails['products']);

                      return Text(
                        'Total: \$${calculateTotalPrice(products)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthPage(),
                        ),
                      );
                    },
                  child: Text('Checkout',style: TextStyle(color: Colors.black)),
                ),

              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: cartDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final Map<String, dynamic> cartDetails = snapshot.data!;
            final List<Map<String, dynamic>> products =
            List<Map<String, dynamic>>.from(cartDetails['products']);

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final int productId = product['productId'];

                if (!productsInfo.containsKey(productId)) {
                  _fetchProductDetails(productId).then((productDetails) {
                    setState(() {
                      productsInfo[productId] = productDetails;
                    });
                  });
                }

                final Map<String, dynamic>? productInfo =
                productsInfo[productId];

                int quantity = product['quantity'] ?? 0;

                return Card(
                  margin: EdgeInsets.all(8),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: GestureDetector(
                      onTap: () {
                      },
                      child: Image.network(
                        productInfo?['image'] ?? 'Loading...',
                        width: 80,
                        height: 50,
                      ),
                    ),
                    title: Text(
                      productInfo?['title'] ?? 'Loading...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: \$${productInfo?['price'] ?? 'Loading...'}',
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() {
                                    product['quantity'] = quantity - 1;
                                  });
                                }
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  product['quantity'] = quantity + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}
