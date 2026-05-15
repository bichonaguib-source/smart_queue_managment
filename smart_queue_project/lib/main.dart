import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_queue/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HagzyTicketApp());
}

// ===================== ENUMS & LOCALIZATION =====================

enum AppLanguage { english, arabic }

String tr(AppLanguage language, String english, String arabic) {
  return language == AppLanguage.arabic ? arabic : english;
}

String localizeTerm(AppLanguage language, String value) {
  if (language == AppLanguage.english) return value;
  return _arabicTerms[value] ?? value;
}

const Map<String, String> _arabicTerms = {
  'Hagzyticket': 'حجزي تكت',
  'Bank': 'بنوك',
  'Hospital': 'مستشفيات',
  'Government Offices': 'مكاتب حكومية',
  'Airlines': 'شركات الطيران',
  'National Bank of Egypt': 'البنك الأهلي المصري',
  'Banque Misr': 'بنك مصر',
  'Commercial International Bank (CIB)': 'البنك التجاري الدولي',
  'Arab African International Bank': 'البنك العربي الأفريقي الدولي',
  'Arab Bank': 'البنك العربي',
  'Housing and Development Bank': 'بنك التعمير والإسكان',
  'Bank of Alexandria': 'بنك الإسكندرية',
  'QNB Alahli': 'بنك QNB الأهلي',
  'Faisal Islamic Bank of Egypt': 'بنك فيصل الإسلامي المصري',
  'Abu Dhabi Islamic Bank Egypt (ADIB)': 'مصرف أبوظبي الإسلامي مصر',
  'Egyptian Gulf Bank': 'البنك المصري الخليجي',
  'Crédit Agricole Egypt': 'كريدي أجريكول مصر',
  'HSBC Egypt': 'بنك HSBC مصر',
  'SAIB Bank': 'بنك SAIB',
  'Al Baraka Bank Egypt': 'بنك البركة مصر',
  'MID Bank': 'بنك MID',
  'Attijariwafa Bank Egypt': 'بنك التجاري وفا مصر',
  'Kasr Al Ainy Hospital': 'مستشفى قصر العيني',
  'Ain Shams Specialized Hospital': 'مستشفى عين شمس التخصصي',
  'El Shorouk Hospital': 'مستشفى الشروق',
  'Cairo University Specialized Hospital': 'المستشفى التخصصي بجامعة القاهرة',
  'Nasser Institute Hospital': 'مستشفى معهد ناصر',
  'El Demerdash Hospital': 'مستشفى الدمرداش',
  'Dar Al Fouad Hospital': 'مستشفى دار الفؤاد',
  '57357 Children Cancer Hospital': 'مستشفى 57357 لعلاج سرطان الأطفال',
  'As-Salam International Hospital': 'مستشفى السلام الدولي',
  'Alexandria Main University Hospital': 'المستشفى الجامعي الرئيسي بالإسكندرية',
  'El Miri Hospital Alexandria': 'مستشفى الميري بالإسكندرية',
  'Gamal Abdel Nasser Hospital': 'مستشفى جمال عبد الناصر',
  'Sharq El Madina Hospital': 'مستشفى شرق المدينة',
  'Andalusia Smouha Hospital': 'مستشفى أندلسية سموحة',
  'Saudi German Hospital Alexandria': 'المستشفى السعودي الألماني بالإسكندرية',
  'Abbassia Civil Registry': 'السجل المدني بالعباسية',
  'Nasr City Traffic Unit': 'وحدة مرور مدينة نصر',
  'Cairo Passport and Immigration Complex': 'مجمع الجوازات والهجرة بالقاهرة',
  'Cairo Real Estate Registry': 'الشهر العقاري بالقاهرة',
  'Cairo Notary Public Office': 'مكتب التوثيق بالقاهرة',
  'Alexandria Civil Registry - Sidi Gaber':
      'السجل المدني بالإسكندرية - سيدي جابر',
  'Alexandria Traffic Unit - Montaza': 'وحدة مرور الإسكندرية - المنتزه',
  'Alexandria Passport Office': 'مكتب جوازات الإسكندرية',
  'Alexandria Real Estate Registry': 'الشهر العقاري بالإسكندرية',
  'Tax Office - Cairo Downtown': 'مأمورية الضرائب - وسط القاهرة',
  'Tax Office - Alexandria East': 'مأمورية الضرائب - شرق الإسكندرية',
  'EgyptAir Service Center': 'مركز خدمة مصر للطيران',
  'Cairo Airport Booking Office': 'مكتب حجز مطار القاهرة',
  'Air Cairo': 'إير كايرو',
  'Nile Air': 'نايل إير',
  'Nesma Airlines': 'نسما للطيران',
  'Turkish Airlines Egypt Office': 'مكتب الخطوط التركية - مصر',
  'Emirates Egypt Office': 'مكتب طيران الإمارات - مصر',
  'Qatar Airways Egypt Office': 'مكتب الخطوط القطرية - مصر',
  'Saudia Egypt Office': 'مكتب الخطوط السعودية - مصر',
  'Flydubai Egypt Office': 'مكتب فلاي دبي - مصر',
  'Lufthansa Egypt Office': 'مكتب لوفتهانزا - مصر',
  'Royal Jordanian Egypt Office': 'مكتب الملكية الأردنية - مصر',
  'Account Opening': 'فتح حساب',
  'Cash Deposit': 'إيداع نقدي',
  'Loan Consultation': 'استشارة قرض',
  'Card Services': 'خدمات البطاقات',
  'ATM Card Renewal': 'تجديد بطاقة الصراف',
  'Money Transfer': 'تحويل أموال',
  'Customer Service': 'خدمة العملاء',
  'New Account': 'حساب جديد',
  'Open Current Account': 'فتح حساب جاري',
  'Personal Loan': 'قرض شخصي',
  'Credit Card Services': 'خدمات بطاقات الائتمان',
  'Corporate Account': 'حساب شركات',
  'International Transfer': 'تحويل دولي',
  'Loan Inquiry': 'استعلام عن قرض',
  'Account Update': 'تحديث الحساب',
  'Savings Certificate': 'شهادة ادخار',
  'Wire Transfer': 'حوالة بنكية',
  'Mortgage Services': 'خدمات التمويل العقاري',
  'Installment Inquiry': 'استعلام أقساط',
  'Retail Banking': 'خدمات التجزئة المصرفية',
  'Card Replacement': 'استبدال بطاقة',
  'Customer Support': 'دعم العملاء',
  'Open Savings Account': 'فتح حساب توفير',
  'Card Activation': 'تفعيل بطاقة',
  'Loan Follow-up': 'متابعة قرض',
  'Islamic Financing': 'تمويل إسلامي',
  'Deposit Services': 'خدمات الإيداع',
  'Murabaha Financing': 'تمويل مرابحة',
  'Current Account': 'حساب جاري',
  'Digital Banking Support': 'دعم الخدمات البنكية الرقمية',
  'Open Account': 'فتح حساب',
  'Investment Products': 'منتجات استثمارية',
  'Credit Card Request': 'طلب بطاقة ائتمان',
  'Premier Services': 'خدمات بريميير',
  'International Banking': 'الخدمات البنكية الدولية',
  'Certificate Purchase': 'شراء شهادة',
  'Transfer Services': 'خدمات التحويل',
  'Islamic Banking': 'خدمات مصرفية إسلامية',
  'Investment Accounts': 'حسابات استثمارية',
  'Corporate Services': 'خدمات الشركات',
  'SME Financing': 'تمويل المشروعات الصغيرة والمتوسطة',
  'Transfers': 'تحويلات',
  'General Clinic': 'عيادة عامة',
  'Pediatrics': 'طب الأطفال',
  'Radiology': 'الأشعة',
  'Laboratory': 'المعمل',
  'Surgery Consultation': 'استشارة جراحة',
  'Cardiology': 'القلب',
  'Orthopedics': 'العظام',
  'Emergency Follow-up': 'متابعة الطوارئ',
  'Internal Medicine': 'باطنة',
  'Neurology': 'المخ والأعصاب',
  'Oncology': 'الأورام',
  'General Surgery': 'جراحة عامة',
  'Outpatient Clinic': 'العيادات الخارجية',
  'Emergency': 'الطوارئ',
  'Diagnostic Imaging': 'الأشعة التشخيصية',
  'Cancer Center': 'مركز الأورام',
  'Lab Tests': 'تحاليل معملية',
  'Oncology Consultation': 'استشارة أورام',
  'Chemotherapy Follow-up': 'متابعة العلاج الكيماوي',
  'Lab': 'معمل',
  'Cardiac Clinic': 'عيادة القلب',
  'Dental': 'الأسنان',
  'X-Ray': 'أشعة سينية',
  'Surgery': 'الجراحة',
  'MRI Booking': 'حجز رنين مغناطيسي',
  'National ID': 'بطاقة الرقم القومي',
  'Birth Certificate': 'شهادة ميلاد',
  'Family Record': 'قيد عائلي',
  'Marriage Certificate': 'وثيقة زواج',
  'Driving License Renewal': 'تجديد رخصة القيادة',
  'Car Ownership Transfer': 'نقل ملكية سيارة',
  'Violations Inquiry': 'الاستعلام عن المخالفات',
  'Passport Issuance': 'إصدار جواز سفر',
  'Passport Renewal': 'تجديد جواز السفر',
  'Travel Permit': 'تصريح سفر',
  'Property Registration': 'تسجيل عقار',
  'Ownership Certificate': 'شهادة ملكية',
  'Document Verification': 'توثيق مستندات',
  'Power of Attorney': 'توكيل',
  'Contract Authentication': 'توثيق عقد',
  'Declaration': 'إقرار',
  'Death Certificate': 'شهادة وفاة',
  'License Renewal': 'تجديد رخصة',
  'Vehicle Inspection Follow-up': 'متابعة فحص المركبة',
  'Fine Payment': 'سداد المخالفات',
  'New Passport': 'جواز سفر جديد',
  'Renewal': 'تجديد',
  'Lost Passport Replacement': 'بدل فاقد جواز سفر',
  'Property Contract Registration': 'تسجيل عقد عقاري',
  'Title Records': 'سجلات الملكية',
  'Document Copies': 'نسخ مستندات',
  'Tax Card Issuance': 'إصدار بطاقة ضريبية',
  'Tax File Update': 'تحديث الملف الضريبي',
  'E-receipt Inquiry': 'استعلام الإيصال الإلكتروني',
  'Tax Card Renewal': 'تجديد البطاقة الضريبية',
  'Company Registration': 'تسجيل شركة',
  'Tax Payment Support': 'دعم سداد الضرائب',
  'Domestic Ticketing': 'حجز تذاكر داخلية',
  'International Ticketing': 'حجز تذاكر دولية',
  'Baggage Service': 'خدمة الأمتعة',
  'Check-in Help': 'مساعدة إنهاء إجراءات السفر',
  'Flight Rescheduling': 'تغيير موعد الرحلة',
  'Seat Upgrade': 'ترقية المقعد',
  'Special Assistance': 'مساعدة خاصة',
  'Ticket Booking': 'حجز تذكرة',
  'Flight Change': 'تغيير الرحلة',
  'Baggage Inquiry': 'استعلام الأمتعة',
  'Book Ticket': 'حجز تذكرة',
  'Refund Request': 'طلب استرداد',
  'Schedule Inquiry': 'الاستعلام عن الجدول',
  'Reservation': 'حجز',
  'Date Change': 'تغيير التاريخ',
  'New Booking': 'حجز جديد',
  'Ticket Modification': 'تعديل التذكرة',
  'Miles Inquiry': 'استعلام الأميال',
  'Ticket Purchase': 'شراء تذكرة',
  'Upgrade Request': 'طلب ترقية',
  'Baggage Services': 'خدمات الأمتعة',
  'Booking': 'حجز',
  'Rebooking': 'إعادة حجز',
  'Special Services': 'خدمات خاصة',
  'Change Booking': 'تعديل الحجز',
  'Manage Booking': 'إدارة الحجز',
  'Ancillary Services': 'خدمات إضافية',
  'Ticketing': 'إصدار تذاكر',
  'Rescheduling': 'إعادة جدولة',
  'Baggage Claims': 'مطالبات الأمتعة',
  'Flight Update': 'تحديث الرحلة',
  'Frequent Flyer Support': 'دعم المسافر الدائم',
  'Account Statement Request': 'طلب كشف حساب',
  'Checkbook Issuance': 'إصدار دفتر شيكات',
  'IBAN Certificate': 'شهادة رقم الحساب البنكي الدولي',
  'Online Banking Registration': 'تسجيل الخدمات البنكية الإلكترونية',
  'Mobile Wallet Services': 'خدمات المحفظة الإلكترونية',
  'Debit Card Issuance': 'إصدار بطاقة خصم مباشر',
  'Credit Card Issuance': 'إصدار بطاقة ائتمان',
  'Lost Card Replacement': 'بدل فاقد بطاقة',
  'Certificate Redemption': 'استرداد شهادة',
  'Foreign Currency Exchange': 'تبديل عملات أجنبية',
  'Standing Order Setup': 'إعداد أمر دفع دوري',
  'Cheque Collection': 'تحصيل شيكات',
  'Salary Transfer Service': 'خدمة تحويل الرواتب',
  'SME Services': 'خدمات المشروعات الصغيرة والمتوسطة',
  'Corporate Cash Management': 'إدارة السيولة للشركات',
  'Complaints and Suggestions': 'الشكاوى والمقترحات',
  'Fraud Report and Card Block': 'الإبلاغ عن احتيال وإيقاف البطاقة',
};

