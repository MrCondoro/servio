// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';

/// Seeds the Firestore database with complete MVP data for Servio POS presentation.
/// Runs only once — skips if restaurant document already exists.
class FirebaseSeeder {
  static final _db = FirebaseFirestore.instance;

  static Future<void> seedIfNeeded() async {
    try {
      final restaurantRef = _db.collection('restaurants').doc('bella_vista');
      final snap = await restaurantRef.get();
      if (snap.exists) {
        print('[Seeder] DB already seeded — skipping.');
        return;
      }
      print('[Seeder] Seeding Firebase database...');
      await _seedAll(restaurantRef);
      print('[Seeder] ✅ Database seeded successfully!');
    } catch (e) {
      print('[Seeder] ❌ Seed error: $e');
    }
  }

  static Future<void> _seedAll(DocumentReference restaurantRef) async {
    final batch1 = _db.batch();
    final batch2 = _db.batch();

    // ── 1. Restaurant ─────────────────────────────────────────────────────────
    batch1.set(restaurantRef, {
      'name': 'Bella Vista',
      'tagline': 'Fine Dining & Café',
      'email': 'contact@bellavista.com',
      'phone': '+212 600 123 456',
      'address': '14 Rue Mohamed V, Casablanca',
      'logoUrl': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      'coverUrl': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=1200',
      'currency': 'USD',
      'taxRate': 8.0,
      'timezone': 'Africa/Casablanca',
      'openingHours': {
        'Monday':    {'open': '09:00', 'close': '23:00', 'enabled': true},
        'Tuesday':   {'open': '09:00', 'close': '23:00', 'enabled': true},
        'Wednesday': {'open': '09:00', 'close': '23:00', 'enabled': true},
        'Thursday':  {'open': '09:00', 'close': '23:00', 'enabled': true},
        'Friday':    {'open': '09:00', 'close': '00:00', 'enabled': true},
        'Saturday':  {'open': '10:00', 'close': '00:00', 'enabled': true},
        'Sunday':    {'open': '10:00', 'close': '22:00', 'enabled': false},
      },
      'serviceTypes': ['Dine-In', 'Takeaway', 'Delivery'],
      'tables': 12,
      'employees': 8,
      'plan': 'Pro',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // ── 2. Categories ─────────────────────────────────────────────────────────
    final cats = [
      {'id': 'cat_pizza',    'name': 'Pizza',    'emoji': '🍕', 'color': 'FF6B35', 'order': 1},
      {'id': 'cat_burgers',  'name': 'Burgers',  'emoji': '🍔', 'color': 'E63946', 'order': 2},
      {'id': 'cat_pasta',    'name': 'Pasta',    'emoji': '🍝', 'color': 'F4A261', 'order': 3},
      {'id': 'cat_salads',   'name': 'Salads',   'emoji': '🥗', 'color': '2A9D8F', 'order': 4},
      {'id': 'cat_drinks',   'name': 'Drinks',   'emoji': '🍹', 'color': '4361EE', 'order': 5},
      {'id': 'cat_desserts', 'name': 'Desserts', 'emoji': '🍰', 'color': 'E040FB', 'order': 6},
      {'id': 'cat_snacks',   'name': 'Snacks',   'emoji': '🍟', 'color': 'FFBE0B', 'order': 7},
    ];

    for (final cat in cats) {
      final ref = restaurantRef.collection('categories').doc(cat['id'] as String);
      batch1.set(ref, {...cat, 'restaurantId': 'bella_vista', 'createdAt': FieldValue.serverTimestamp()});
    }

    // ── 3. Menu Items ─────────────────────────────────────────────────────────
    final items = [
      // Pizza
      {'id': 'item_001', 'categoryId': 'cat_pizza', 'name': 'Margherita Pizza', 'description': 'San Marzano tomato, fresh mozzarella, basil oil', 'price': 12.50, 'image': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400', 'rating': 4.9, 'prep': 15, 'available': true, 'featured': true},
      {'id': 'item_002', 'categoryId': 'cat_pizza', 'name': 'Pepperoni Pizza', 'description': 'Double pepperoni, spicy tomato, aged cheddar', 'price': 14.50, 'image': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400', 'rating': 4.8, 'prep': 18, 'available': true, 'featured': true},
      {'id': 'item_003', 'categoryId': 'cat_pizza', 'name': 'BBQ Chicken Pizza', 'description': 'Smoky BBQ base, grilled chicken, red onion', 'price': 15.00, 'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400', 'rating': 4.7, 'prep': 18, 'available': true, 'featured': false},
      {'id': 'item_004', 'categoryId': 'cat_pizza', 'name': 'Quattro Formaggi', 'description': 'Mozzarella, gorgonzola, parmesan, ricotta', 'price': 16.00, 'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400', 'rating': 4.6, 'prep': 20, 'available': true, 'featured': false},

      // Burgers
      {'id': 'item_005', 'categoryId': 'cat_burgers', 'name': 'Classic Cheese Burger', 'description': 'Angus beef patty, cheddar, lettuce, pickles, special sauce', 'price': 10.25, 'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400', 'rating': 4.8, 'prep': 12, 'available': true, 'featured': true},
      {'id': 'item_006', 'categoryId': 'cat_burgers', 'name': 'Chicken Wings (8 pcs)', 'description': 'Crispy wings, choice of buffalo or BBQ sauce', 'price': 9.25, 'image': 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=400', 'rating': 4.7, 'prep': 15, 'available': true, 'featured': false},
      {'id': 'item_007', 'categoryId': 'cat_burgers', 'name': 'Double Smash Burger', 'description': 'Double smash patty, American cheese, caramelized onion', 'price': 13.50, 'image': 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=400', 'rating': 4.9, 'prep': 14, 'available': true, 'featured': true},

      // Pasta
      {'id': 'item_008', 'categoryId': 'cat_pasta', 'name': 'Spaghetti Bolognese', 'description': 'Slow-cooked beef ragù, al dente spaghetti, parmesan', 'price': 11.00, 'image': 'https://images.unsplash.com/photo-1622973536968-3ead9e780960?w=400', 'rating': 4.8, 'prep': 20, 'available': true, 'featured': true},
      {'id': 'item_009', 'categoryId': 'cat_pasta', 'name': 'Penne Arrabiata', 'description': 'Spicy San Marzano sauce, garlic, fresh basil', 'price': 9.50, 'image': 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=400', 'rating': 4.5, 'prep': 15, 'available': true, 'featured': false},
      {'id': 'item_010', 'categoryId': 'cat_pasta', 'name': 'Truffle Carbonara', 'description': 'Guanciale, egg yolk, pecorino, black truffle shavings', 'price': 16.50, 'image': 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400', 'rating': 4.9, 'prep': 18, 'available': true, 'featured': true},

      // Salads
      {'id': 'item_011', 'categoryId': 'cat_salads', 'name': 'Caesar Salad', 'description': 'Crispy romaine, house dressing, anchovy croutons, parmesan', 'price': 8.75, 'image': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400', 'rating': 4.6, 'prep': 8, 'available': true, 'featured': false},
      {'id': 'item_012', 'categoryId': 'cat_salads', 'name': 'Greek Salad', 'description': 'Tomato, cucumber, olives, red onion, feta, oregano', 'price': 7.50, 'image': 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400', 'rating': 4.5, 'prep': 6, 'available': true, 'featured': false},

      // Drinks
      {'id': 'item_013', 'categoryId': 'cat_drinks', 'name': 'Classic Mojito', 'description': 'White rum, fresh mint, lime, sugar, sparkling water', 'price': 5.75, 'image': 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', 'rating': 4.8, 'prep': 5, 'available': true, 'featured': true},
      {'id': 'item_014', 'categoryId': 'cat_drinks', 'name': 'Fresh Lemonade', 'description': 'Freshly squeezed lemons, mint, honey syrup', 'price': 4.00, 'image': 'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=400', 'rating': 4.7, 'prep': 5, 'available': true, 'featured': false},
      {'id': 'item_015', 'categoryId': 'cat_drinks', 'name': 'Cappuccino', 'description': 'Double espresso, steamed milk, rich foam art', 'price': 3.50, 'image': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400', 'rating': 4.9, 'prep': 4, 'available': true, 'featured': true},

      // Desserts
      {'id': 'item_016', 'categoryId': 'cat_desserts', 'name': 'Chocolate Lava Cake', 'description': 'Warm dark chocolate center, vanilla ice cream', 'price': 6.50, 'image': 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=400', 'rating': 4.9, 'prep': 12, 'available': true, 'featured': true},
      {'id': 'item_017', 'categoryId': 'cat_desserts', 'name': 'Tiramisu', 'description': 'Espresso-soaked ladyfingers, mascarpone, cocoa dusting', 'price': 7.00, 'image': 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400', 'rating': 4.8, 'prep': 5, 'available': true, 'featured': false},

      // Snacks
      {'id': 'item_018', 'categoryId': 'cat_snacks', 'name': 'Crispy French Fries', 'description': 'Golden fries, seasoned with sea salt & rosemary', 'price': 4.25, 'image': 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400', 'rating': 4.7, 'prep': 8, 'available': true, 'featured': false},
      {'id': 'item_019', 'categoryId': 'cat_snacks', 'name': 'Garlic Bread', 'description': 'Toasted sourdough, garlic butter, fresh parsley', 'price': 3.50, 'image': 'https://images.unsplash.com/photo-1619535860434-cf9b902b2e2e?w=400', 'rating': 4.6, 'prep': 6, 'available': true, 'featured': false},
      {'id': 'item_020', 'categoryId': 'cat_snacks', 'name': 'Calamari Fritti', 'description': 'Crispy squid rings, marinara dip, lemon', 'price': 8.50, 'image': 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400', 'rating': 4.6, 'prep': 10, 'available': true, 'featured': false},
    ];

    // Split items across two batches (Firestore limit = 500 ops/batch)
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final ref = restaurantRef.collection('menuItems').doc(item['id'] as String);
      final data = {...item, 'restaurantId': 'bella_vista', 'createdAt': FieldValue.serverTimestamp()};
      if (i < 10) {
        batch1.set(ref, data);
      } else {
        batch2.set(ref, data);
      }
    }

    // ── 4. Tables ─────────────────────────────────────────────────────────────
    final tables = [
      {'id': 'tbl_01', 'name': '1',  'zone': 'Main',  'capacity': 4, 'status': 'available'},
      {'id': 'tbl_02', 'name': '2',  'zone': 'Main',  'capacity': 2, 'status': 'occupied'},
      {'id': 'tbl_03', 'name': '3',  'zone': 'Main',  'capacity': 6, 'status': 'reserved'},
      {'id': 'tbl_04', 'name': '4',  'zone': 'Main',  'capacity': 4, 'status': 'available'},
      {'id': 'tbl_05', 'name': '5',  'zone': 'Main',  'capacity': 8, 'status': 'occupied'},
      {'id': 'tbl_06', 'name': '6',  'zone': 'Main',  'capacity': 4, 'status': 'available'},
      {'id': 'tbl_07', 'name': '7',  'zone': 'Main',  'capacity': 2, 'status': 'reserved'},
      {'id': 'tbl_08', 'name': '8',  'zone': 'Main',  'capacity': 4, 'status': 'available'},
      {'id': 'tbl_09', 'name': '9',  'zone': 'Patio', 'capacity': 4, 'status': 'available'},
      {'id': 'tbl_10', 'name': '10', 'zone': 'Patio', 'capacity': 6, 'status': 'occupied'},
      {'id': 'tbl_11', 'name': '11', 'zone': 'Patio', 'capacity': 4, 'status': 'available'},
      {'id': 'tbl_12', 'name': '12', 'zone': 'VIP',   'capacity': 8, 'status': 'reserved'},
    ];

    for (final t in tables) {
      batch2.set(restaurantRef.collection('tables').doc(t['id'] as String), {
        ...t, 'restaurantId': 'bella_vista', 'createdAt': FieldValue.serverTimestamp()
      });
    }

    // ── 5. Employees ──────────────────────────────────────────────────────────
    final employees = [
      {'id': 'emp_01', 'name': 'Ahmed Khalil',   'role': 'Manager',  'email': 'ahmed@bellavista.com',   'phone': '+212 600 001 001', 'status': 'Active',   'shift': 'Morning', 'avatar': 'https://i.pravatar.cc/150?img=11'},
      {'id': 'emp_02', 'name': 'Sara Mansour',   'role': 'Cashier',  'email': 'sara@bellavista.com',    'phone': '+212 600 001 002', 'status': 'Active',   'shift': 'Morning', 'avatar': 'https://i.pravatar.cc/150?img=20'},
      {'id': 'emp_03', 'name': 'Omar Belhaj',    'role': 'Waiter',   'email': 'omar@bellavista.com',    'phone': '+212 600 001 003', 'status': 'Active',   'shift': 'Evening', 'avatar': 'https://i.pravatar.cc/150?img=15'},
      {'id': 'emp_04', 'name': 'Layla Rami',     'role': 'Chef',     'email': 'layla@bellavista.com',   'phone': '+212 600 001 004', 'status': 'On Leave', 'shift': 'Morning', 'avatar': 'https://i.pravatar.cc/150?img=25'},
      {'id': 'emp_05', 'name': 'Youssef Tazi',   'role': 'Waiter',   'email': 'youssef@bellavista.com', 'phone': '+212 600 001 005', 'status': 'Active',   'shift': 'Evening', 'avatar': 'https://i.pravatar.cc/150?img=8'},
      {'id': 'emp_06', 'name': 'Nadia Hajji',    'role': 'Hostess',  'email': 'nadia@bellavista.com',   'phone': '+212 600 001 006', 'status': 'Active',   'shift': 'Morning', 'avatar': 'https://i.pravatar.cc/150?img=30'},
      {'id': 'emp_07', 'name': 'Karim Douiri',   'role': 'Bartender','email': 'karim@bellavista.com',   'phone': '+212 600 001 007', 'status': 'Active',   'shift': 'Evening', 'avatar': 'https://i.pravatar.cc/150?img=12'},
      {'id': 'emp_08', 'name': 'Fatima Lahlou',  'role': 'Cashier',  'email': 'fatima@bellavista.com',  'phone': '+212 600 001 008', 'status': 'Inactive', 'shift': 'Morning', 'avatar': 'https://i.pravatar.cc/150?img=47'},
    ];

    for (final e in employees) {
      batch2.set(restaurantRef.collection('employees').doc(e['id'] as String), {
        ...e, 'restaurantId': 'bella_vista', 'createdAt': FieldValue.serverTimestamp()
      });
    }

    // ── 6. Orders ─────────────────────────────────────────────────────────────
    final orders = [
      {'id': 'ord_1042', 'orderNumber': '#1042', 'tableId': 'tbl_03', 'tableName': 'Table 3', 'type': 'Dine-In',  'customerId': 'cust_01', 'customerName': 'Ahmed K.', 'status': 'Pending',   'items': [{'itemId': 'item_001', 'name': 'Margherita Pizza', 'qty': 2, 'price': 12.50}, {'itemId': 'item_013', 'name': 'Classic Mojito', 'qty': 2, 'price': 5.75}], 'subtotal': 36.50, 'tax': 2.92, 'total': 39.42, 'waiter': 'Omar Belhaj'},
      {'id': 'ord_1041', 'orderNumber': '#1041', 'tableId': 'tbl_02', 'tableName': 'Table 7', 'type': 'Dine-In',  'customerId': 'cust_02', 'customerName': 'Sara M.',  'status': 'Preparing', 'items': [{'itemId': 'item_005', 'name': 'Classic Cheese Burger', 'qty': 1, 'price': 10.25}, {'itemId': 'item_018', 'name': 'Crispy French Fries', 'qty': 1, 'price': 4.25}], 'subtotal': 14.50, 'tax': 1.16, 'total': 15.66, 'waiter': 'Youssef Tazi'},
      {'id': 'ord_1040', 'orderNumber': '#1040', 'tableId': null,     'tableName': 'Takeaway', 'type': 'Takeaway', 'customerId': 'cust_03', 'customerName': 'Omar B.',  'status': 'Ready',     'items': [{'itemId': 'item_007', 'name': 'Double Smash Burger', 'qty': 1, 'price': 13.50}, {'itemId': 'item_015', 'name': 'Cappuccino', 'qty': 1, 'price': 3.50}, {'itemId': 'item_019', 'name': 'Garlic Bread', 'qty': 1, 'price': 3.50}], 'subtotal': 20.50, 'tax': 1.64, 'total': 22.14, 'waiter': 'Sara Mansour'},
      {'id': 'ord_1039', 'orderNumber': '#1039', 'tableId': 'tbl_01', 'tableName': 'Table 1', 'type': 'Dine-In',  'customerId': 'cust_04', 'customerName': 'Layla R.', 'status': 'Completed', 'items': [{'itemId': 'item_010', 'name': 'Truffle Carbonara', 'qty': 2, 'price': 16.50}, {'itemId': 'item_016', 'name': 'Chocolate Lava Cake', 'qty': 2, 'price': 6.50}, {'itemId': 'item_014', 'name': 'Fresh Lemonade', 'qty': 2, 'price': 4.00}], 'subtotal': 54.00, 'tax': 4.32, 'total': 58.32, 'waiter': 'Omar Belhaj'},
      {'id': 'ord_1038', 'orderNumber': '#1038', 'tableId': null,     'tableName': 'Delivery', 'type': 'Delivery', 'customerId': 'cust_05', 'customerName': 'Youssef T.','status': 'Cancelled', 'items': [{'itemId': 'item_002', 'name': 'Pepperoni Pizza', 'qty': 1, 'price': 14.50}, {'itemId': 'item_013', 'name': 'Classic Mojito', 'qty': 1, 'price': 5.75}], 'subtotal': 20.25, 'tax': 1.62, 'total': 21.87, 'waiter': 'Fatima Lahlou'},
    ];

    for (final o in orders) {
      batch2.set(restaurantRef.collection('orders').doc(o['id'] as String), {
        ...o, 'restaurantId': 'bella_vista',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // ── 7. Customers ──────────────────────────────────────────────────────────
    final customers = [
      {'id': 'cust_01', 'name': 'Ahmed Khalil',  'email': 'ahmed.k@gmail.com',   'phone': '+212 611 000 001', 'visits': 12, 'totalSpent': 284.50, 'avatar': 'https://i.pravatar.cc/150?img=11', 'loyaltyPoints': 284},
      {'id': 'cust_02', 'name': 'Sara Mansour',  'email': 'sara.m@gmail.com',    'phone': '+212 611 000 002', 'visits': 8,  'totalSpent': 176.80, 'avatar': 'https://i.pravatar.cc/150?img=20', 'loyaltyPoints': 176},
      {'id': 'cust_03', 'name': 'Omar Belhaj',   'email': 'omar.b@gmail.com',    'phone': '+212 611 000 003', 'visits': 5,  'totalSpent': 98.75,  'avatar': 'https://i.pravatar.cc/150?img=15', 'loyaltyPoints': 98},
      {'id': 'cust_04', 'name': 'Layla Rami',    'email': 'layla.r@gmail.com',   'phone': '+212 611 000 004', 'visits': 22, 'totalSpent': 512.30, 'avatar': 'https://i.pravatar.cc/150?img=25', 'loyaltyPoints': 512},
      {'id': 'cust_05', 'name': 'Youssef Tazi',  'email': 'youssef.t@gmail.com', 'phone': '+212 611 000 005', 'visits': 3,  'totalSpent': 62.40,  'avatar': 'https://i.pravatar.cc/150?img=8',  'loyaltyPoints': 62},
      {'id': 'cust_06', 'name': 'Nadia Hajji',   'email': 'nadia.h@gmail.com',   'phone': '+212 611 000 006', 'visits': 15, 'totalSpent': 340.00, 'avatar': 'https://i.pravatar.cc/150?img=30', 'loyaltyPoints': 340},
    ];

    for (final c in customers) {
      batch2.set(restaurantRef.collection('customers').doc(c['id'] as String), {
        ...c, 'restaurantId': 'bella_vista', 'createdAt': FieldValue.serverTimestamp()
      });
    }

    // ── 8. Dashboard metrics ──────────────────────────────────────────────────
    batch2.set(restaurantRef.collection('metrics').doc('today'), {
      'date': DateTime.now().toIso8601String().substring(0, 10),
      'totalRevenue': 3847.50,
      'totalOrders': 84,
      'avgOrderValue': 45.80,
      'tableOccupancy': 0.75,
      'topItems': ['Margherita Pizza', 'Truffle Carbonara', 'Double Smash Burger', 'Chocolate Lava Cake', 'Classic Mojito'],
      'revenueByHour': {
        '09': 120.0, '10': 245.0, '11': 380.0, '12': 620.0,
        '13': 780.0, '14': 540.0, '15': 310.0, '16': 285.0,
        '17': 230.0, '18': 180.0, '19': 450.0, '20': 620.0,
        '21': 580.0, '22': 420.0, '23': 280.0,
      },
      'restaurantId': 'bella_vista',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // ── Commit ────────────────────────────────────────────────────────────────
    await batch1.commit();
    await batch2.commit();
  }
}
