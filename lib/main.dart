import 'package:demo_purchase/app_purchase.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppPurchase>(lazy: false, create: (BuildContext context) => AppPurchase(),)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ids = {'sub_01','sub_day_1'};
  final List<ProductDetails> products = [];

  late final appPurchase = context.read<AppPurchase>();
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Consumer<AppPurchase>(
            builder: (BuildContext context, AppPurchase value, Widget? child) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = value.products[index];
                  print("item ${item.title}");
                  return ListTile(
                    onTap: () => appPurchase.buy(item),
                    title: Text(item.title,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.price, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.redAccent)),
                        Text(item.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => Divider(thickness: 1),
                itemCount: value.products.length,
              );
            },

          )
        ],
      ),
    );
  }

}