// ===================== MODELS =====================

class AppUser {
  AppUser({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
  });

  final String id;
  final String fullName;
  final String phone;
  final String email;
}

class BookingTicket {
  BookingTicket({
    required this.id,
    required this.category,
    required this.place,
    required this.service,
    required this.ticketNumber,
    required this.userName,
    required this.phone,
    required this.arrivalTime,
    required this.status,
  });

  final String id;
  final String category;
  final String place;
  final String service;
  final int ticketNumber;
  final String userName;
  final String phone;
  final DateTime arrivalTime;
  final String status;

  factory BookingTicket.fromMap(Map<String, dynamic> data, String id) {
    final rawArrivalTime = data['arrivalTime'];
    DateTime parsedArrivalTime = DateTime.now();

    if (rawArrivalTime is Timestamp) {
      parsedArrivalTime = rawArrivalTime.toDate();
    } else if (rawArrivalTime is DateTime) {
      parsedArrivalTime = rawArrivalTime;
    } else if (rawArrivalTime is String) {
      parsedArrivalTime = DateTime.tryParse(rawArrivalTime) ?? DateTime.now();
    }

    final rawTicketNumber = data['ticketNumber'];
    final parsedTicketNumber = rawTicketNumber is int
        ? rawTicketNumber
        : int.tryParse(rawTicketNumber?.toString() ?? '') ?? 0;

    return BookingTicket(
      id: id,
      category: data['category']?.toString() ?? '',
      place: data['place']?.toString() ?? '',
      service: data['service']?.toString() ?? '',
      ticketNumber: parsedTicketNumber,
      userName: data['userName']?.toString() ?? '',
      phone: (data['phone'] ?? data['userPhone'])?.toString() ?? '',
      arrivalTime: parsedArrivalTime,
      status: data['status']?.toString() ?? 'pending',
    );
  }
}

