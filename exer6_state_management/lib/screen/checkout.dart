import 'package:flutter/material.dart';
import '../model/Item.dart';
import 'package:provider/provider.dart';
import '../../provider/shoppingcart_provider.dart';

//Class for the checkout page
class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: 
      context.watch<ShoppingCart>().cart.isEmpty //Checks if the cart is empty or not
      ? const Center(child: Text("No items to checkout!")) //If empty
      : Column( //If not empty, it shows the items and the Pay Now button
        children: [
          getItems(context),
          computeCost(),
          Flexible(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<ShoppingCart>().removeAll(); //Resets the cart
                  ScaffoldMessenger.of(context).showSnackBar( //Prompts the user that they have successfully paid
                    const SnackBar(
                      content: Text("Payment Successful!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.popUntil(context, ModalRoute.withName("/")); //Goes back to the catalog page
                },
                child: const Text("Pay Now!")
              )
            ),
          ),
        ],
      )
    );
  }

  Widget getItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    return products.isEmpty
        ? const Text('No Items yet!')
        : Expanded(
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(products[index].name),
                        trailing: Text(products[index].price.toString()),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget computeCost() {
    return Consumer<ShoppingCart>(
      builder: (context, cart, child) {
        return Text("Total Cost to Pay: ${cart.cartTotal}");
      },
    );
  }

}