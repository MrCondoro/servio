import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    // ALWAYS MOCK LOGIN FOR MVP UI TESTING
    // Bypass Firebase completely since it's not configured yet.
    return Right(UserEntity(
      id: 'mock_admin_123',
      email: email.isEmpty ? 'admin@servio.com' : email,
      role: 'Owner',
      restaurantId: 'default_restaurant',
      displayName: 'Servio Admin',
      photoUrl: null,
    ));
  }

  @override
  Future<Either<Failure, UserEntity>> register(String email, String password, String name, Uint8List? imageBytes) async {
    // MOCK REGISTER FOR MVP UI TESTING
    // Bypasses Firebase until Email/Password auth is enabled in Firebase Console.
    await Future.delayed(const Duration(milliseconds: 800));
    return Right(UserEntity(
      id: 'mock_new_user_${DateTime.now().millisecondsSinceEpoch}',
      email: email.isEmpty ? 'owner@restaurant.com' : email,
      displayName: name.isEmpty ? 'Restaurant Owner' : name,
      photoUrl: null,
      role: 'Owner',
      restaurantId: 'default_restaurant',
    ));
    // ignore: dead_code
    try {
      // 1. Create user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return const Left(ServerFailure(message: 'Failed to create user.'));
      }

      String? photoUrl;

      // 2. Upload image to Firebase Storage if provided
      if (imageBytes != null) {
        try {
          final ref = _firebaseStorage.ref().child('users').child(user.uid).child('profile.jpg');
          final uploadTask = await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
          photoUrl = await uploadTask.ref.getDownloadURL();
        } catch (e) {
          AppLogger.e('Failed to upload image: \$e');
          // Non-fatal error, we can still proceed with user creation
        }
      }

      // 3. Update Auth profile
      await user.updateDisplayName(name);
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // 4. Save to Firestore
      final userEntity = UserEntity(
        id: user.uid,
        email: email,
        displayName: name,
        photoUrl: photoUrl,
        role: 'Owner',
        restaurantId: 'default_restaurant',
      );

      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'displayName': name,
        'photoUrl': photoUrl,
        'role': userEntity.role,
        'restaurantId': userEntity.restaurantId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Right(userEntity);
    } on FirebaseAuthException catch (e) {
      AppLogger.e('FirebaseAuthException: \${e.message}');
      return Left(ServerFailure(message: e.message ?? 'Authentication failed'));
    } catch (e) {
      AppLogger.e('Error during registration: \$e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error during logout: \$e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Right(null);
      }
      return _fetchUserFromFirestore(user.uid, user.email ?? '');
    } catch (e) {
      AppLogger.e('Error getting current user: \$e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserEntity>> _fetchUserFromFirestore(String uid, String email) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (!doc.exists || doc.data() == null) {
        // Fallback for MVP if user doc doesn't exist yet, we create a default one or just return basic
        return Right(UserEntity(
          id: uid,
          email: email,
          role: 'Owner', // Default role if none exists
          restaurantId: 'default_restaurant', 
        ));
      }

      final data = doc.data()!;
      return Right(UserEntity(
        id: uid,
        email: email,
        displayName: data['displayName'] as String?,
        photoUrl: data['photoUrl'] as String?,
        role: data['role'] as String? ?? 'Employee',
        restaurantId: data['restaurantId'] as String? ?? 'default_restaurant',
      ));
    } catch (e) {
      AppLogger.e('Error fetching user from firestore: \$e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