class CategoryData {
  const CategoryData({
    required this.name,
    required this.icon,
    required this.places,
  });

  final String name;
  final IconData icon;
  final List<PlaceData> places;
}

class PlaceData {
  const PlaceData({
    required this.name,
    required this.icon,
    required this.actions,
  });

  final String name;
  final IconData icon;
  final List<String> actions;
}

class RegisteredAccount {
  const RegisteredAccount({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String phone;
  final String email;
  final String password;
}

// ===================== FIREBASE SERVICE =====================

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up
  Future<void> signUpWithEmail({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      await _firestore.collection('users').doc(userId).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw _handleGenericAuthError(e);
    }
  }

  // Sign In
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw _handleGenericAuthError(e);
    }
  }

  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();
      final userCredential = await _auth.signInWithProvider(provider);
      final userId = userCredential.user!.uid;

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userId).set({
          'fullName': userCredential.user!.displayName ?? 'Google User',
          'email': userCredential.user!.email ?? '',
          'phone': userCredential.user!.phoneNumber ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'authProvider': 'google',
        });
      } else {
        await _firestore.collection('users').doc(userId).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'فشل تسجيل الدخول بـ Google';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'فشل تسجيل الخروج';
    }
  }

  // Get User Data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      throw 'فشل في جلب بيانات المستخدم';
    }
  }

  // Update User Profile
  Future<void> updateUserProfile({
    required String userId,
    required String fullName,
    required String phone,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fullName': fullName,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'فشل تحديث الملف الشخصي';
    }
  }

  // Create Booking
  Future<String> createBooking({
    required String userId,
    required String category,
    required String place,
    required String service,
    required int ticketNumber,
    required String userName,
    required String userPhone,
    required DateTime arrivalTime,
  }) async {
    debugPrint('createBooking(): start');
    debugPrint(
      'createBooking(): userId=$userId, category=$category, place=$place, '
      'service=$service, ticketNumber=$ticketNumber, userName=$userName, '
      'userPhone=$userPhone, arrivalTime=$arrivalTime',
    );

    try {
      debugPrint('createBooking(): running validation');
      if (userId.trim().isEmpty) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'invalid-argument',
          message: 'userId فارغ',
        );
      }

      final currentUser = _auth.currentUser;
      debugPrint('createBooking(): authUser=${currentUser?.uid}');
      if (currentUser == null) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'unauthenticated',
          message: 'المستخدم غير مسجل الدخول',
        );
      }
      if (currentUser.uid != userId) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'معرف المستخدم لا يطابق المستخدم الحالي',
        );
      }
      if (userName.trim().isEmpty || userPhone.trim().isEmpty) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'invalid-argument',
          message: 'الاسم أو رقم الهاتف فارغ',
        );
      }
      if (ticketNumber <= 0) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'invalid-argument',
          message: 'رقم التذكرة غير صالح',
        );
      }

      debugPrint('createBooking(): validation passed');
      debugPrint('createBooking(): writing Firestore document');
      final docRef = await _firestore.collection('bookings').add({
        'userId': userId,
        'category': category,
        'place': place,
        'service': service,
        'ticketNumber': ticketNumber,
        'userName': userName,
        'phone': userPhone,
        'userPhone': userPhone,
        'arrivalTime': Timestamp.fromDate(arrivalTime),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      debugPrint('createBooking(): success, docId=${docRef.id}');
      return docRef.id;
    } on FirebaseException catch (e, stackTrace) {
      debugPrint('createBooking() FirebaseException: ${e.code} - ${e.message}');
      debugPrintStack(stackTrace: stackTrace);
      switch (e.code) {
        case 'permission-denied':
          throw 'ليس لديك صلاحية لإنشاء حجز. تأكد من تحديث Firebase Rules';
        case 'unauthenticated':
          throw 'يجب تسجيل الدخول أولاً قبل الحجز';
        case 'unavailable':
          throw 'خدمة Firebase غير متاحة. تحقق من الاتصال بالإنترنت';
        case 'invalid-argument':
          throw 'بيانات غير صحيحة: ${e.message ?? 'تحقق من المدخلات'}';
        default:
          throw 'خطأ في إنشاء الحجز: ${e.message ?? e.code}';
      }
    } catch (e, stackTrace) {
      debugPrint('createBooking() unexpected error: $e');
      debugPrintStack(stackTrace: stackTrace);
      throw 'خطأ في إنشاء الحجز: $e';
    }
  }

  // Get User Bookings as Stream
  Stream<List<BookingTicket>> getUserBookingsStream(String userId) {
    debugPrint('getUserBookingsStream(): userId=$userId');
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final bookings = <BookingTicket>[];
      for (final doc in snapshot.docs) {
        try {
          bookings.add(BookingTicket.fromMap(doc.data(), doc.id));
        } catch (e) {
          debugPrint('Skipping invalid booking doc ${doc.id}: $e');
        }
      }
      bookings.sort((a, b) => b.arrivalTime.compareTo(a.arrivalTime));
      return bookings;
    });
  }

  // Delete Booking
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).delete();
    } catch (e) {
      throw 'فشل في حذف الحجز';
    }
  }

  // Update Booking Status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'فشل في تحديث الحجز';
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    debugPrint('FirebaseAuthException code=${e.code}, message=${e.message}');
    switch (e.code) {
      case 'user-not-found':
        return 'لم يتم العثور على حساب';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني قيد الاستخدام بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'operation-not-allowed':
        return 'طريقة تسجيل الدخول غير مفعلة في Firebase Console';
      case 'network-request-failed':
        return 'فشل الاتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى';
      case 'too-many-requests':
        return 'تم إجراء محاولات كثيرة. حاول مرة أخرى لاحقًا';
      case 'internal-error':
        if ((e.message ?? '').contains('CONFIGURATION_NOT_FOUND')) {
          return 'إعدادات Firebase Auth غير مكتملة (CONFIGURATION_NOT_FOUND). فعّل Authentication وأنشئ Web App صحيحة ثم حدّث firebase_options.dart';
        }
        return 'حدث خطأ داخلي من Firebase. تأكد من تفعيل Email/Password في Authentication > Sign-in method';
      default:
        return 'حدث خطأ: ${e.message}';
    }
  }

  String _handleGenericAuthError(Object error) {
    final message = error.toString();
    if (message.contains('CONFIGURATION_NOT_FOUND')) {
      return 'إعدادات Firebase Auth غير موجودة للمشروع الحالي. تحقق من apiKey/projectId أو فعّل Authentication في Firebase Console';
    }
    return message;
  }
}

