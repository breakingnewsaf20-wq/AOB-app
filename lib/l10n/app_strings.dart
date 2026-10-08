import 'package:flutter/material.dart';

class AppStrings {
  static const supportedLocales = [Locale('ps'), Locale('fa'), Locale('en')];

  static const Map<String, Map<String, String>> _data = {
    'ps': {
      'appName': 'افغان آنلاین بازار', 'login': 'ننوتل', 'register': 'حساب جوړول',
      'logout': 'وتل', 'email': 'برېښنالیک', 'password': 'پټ نوم', 'name': 'نوم',
      'home': 'کور', 'seller': 'پلورونکی', 'sellerDashboard': 'د پلورونکي پینل',
      'admin': 'ادمین', 'adminPanel': 'د ادمین پینل', 'language': 'ژبه',
      'pashto': 'پښتو', 'dari': 'دري', 'english': 'English', 'newAccount': 'نوی حساب جوړول',
      'accountType': 'د حساب ډول', 'customer': 'پېرودونکی', 'save': 'ساتل', 'cancel': 'لغوه',
      'newProduct': 'نوی محصول', 'productName': 'د محصول نوم', 'description': 'توضیحات',
      'price': 'قیمت', 'stock': 'موجودي', 'city': 'ښار', 'category': 'کټګوري',
      'noProducts': 'تر اوسه محصول نشته.', 'approved': 'منظور شوی', 'pending': 'د تایید په تمه',
      'management': 'مدیریت', 'users': 'کاروونکي', 'products': 'محصولات', 'orders': 'سفارشونه',
      'pleaseWait': 'مهرباني وکړئ...', 'loginFailed': 'ننوتل ناکام شول',
      'registerFailed': 'ثبت ناکام شو', 'fillRequired': 'اړین معلومات بشپړ کړئ',
      'selectLanguage': 'ژبه وټاکئ', 'marketplace': 'بازار', 'settings': 'تنظیمات', 'pendingProducts': 'د تایید په تمه محصولات', 'noPendingProducts': 'د تایید لپاره محصول نشته.', 'approve': 'تایید', 'favorites': 'خوښ شوي', 'cart': 'سبد', 'addToCart': 'سبد ته واچوه', 'checkout': 'سفارش تایید کړه', 'deliveryFee': 'د سپارلو فیس', 'address': 'پته', 'phone': 'د اړیکې شمېره', 'status': 'حالت', 'search': 'لټون', 'imageUpload': 'عکس پورته کول', 'aiAssistant': 'AI مرستیال', 'cartEmpty': 'سبد خالي دی.', 'subtotal': 'ټولیزه بیه', 'orderCreated': 'سفارش ثبت شو.',
    },
    'fa': {
      'appName': 'بازار آنلاین افغان', 'login': 'ورود', 'register': 'ساخت حساب',
      'logout': 'خروج', 'email': 'ایمیل', 'password': 'رمز عبور', 'name': 'نام',
      'home': 'خانه', 'seller': 'فروشنده', 'sellerDashboard': 'پنل فروشنده',
      'admin': 'مدیر', 'adminPanel': 'پنل مدیریت', 'language': 'زبان',
      'pashto': 'پښتو', 'dari': 'دری', 'english': 'English', 'newAccount': 'ساخت حساب جدید',
      'accountType': 'نوع حساب', 'customer': 'خریدار', 'save': 'ذخیره', 'cancel': 'لغو',
      'newProduct': 'محصول جدید', 'productName': 'نام محصول', 'description': 'توضیحات',
      'price': 'قیمت', 'stock': 'موجودی', 'city': 'شهر', 'category': 'دسته‌بندی',
      'noProducts': 'هنوز محصولی وجود ندارد.', 'approved': 'تایید شده', 'pending': 'در انتظار تایید',
      'management': 'مدیریت', 'users': 'کاربران', 'products': 'محصولات', 'orders': 'سفارش‌ها',
      'pleaseWait': 'لطفاً صبر کنید...', 'loginFailed': 'ورود ناموفق بود',
      'registerFailed': 'ثبت نام ناموفق بود', 'fillRequired': 'معلومات ضروری را تکمیل کنید',
      'selectLanguage': 'زبان را انتخاب کنید', 'marketplace': 'بازار', 'settings': 'تنظیمات', 'pendingProducts': 'محصولات در انتظار تایید', 'noPendingProducts': 'محصولی برای تایید نیست.', 'approve': 'تایید', 'favorites': 'علاقه‌مندی‌ها', 'cart': 'سبد', 'addToCart': 'افزودن به سبد', 'checkout': 'تایید سفارش', 'deliveryFee': 'هزینه تحویل', 'address': 'آدرس', 'phone': 'شماره تماس', 'status': 'وضعیت', 'search': 'جستجو', 'imageUpload': 'آپلود عکس', 'aiAssistant': 'دستیار هوش مصنوعی', 'cartEmpty': 'سبد خالی است.', 'subtotal': 'مجموع', 'orderCreated': 'سفارش ثبت شد.',
    },
    'en': {
      'appName': 'Afghan Online Bazaar', 'login': 'Login', 'register': 'Create account',
      'logout': 'Logout', 'email': 'Email', 'password': 'Password', 'name': 'Name',
      'home': 'Home', 'seller': 'Seller', 'sellerDashboard': 'Seller Dashboard',
      'admin': 'Admin', 'adminPanel': 'Admin Panel', 'language': 'Language',
      'pashto': 'Pashto', 'dari': 'Dari', 'english': 'English', 'newAccount': 'Create new account',
      'accountType': 'Account type', 'customer': 'Customer', 'save': 'Save', 'cancel': 'Cancel',
      'newProduct': 'New product', 'productName': 'Product name', 'description': 'Description',
      'price': 'Price', 'stock': 'Stock', 'city': 'City', 'category': 'Category',
      'noProducts': 'No products yet.', 'approved': 'Approved', 'pending': 'Pending approval',
      'management': 'Management', 'users': 'Users', 'products': 'Products', 'orders': 'Orders',
      'pleaseWait': 'Please wait...', 'loginFailed': 'Login failed',
      'registerFailed': 'Registration failed', 'fillRequired': 'Please complete required fields',
      'selectLanguage': 'Select language', 'marketplace': 'Marketplace', 'settings': 'Settings', 'pendingProducts': 'Pending products', 'noPendingProducts': 'No products waiting for approval.', 'approve': 'Approve', 'favorites': 'Favorites', 'cart': 'Cart', 'addToCart': 'Add to cart', 'checkout': 'Confirm order', 'deliveryFee': 'Delivery fee', 'address': 'Address', 'phone': 'Phone', 'status': 'Status', 'search': 'Search', 'imageUpload': 'Upload image', 'aiAssistant': 'AI assistant', 'cartEmpty': 'Your cart is empty.', 'subtotal': 'Subtotal', 'orderCreated': 'Order created.',
    },
  };

  static String t(Locale locale, String key) => _data[locale.languageCode]?[key] ?? _data['en']![key] ?? key;
}

class LanguageScope extends InheritedWidget {
  final Locale locale;
  final ValueChanged<Locale> onChanged;
  const LanguageScope({super.key, required this.locale, required this.onChanged, required super.child});

  static LanguageScope of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<LanguageScope>()!;
  String tr(String key) => AppStrings.t(locale, key);
  @override bool updateShouldNotify(LanguageScope oldWidget) => oldWidget.locale != locale;
}
