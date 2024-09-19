import 'package:flutter/material.dart';

import 'auth.dart';
import 'categorie_product.dart';
import 'home.dart';

class AppDrawer extends StatelessWidget {
  final List<String>? categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const AppDrawer({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              'Categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('All'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
          if (categories != null)
            for (String category in categories!)
              ListTile(
                title: Text(category),
                onTap: () {
                  onCategorySelected(category);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryProductListPage(selectedCategory: category),
                    ),
                  );
                },
              ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