// ===================== MAIN APP =====================

class HagzyTicketApp extends StatefulWidget {
  const HagzyTicketApp({super.key});

  @override
  State<HagzyTicketApp> createState() => _HagzyTicketAppState();
}

class _HagzyTicketAppState extends State<HagzyTicketApp> {
  ThemeMode _themeMode = ThemeMode.light;
  AppLanguage _language = AppLanguage.english;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _setLanguage(AppLanguage language) {
    setState(() {
      _language = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tr(_language, 'Hagzyticket', 'حجزي تكت'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: AuthGate(
        language: _language,
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
        onLanguageChanged: _setLanguage,
      ),
    );
  }
}

// ===================== AUTH GATE =====================

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.language,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.confirmation_num_outlined,
                      size: 70, color: Color(0xFF0D47A1)),
                  const SizedBox(height: 20),
                  Text(
                    tr(language, 'Loading...', 'جاري التحميل...'),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return MainNavigationShell(
            userId: snapshot.data!.uid,
            language: language,
            themeMode: themeMode,
            onToggleTheme: onToggleTheme,
            onLanguageChanged: onLanguageChanged,
          );
        }

        return WelcomeAuthPage(
          language: language,
          themeMode: themeMode,
          onToggleTheme: onToggleTheme,
          onLanguageChanged: onLanguageChanged,
        );
      },
    );
  }
}

// ===================== WELCOME & AUTH PAGE =====================

