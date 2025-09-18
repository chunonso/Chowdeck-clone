import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:redacted/redacted.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  final List<String> exploreItems = [
    'Wella Pharmacy - DRUG...',
    'Wella Pharmacy - SURE-C...',
    'MercyPaul',
    'Wella Pharmacy - Crestline',
    'Wella Pharmacy - SURE-C...',
  ];

  final List<String> featuredImages = [
    'https://via.placeholder.com/300x180',
    'https://via.placeholder.com/300x180',
  ];

  final List<Widget> promoItems = [
    Container(
      color: Colors.orange,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Get 18.25%',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 2,
            child: Image.network(
              'https://cdn.pixabay.com/photo/2023/05/15/04/44/tacos-7994117_1280.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ),
  ];

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Restaurants',
      'icon': Icons.restaurant,
      'color': Color(0xFF00B386),
    },
    {
      'title': 'Supermarkets',
      'icon': Icons.shopping_basket,
      'color': Color(0xFFFFE6E6),
    },
    {
      'title': 'Pharmacies',
      'icon': Icons.local_pharmacy,
      'color': Color(0xFFE6F0FF),
    },
    {
      'title': 'Send Packages',
      'icon': Icons.local_shipping,
      'color': Color(0xFFFFE6F0),
    },
    {'title': 'Local Markets', 'icon': Icons.store, 'color': Color(0xFFE6FFF5)},
    {'title': 'More', 'icon': Icons.more_horiz, 'color': Color(0xFFF3E6FF)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green),
                    SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                '76 Okigwe Rd, Owerri, Imo',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.local_offer_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list_alt),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => FilterOptionsSheet(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              CarouselSlider(
                items: promoItems,
                options: CarouselOptions(
                  height: 80,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.95,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                  children:
                      categories
                          .map(
                            (item) => Container(
                              decoration: BoxDecoration(
                                color: item['color'],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    item['icon'],
                                    size: 28,
                                    color: Colors.black,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    item['title'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ).redacted(context: context, redact: isLoading),
                          ) // <--- HERE
                          .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Explore',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ).redacted(context: context, redact: isLoading), // <--- HERE
              ),
              SizedBox(height: 10),
              CarouselSlider(
                options: CarouselOptions(
                  height: 100,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: false,
                  viewportFraction: 0.3,
                  autoPlay: false,
                ),
                items:
                    exploreItems
                        .map(
                          (item) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey.shade300,
                                child: Icon(
                                  Icons.local_pharmacy,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(height: 4),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 11),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ).redacted(context: context, redact: isLoading),
                        ) // <--- HERE
                        .toList(),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Featured ✨',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ).redacted(context: context, redact: isLoading), // <--- HERE
              ),
              SizedBox(height: 10),
              CarouselSlider(
                items:
                    featuredImages
                        .map(
                          (url) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ).redacted(context: context, redact: isLoading),
                        ) // <--- HERE
                        .toList(),
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black54,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Support',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class FilterOptionsSheet extends StatelessWidget {
  const FilterOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Options',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              FilterChip(label: Text('Pharmacy'), onSelected: (_) {}),
              FilterChip(label: Text('Supermarket'), onSelected: (_) {}),
              FilterChip(label: Text('Restaurant'), onSelected: (_) {}),
            ],
          ),
        ],
      ),
    );
  }
}