class WelcomeAuthPage extends StatefulWidget {
  const WelcomeAuthPage({
    super.key,
    required this.language,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  State<WelcomeAuthPage> createState() => _WelcomeAuthPageState();
}

class _WelcomeAuthPageState extends State<WelcomeAuthPage> {
  bool _showSignUp = false;
  bool _obscureLoginPassword = true;
  bool _obscureSignUpPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _signupFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _submitSignUp() async {
    if (!(_signupFormKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseService().signUpWithEmail(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      _showSuccessSnackBar(tr(widget.language, 'Account created successfully!',
          'تم إنشاء الحساب بنجاح!'));
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitLogin() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseService().signInWithEmail(
        email: _loginEmailController.text.trim(),
        password: _loginPasswordController.text,
      );
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseService().signInWithGoogle();
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _GlobalControlsBar(
                        language: widget.language,
                        themeMode: widget.themeMode,
                        onToggleTheme: widget.onToggleTheme,
                        onLanguageChanged: widget.onLanguageChanged,
                      ),
                      const SizedBox(height: 8),
                      const Icon(
                        Icons.confirmation_num_outlined,
                        size: 70,
                        color: Color(0xFF0D47A1),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          tr(widget.language, 'Hagzyticket', 'حجزي تكت'),
                          style: const TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr(
                          widget.language,
                          'Book smart queues across Egypt.',
                          'احجز دورك الذكي في جميع أنحاء مصر.',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),
                      if (_showSignUp)
                        _buildSignUpForm()
                      else
                        _buildLoginForm(),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _showSignUp = !_showSignUp;
                                });
                              },
                        child: Text(
                          _showSignUp
                              ? tr(
                                  widget.language,
                                  'Already have an account? Login',
                                  'لديك حساب بالفعل؟ سجل الدخول',
                                )
                              : tr(
                                  widget.language,
                                  'Create an account',
                                  'إنشاء حساب جديد',
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: tr(widget.language, 'Email', 'البريد الإلكتروني'),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return tr(widget.language, 'Please enter your email',
                    'يرجى إدخال البريد الإلكتروني');
              }
              if (!value.contains('@')) {
                return tr(widget.language, 'Enter a valid email',
                    'أدخل بريدًا إلكترونيًا صحيحًا');
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _loginPasswordController,
            obscureText: _obscureLoginPassword,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: tr(widget.language, 'Password', 'كلمة المرور'),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureLoginPassword = !_obscureLoginPassword;
                  });
                },
                icon: Icon(
                  _obscureLoginPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (value) => (value == null || value.length < 6)
                ? tr(widget.language, 'Minimum 6 characters',
                    'الحد الأدنى 6 أحرف')
                : null,
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: _isLoading ? null : _submitLogin,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(tr(widget.language, 'Login', 'تسجيل الدخول')),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _isLoading ? null : _signInWithGoogle,
            icon: const Icon(Icons.g_mobiledata),
            label: Text(
              tr(widget.language, 'Sign in with Google',
                  'تسجيل الدخول بواسطة جوجل'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: tr(widget.language, 'Full Name', 'الاسم الكامل'),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            validator: (value) => (value == null || value.trim().length < 3)
                ? tr(
                    widget.language, 'Enter your full name', 'أدخل اسمك الكامل')
                : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: tr(widget.language, 'Phone Number', 'رقم الهاتف'),
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return tr(
                    widget.language, 'Enter phone number', 'أدخل رقم الهاتف');
              }
              if (value.trim().length < 11) {
                return tr(widget.language, 'Enter a valid phone number',
                    'أدخل رقم هاتف صحيح');
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: tr(widget.language, 'Email', 'البريد الإلكتروني'),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return tr(
                    widget.language, 'Enter email', 'أدخل البريد الإلكتروني');
              }
              if (!value.contains('@')) {
                return tr(widget.language, 'Enter a valid email',
                    'أدخل بريدًا إلكترونيًا صحيحًا');
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscureSignUpPassword,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: tr(widget.language, 'Password', 'كلمة المرور'),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureSignUpPassword = !_obscureSignUpPassword;
                  });
                },
                icon: Icon(
                  _obscureSignUpPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (value) => (value == null || value.length < 6)
                ? tr(widget.language, 'Minimum 6 characters',
                    'الحد الأدنى 6 أحرف')
                : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _confirmController,
            obscureText: _obscureConfirmPassword,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText:
                  tr(widget.language, 'Confirm Password', 'تأكيد كلمة المرور'),
              prefixIcon: const Icon(Icons.lock_reset_outlined),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (value) {
              if (value != _passwordController.text) {
                return tr(widget.language, 'Passwords do not match',
                    'كلمتا المرور غير متطابقتين');
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: _isLoading ? null : _submitSignUp,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(tr(widget.language, 'Sign Up', 'إنشاء حساب')),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _isLoading ? null : _signInWithGoogle,
            icon: const Icon(Icons.g_mobiledata),
            label: Text(
              tr(widget.language, 'Sign up with Google',
                  'إنشاء حساب بواسطة جوجل'),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== MAIN NAVIGATION =====================

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({
    super.key,
    required this.userId,
    required this.language,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onLanguageChanged,
  });

  final String userId;
  final AppLanguage language;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedTab = 0;
  final List<int> _tabHistory = [];
  final _ticketGenerator = TicketGenerator();
  bool _isCreatingBooking = false;
  late AppUser _user;
  bool _loadingUser = true;

  static const List<String> _bankAllServices = [
    'Customer Service',
    'Account Opening',
    'Open Current Account',
    'Open Savings Account',
    'Current Account',
    'Account Update',
    'Account Statement Request',
    'Cash Deposit',
    'Deposit Services',
    'Money Transfer',
    'International Transfer',
    'Transfers',
    'Wire Transfer',
    'IBAN Certificate',
    'Online Banking Registration',
    'Digital Banking Support',
    'Mobile Wallet Services',
    'Card Services',
    'Debit Card Issuance',
    'Credit Card Issuance',
    'Credit Card Services',
    'Credit Card Request',
    'Card Activation',
    'ATM Card Renewal',
    'Card Replacement',
    'Lost Card Replacement',
    'Checkbook Issuance',
    'Loan Consultation',
    'Loan Inquiry',
    'Loan Follow-up',
    'Personal Loan',
    'Mortgage Services',
    'Installment Inquiry',
    'Islamic Banking',
    'Islamic Financing',
    'Murabaha Financing',
    'Investment Products',
    'Investment Accounts',
    'Savings Certificate',
    'Certificate Purchase',
    'Certificate Redemption',
    'Foreign Currency Exchange',
    'Standing Order Setup',
    'Cheque Collection',
    'Salary Transfer Service',
    'Premier Services',
    'International Banking',
    'Retail Banking',
    'Corporate Account',
    'Corporate Services',
    'Corporate Cash Management',
    'SME Financing',
    'SME Services',
    'Customer Support',
    'Complaints and Suggestions',
    'Fraud Report and Card Block',
  ];

  static const List<CategoryData> _categories = [
    CategoryData(
      name: 'Bank',
      icon: Icons.account_balance,
      places: [
        PlaceData(
          name: 'National Bank of Egypt',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Banque Misr',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Commercial International Bank (CIB)',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Arab African International Bank',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Arab Bank',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Housing and Development Bank',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Bank of Alexandria',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'QNB Alahli',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Faisal Islamic Bank of Egypt',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Abu Dhabi Islamic Bank Egypt (ADIB)',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Egyptian Gulf Bank',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Crédit Agricole Egypt',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'HSBC Egypt',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'SAIB Bank',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Al Baraka Bank Egypt',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'MID Bank',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
        PlaceData(
          name: 'Attijariwafa Bank Egypt',
          icon: Icons.account_balance_outlined,
          actions: _bankAllServices,
        ),
      ],
    ),
    CategoryData(
      name: 'Hospital',
      icon: Icons.local_hospital,
      places: [
        PlaceData(
          name: 'Kasr Al Ainy Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['General Clinic', 'Pediatrics', 'Radiology', 'Laboratory'],
        ),
        PlaceData(
          name: 'Ain Shams Specialized Hospital',
          icon: Icons.local_hospital_outlined,
          actions: [
            'Surgery Consultation',
            'Cardiology',
            'Orthopedics',
            'Emergency Follow-up'
          ],
        ),
        PlaceData(
          name: 'El Shorouk Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['Internal Medicine', 'Pediatrics', 'Radiology'],
        ),
        PlaceData(
          name: 'Cairo University Specialized Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['Neurology', 'Oncology', 'Laboratory'],
        ),
        PlaceData(
          name: 'Nasser Institute Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['Cardiology', 'General Surgery', 'Outpatient Clinic'],
        ),
        PlaceData(
          name: 'El Demerdash Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['Emergency', 'Orthopedics', 'Diagnostic Imaging'],
        ),
        PlaceData(
          name: 'Dar Al Fouad Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['Cardiology', 'Cancer Center', 'Lab Tests'],
        ),
        PlaceData(
          name: '57357 Children Cancer Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['Oncology Consultation', 'Chemotherapy Follow-up', 'Lab'],
        ),
        PlaceData(
          name: 'As-Salam International Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['Emergency', 'Cardiac Clinic', 'Radiology'],
        ),
        PlaceData(
          name: 'Alexandria Main University Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['Outpatient Clinic', 'Internal Medicine', 'Orthopedics'],
        ),
        PlaceData(
          name: 'El Miri Hospital Alexandria',
          icon: Icons.local_hospital_outlined,
          actions: ['Emergency', 'General Surgery', 'Lab'],
        ),
        PlaceData(
          name: 'Gamal Abdel Nasser Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['Cardiology', 'Pediatrics', 'Radiology'],
        ),
        PlaceData(
          name: 'Sharq El Madina Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['General Clinic', 'Dental', 'X-Ray'],
        ),
        PlaceData(
          name: 'Andalusia Smouha Hospital',
          icon: Icons.local_hospital_outlined,
          actions: ['Internal Medicine', 'Surgery', 'Lab'],
        ),
        PlaceData(
          name: 'Saudi German Hospital Alexandria',
          icon: Icons.local_hospital_outlined,
          actions: ['Emergency', 'Pediatrics', 'MRI Booking'],
        ),
      ],
    ),
    CategoryData(
      name: 'Government Offices',
      icon: Icons.apartment,
      places: [
        PlaceData(
          name: 'Abbassia Civil Registry',
          icon: Icons.business_outlined,
          actions: [
            'National ID',
            'Birth Certificate',
            'Family Record',
            'Marriage Certificate'
          ],
        ),
        PlaceData(
          name: 'Nasr City Traffic Unit',
          icon: Icons.business_outlined,
          actions: [
            'Driving License Renewal',
            'Car Ownership Transfer',
            'Violations Inquiry'
          ],
        ),
        PlaceData(
          name: 'Cairo Passport and Immigration Complex',
          icon: Icons.business_outlined,
          actions: ['Passport Issuance', 'Passport Renewal', 'Travel Permit'],
        ),
        PlaceData(
          name: 'Cairo Real Estate Registry',
          icon: Icons.business_outlined,
          actions: [
            'Property Registration',
            'Ownership Certificate',
            'Document Verification'
          ],
        ),
        PlaceData(
          name: 'Cairo Notary Public Office',
          icon: Icons.business_outlined,
          actions: [
            'Power of Attorney',
            'Contract Authentication',
            'Declaration'
          ],
        ),
        PlaceData(
          name: 'Alexandria Civil Registry - Sidi Gaber',
          icon: Icons.business_outlined,
          actions: ['National ID', 'Birth Certificate', 'Death Certificate'],
        ),
        PlaceData(
          name: 'Alexandria Traffic Unit - Montaza',
          icon: Icons.business_outlined,
          actions: [
            'License Renewal',
            'Vehicle Inspection Follow-up',
            'Fine Payment'
          ],
        ),
        PlaceData(
          name: 'Alexandria Passport Office',
          icon: Icons.business_outlined,
          actions: ['New Passport', 'Renewal', 'Lost Passport Replacement'],
        ),
        PlaceData(
          name: 'Alexandria Real Estate Registry',
          icon: Icons.business_outlined,
          actions: [
            'Property Contract Registration',
            'Title Records',
            'Document Copies'
          ],
        ),
        PlaceData(
          name: 'Tax Office - Cairo Downtown',
          icon: Icons.business_outlined,
          actions: [
            'Tax Card Issuance',
            'Tax File Update',
            'E-receipt Inquiry'
          ],
        ),
        PlaceData(
          name: 'Tax Office - Alexandria East',
          icon: Icons.business_outlined,
          actions: [
            'Tax Card Renewal',
            'Company Registration',
            'Tax Payment Support'
          ],
        ),
      ],
    ),
    CategoryData(
      name: 'Airlines',
      icon: Icons.flight_takeoff,
      places: [
        PlaceData(
          name: 'EgyptAir Service Center',
          icon: Icons.flight_outlined,
          actions: [
            'Domestic Ticketing',
            'International Ticketing',
            'Baggage Service',
            'Check-in Help'
          ],
        ),
        PlaceData(
          name: 'Cairo Airport Booking Office',
          icon: Icons.flight_outlined,
          actions: [
            'Flight Rescheduling',
            'Seat Upgrade',
            'Special Assistance'
          ],
        ),
        PlaceData(
          name: 'Air Cairo',
          icon: Icons.flight_outlined,
          actions: ['Ticket Booking', 'Flight Change', 'Baggage Inquiry'],
        ),
        PlaceData(
          name: 'Nile Air',
          icon: Icons.flight_outlined,
          actions: ['Book Ticket', 'Refund Request', 'Schedule Inquiry'],
        ),
        PlaceData(
          name: 'Nesma Airlines',
          icon: Icons.flight_outlined,
          actions: ['Reservation', 'Date Change', 'Customer Service'],
        ),
        PlaceData(
          name: 'Turkish Airlines Egypt Office',
          icon: Icons.flight_outlined,
          actions: ['New Booking', 'Ticket Modification', 'Miles Inquiry'],
        ),
        PlaceData(
          name: 'Emirates Egypt Office',
          icon: Icons.flight_outlined,
          actions: ['Ticket Purchase', 'Upgrade Request', 'Baggage Services'],
        ),
        PlaceData(
          name: 'Qatar Airways Egypt Office',
          icon: Icons.flight_outlined,
          actions: ['Booking', 'Rebooking', 'Special Services'],
        ),
        PlaceData(
          name: 'Saudia Egypt Office',
          icon: Icons.flight_outlined,
          actions: ['Reservation', 'Change Booking', 'Check-in Support'],
        ),
        PlaceData(
          name: 'Flydubai Egypt Office',
          icon: Icons.flight_outlined,
          actions: ['Book Ticket', 'Manage Booking', 'Ancillary Services'],
        ),
        PlaceData(
          name: 'Lufthansa Egypt Office',
          icon: Icons.flight_outlined,
          actions: ['Ticketing', 'Rescheduling', 'Baggage Claims'],
        ),
        PlaceData(
          name: 'Royal Jordanian Egypt Office',
          icon: Icons.flight_outlined,
          actions: ['Reservation', 'Flight Update', 'Frequent Flyer Support'],
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await FirebaseService().getUserData(widget.userId);
      final authUser = FirebaseService().currentUser;
      final fallbackUser = AppUser(
        id: widget.userId,
        fullName: authUser?.displayName ?? 'User',
        phone: authUser?.phoneNumber ?? '',
        email: authUser?.email ?? '',
      );

      if (!mounted) return;
      setState(() {
        _user = userData != null
            ? AppUser(
                id: widget.userId,
                fullName: userData['fullName'] ?? fallbackUser.fullName,
                phone: userData['phone'] ?? fallbackUser.phone,
                email: userData['email'] ?? fallbackUser.email,
              )
            : fallbackUser;
        _loadingUser = false;
      });
    } catch (e) {
      debugPrint('Error loading user: $e');
      if (mounted) {
        final authUser = FirebaseService().currentUser;
        _user = AppUser(
          id: widget.userId,
          fullName: authUser?.displayName ?? 'User',
          phone: authUser?.phoneNumber ?? '',
          email: authUser?.email ?? '',
        );
        setState(() => _loadingUser = false);
      }
    }
  }

  void _openServices(CategoryData category) async {
    final selectedPlace = await Navigator.push<PlaceData>(
      context,
      MaterialPageRoute(
        builder: (_) => PlacesPage(
          category: category,
          language: widget.language,
          themeMode: widget.themeMode,
          onToggleTheme: widget.onToggleTheme,
          onLanguageChanged: widget.onLanguageChanged,
        ),
      ),
    );

    if (selectedPlace == null || !mounted) return;

    final selectedAction = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceActionsPage(
          category: category,
          place: selectedPlace,
          language: widget.language,
          themeMode: widget.themeMode,
          onToggleTheme: widget.onToggleTheme,
          onLanguageChanged: widget.onLanguageChanged,
        ),
      ),
    );

    if (selectedAction == null) return;

    final ticket = _ticketGenerator.generate(
      category: category.name,
      place: selectedPlace.name,
      service: selectedAction,
      user: _user,
    );

    if (!mounted) return;

    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TicketSummaryPage(
          ticket: ticket,
          language: widget.language,
          themeMode: widget.themeMode,
          onToggleTheme: widget.onToggleTheme,
          onLanguageChanged: widget.onLanguageChanged,
        ),
      ),
    );

    if (confirmed ?? false) {
      if (_isCreatingBooking || !mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      var loadingDialogShown = false;
      setState(() {
        _isCreatingBooking = true;
      });
      try {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          useRootNavigator: true,
          builder: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
        loadingDialogShown = true;

        debugPrint(
          'openServices(): creating booking for user=${widget.userId}, '
          'category=${ticket.category}, place=${ticket.place}, '
          'service=${ticket.service}, ticketNumber=${ticket.ticketNumber}',
        );

        await FirebaseService().createBooking(
          userId: widget.userId,
          category: ticket.category,
          place: ticket.place,
          service: ticket.service,
          ticketNumber: ticket.ticketNumber,
          userName: ticket.userName,
          userPhone: ticket.phone,
          arrivalTime: ticket.arrivalTime,
        );

        if (loadingDialogShown && mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          loadingDialogShown = false;
        }

        debugPrint(
          'Booking success: userId=${widget.userId}, '
          'place=${ticket.place}, service=${ticket.service}, '
          'ticketNumber=${ticket.ticketNumber}',
        );

        if (!mounted) return;
        setState(() {
          if (_selectedTab != 1) {
            _tabHistory.add(_selectedTab);
          }
          _selectedTab = 1;
        });

        messenger.showSnackBar(
          SnackBar(
            content: Text(
              tr(widget.language, 'Booking created successfully!',
                  'تم إنشاء الحجز بنجاح!'),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } on FirebaseException catch (e, stackTrace) {
        debugPrint('Booking FirebaseException: ${e.code} - ${e.message}');
        debugPrintStack(stackTrace: stackTrace);
        if (loadingDialogShown && mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          loadingDialogShown = false;
        }
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(
            content: Text(_bookingFirebaseErrorMessage(e)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
          ),
        );
      } catch (e, stackTrace) {
        debugPrint('Booking unexpected error: $e');
        debugPrintStack(stackTrace: stackTrace);
        if (loadingDialogShown && mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          loadingDialogShown = false;
        }
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(
            content: Text('خطأ أثناء إنشاء الحجز: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isCreatingBooking = false;
          });
        }
      }
    }
  }

  String _bookingFirebaseErrorMessage(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'ليس لديك صلاحية لإنشاء حجز. تأكد من تحديث Firebase Rules';
      case 'unauthenticated':
        return 'يجب تسجيل الدخول أولاً قبل الحجز';
      case 'unavailable':
        return 'خدمة Firebase غير متاحة. تحقق من الاتصال بالإنترنت';
      case 'invalid-argument':
        return 'بيانات غير صحيحة: ${e.message ?? 'تحقق من الحقول المدخلة'}';
      default:
        return 'خطأ في إنشاء الحجز: ${e.message ?? e.code}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.confirmation_num_outlined,
                  size: 70, color: Color(0xFF0D47A1)),
              const SizedBox(height: 20),
              Text(
                tr(widget.language, 'Loading...', 'جاري التحميل...'),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildCurrentPage() {
      switch (_selectedTab) {
        case 0:
          return HomeDashboardPage(
            user: _user,
            categories: _categories,
            onCategoryTap: _openServices,
            language: widget.language,
          );
        case 1:
          return MyBookingsPage(
              userId: widget.userId, language: widget.language);
        case 2:
          return SettingsPage(language: widget.language);
        case 3:
          return ProfilePage(
            user: _user,
            userId: widget.userId,
            language: widget.language,
          );
        default:
          return HomeDashboardPage(
            user: _user,
            categories: _categories,
            onCategoryTap: _openServices,
            language: widget.language,
          );
      }
    }

    final titles = [
      tr(widget.language, 'Home', 'الرئيسية'),
      tr(widget.language, 'My Bookings', 'حجوزاتي'),
      tr(widget.language, 'Settings', 'الإعدادات'),
      tr(widget.language, 'Profile', 'الملف الشخصي'),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_tabHistory.isNotEmpty) {
          setState(() {
            _selectedTab = _tabHistory.removeLast();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[_selectedTab]),
          actions: [
            _GlobalControlsActions(
              language: widget.language,
              themeMode: widget.themeMode,
              onToggleTheme: widget.onToggleTheme,
              onLanguageChanged: widget.onLanguageChanged,
            ),
          ],
        ),
        body: SafeArea(child: buildCurrentPage()),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedTab,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              label: tr(widget.language, 'Home', 'الرئيسية'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.confirmation_number_outlined),
              label: tr(widget.language, 'My Bookings', 'حجوزاتي'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              label: tr(widget.language, 'Settings', 'الإعدادات'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              label: tr(widget.language, 'Profile', 'الملف الشخصي'),
            ),
          ],
          onDestinationSelected: (value) {
            if (value == _selectedTab) return;
            setState(() {
              _tabHistory.add(_selectedTab);
              _selectedTab = value;
            });
          },
        ),
      ),
    );
  }
}

// ===================== HOME DASHBOARD =====================

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({
    super.key,
    required this.user,
    required this.categories,
    required this.onCategoryTap,
    required this.language,
  });

  final AppUser user;
  final List<CategoryData> categories;
  final ValueChanged<CategoryData> onCategoryTap;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(
              language,
              'Welcome, ${user.fullName.split(' ').first}',
              'مرحبًا، ${user.fullName.split(' ').first}',
            ),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            tr(
              language,
              'Choose a category to book your queue in Egypt.',
              'اختر فئة لحجز دورك في مصر.',
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onCategoryTap(category),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category.icon, color: Colors.white, size: 42),
                          const SizedBox(height: 12),
                          Text(
                            localizeTerm(language, category.name),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== PLACES PAGE =====================

class PlacesPage extends StatelessWidget {
  const PlacesPage({
    super.key,
    required this.category,
    required this.language,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onLanguageChanged,
  });

  final CategoryData category;
  final AppLanguage language;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(
            language,
            'Choose ${localizeTerm(language, category.name)} Place',
            'اختر جهة من فئة ${localizeTerm(language, category.name)}',
          ),
        ),
        actions: [
          _GlobalControlsActions(
            language: language,
            themeMode: themeMode,
            onToggleTheme: onToggleTheme,
            onLanguageChanged: onLanguageChanged,
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final place = category.places[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(place.icon),
              ),
              title: Text(localizeTerm(language, place.name)),
              subtitle: Text(
                  tr(language, 'Tap to choose action', 'اضغط لاختيار الإجراء')),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => Navigator.pop(context, place),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: category.places.length,
      ),
    );
  }
}

// ===================== PLACE ACTIONS PAGE =====================

class PlaceActionsPage extends StatelessWidget {
  const PlaceActionsPage({
    super.key,
    required this.category,
    required this.place,
    required this.language,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onLanguageChanged,
  });

  final CategoryData category;
  final PlaceData place;
  final AppLanguage language;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(
            language,
            '${localizeTerm(language, place.name)} Actions',
            'إجراءات ${localizeTerm(language, place.name)}',
          ),
        ),
        actions: [
          _GlobalControlsActions(
            language: language,
            themeMode: themeMode,
            onToggleTheme: onToggleTheme,
            onLanguageChanged: onLanguageChanged,
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final action = place.actions[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(category.icon),
              ),
              title: Text(localizeTerm(language, action)),
              subtitle: Text(
                  tr(language, 'Tap to create ticket', 'اضغط لإنشاء التذكرة')),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => Navigator.pop(context, action),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: place.actions.length,
      ),
    );
  }
}

// ===================== TICKET SUMMARY PAGE =====================

class TicketSummaryPage extends StatelessWidget {
  const TicketSummaryPage({
    super.key,
    required this.ticket,
    required this.language,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onLanguageChanged,
  });

  final BookingTicket ticket;
  final AppLanguage language;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(language, 'Ticket Summary', 'ملخص التذكرة')),
        actions: [
          _GlobalControlsActions(
            language: language,
            themeMode: themeMode,
            onToggleTheme: onToggleTheme,
            onLanguageChanged: onLanguageChanged,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Icon(Icons.confirmation_num,
                        size: 54, color: Color(0xFF0D47A1)),
                    const SizedBox(height: 10),
                    Text(
                      tr(language, 'Your Queue Ticket',
                          'تذكرة الدور الخاصة بك'),
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    const Divider(height: 28),
                    _ticketRow(
                      tr(language, 'Category', 'الفئة'),
                      localizeTerm(language, ticket.category),
                    ),
                    _ticketRow(
                      tr(language, 'Place', 'الجهة'),
                      localizeTerm(language, ticket.place),
                    ),
                    _ticketRow(
                      tr(language, 'Service', 'الخدمة'),
                      localizeTerm(language, ticket.service),
                    ),
                    _ticketRow(tr(language, 'Ticket Number', 'رقم التذكرة'),
                        '#${ticket.ticketNumber}'),
                    _ticketRow(tr(language, 'Name', 'الاسم'), ticket.userName),
                    _ticketRow(tr(language, 'Phone', 'الهاتف'), ticket.phone),
                    _ticketRow(
                      tr(language, 'Arrival Time', 'موعد الحضور'),
                      _formatTime(ticket.arrivalTime),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.bookmark_added_outlined),
              label: Text(tr(language, 'Confirm Booking', 'تأكيد الحجز')),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(tr(language, 'Cancel', 'إلغاء')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} $hour:$minute';
  }
}

// ===================== MY BOOKINGS PAGE =====================

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({
    super.key,
    required this.userId,
    required this.language,
  });

  final String userId;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BookingTicket>>(
      stream: FirebaseService().getUserBookingsStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 16),
                Text(tr(
                    language, 'Loading bookings...', 'جاري تحميل الحجوزات...')),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  tr(language, 'Error loading bookings',
                      'خطأ في تحميل الحجوزات'),
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        }

        final bookings = snapshot.data ?? [];

        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.confirmation_number_outlined,
                    size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  tr(
                    language,
                    'No bookings yet. Start booking from Home.',
                    'لا توجد حجوزات بعد. ابدأ الحجز من الصفحة الرئيسية.',
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final ticket = bookings[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.confirmation_num_outlined),
                title: Text(
                  '${localizeTerm(language, ticket.place)} - ${localizeTerm(language, ticket.service)}',
                ),
                subtitle: Text(
                  tr(language, 'Ticket #${ticket.ticketNumber}',
                      'تذكرة رقم ${ticket.ticketNumber}'),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title:
                              Text(tr(language, 'Delete Booking', 'حذف الحجز')),
                          content: Text(
                            tr(
                              language,
                              'Are you sure you want to delete this booking?',
                              'هل أنت متأكد من حذف هذا الحجز؟',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(tr(language, 'Cancel', 'إلغاء')),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await FirebaseService()
                                      .deleteBooking(ticket.id);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        tr(language, 'Booking deleted',
                                            'تم حذف الحجز'),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                tr(language, 'Delete', 'حذف'),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline,
                              color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            tr(language, 'Delete', 'حذف'),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ===================== SETTINGS PAGE =====================

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(tr(language, 'Language', 'اللغة')),
            subtitle: Text(tr(language, 'Arabic / English support',
                'دعم اللغة العربية والإنجليزية')),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(tr(language, 'Notifications', 'الإشعارات')),
            subtitle: Text(tr(language, 'Ticket reminders and updates',
                'تذكير التذاكر والتحديثات')),
          ),
        ),
      ],
    );
  }
}

// ===================== PROFILE PAGE =====================

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.user,
    required this.userId,
    required this.language,
  });

  final AppUser user;
  final String userId;
  final AppLanguage language;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      await FirebaseService().updateUserProfile(
        userId: widget.userId,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tr(widget.language, 'Profile updated successfully!',
                'تم تحديث الملف الشخصي بنجاح!'),
          ),
          backgroundColor: Colors.green,
        ),
      );

      setState(() => _isEditing = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseService().signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    child: Icon(Icons.person_outline, size: 35),
                  ),
                  const SizedBox(height: 16),
                  if (_isEditing)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(widget.language, 'Full Name', 'الاسم الكامل'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tr(widget.language, 'Phone Number', 'رقم الهاتف'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: _isSaving ? null : _saveProfile,
                                child: _isSaving
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        ),
                                      )
                                    : Text(tr(widget.language, 'Save', 'حفظ')),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => _isEditing = false),
                                child: Text(
                                    tr(widget.language, 'Cancel', 'إلغاء')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.fullName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                            '${tr(widget.language, 'Email', 'البريد الإلكتروني')}: ${widget.user.email}'),
                        const SizedBox(height: 6),
                        Text(
                            '${tr(widget.language, 'Phone', 'الهاتف')}: ${widget.user.phone}'),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () => setState(() => _isEditing = true),
                          icon: const Icon(Icons.edit_outlined),
                          label: Text(tr(widget.language, 'Edit Profile',
                              'تعديل الملف الشخصي')),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout_outlined),
            label: Text(tr(widget.language, 'Sign Out', 'تسجيل الخروج')),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== TICKET GENERATOR =====================

class TicketGenerator {
  final Random _random = Random();
  final Map<String, Set<int>> _usedByCategory = {};

  BookingTicket generate({
    required String category,
    required String place,
    required String service,
    required AppUser user,
  }) {
    final used = _usedByCategory.putIfAbsent(category, () => <int>{});
    if (used.length >= 1000) {
      used.clear();
    }

    int number = _random.nextInt(1000) + 1;
    while (used.contains(number)) {
      number = _random.nextInt(1000) + 1;
    }
    used.add(number);

    return BookingTicket(
      id: '',
      category: category,
      place: place,
      service: service,
      ticketNumber: number,
      userName: user.fullName,
      phone: user.phone,
      arrivalTime: DateTime.now().add(
        Duration(minutes: _random.nextInt(120) + 10),
      ),
      status: 'pending',
    );
  }
}

// ===================== GLOBAL CONTROLS =====================

class _GlobalControlsBar extends StatelessWidget {
  const _GlobalControlsBar({
    required this.language,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _GlobalControlsActions(
          language: language,
          themeMode: themeMode,
          onToggleTheme: onToggleTheme,
          onLanguageChanged: onLanguageChanged,
        ),
      ],
    );
  }
}

class _GlobalControlsActions extends StatelessWidget {
  const _GlobalControlsActions({
    required this.language,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton<AppLanguage>(
          tooltip: tr(language, 'Choose language', 'اختر اللغة'),
          icon: const Icon(Icons.language_outlined),
          onSelected: onLanguageChanged,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: AppLanguage.english,
              child: Text(tr(language, 'English', 'الإنجليزية')),
            ),
            PopupMenuItem(
              value: AppLanguage.arabic,
              child: Text(tr(language, 'Arabic', 'العربية')),
            ),
          ],
        ),
        IconButton(
          tooltip: tr(language, 'Toggle theme', 'تبديل المظهر'),
          onPressed: onToggleTheme,
          icon: Icon(
            themeMode == ThemeMode.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
          ),
        ),
      ],
    );
  }
}
