import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // I-initialize ang Firebase gamit ang direktang configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

// --- Direktang isinama ang Firebase Options dito ---
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCt7M9sBNUqdaruPmkOwULTILRy0iQVHS0',
    appId: '1:952290748592:web:533da93ff766dfc620f375',
    messagingSenderId: '952290748592',
    projectId: 'mybiodata-8e9ef',
    authDomain: 'mybiodata-8e9ef.firebaseapp.com',
    storageBucket: 'mybiodata-8e9ef.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCt7M9sBNUqdaruPmkOwULTILRy0iQVHS0',
    appId: '1:952290748592:web:533da93ff766dfc620f375',
    messagingSenderId: '952290748592',
    projectId: 'mybiodata-8e9ef',
    storageBucket: 'mybiodata-8e9ef.firebasestorage.app',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biodata App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BiodataScreen(),
    );
  }
}

class BiodataScreen extends StatefulWidget {
  const BiodataScreen({Key? key}) : super(key: key);

  @override
  _BiodataScreenState createState() => _BiodataScreenState();
}

class _BiodataScreenState extends State<BiodataScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para sa Personal at Educational details
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  
  // Educational Background Controllers
  final _schoolController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearLevelController = TextEditingController();

  // Skills and Hobbies Controllers
  final _skillsController = TextEditingController();
  final _hobbiesController = TextEditingController();

  Future<void> _saveBiodata() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('biodata').add({
          'name': _nameController.text,
          'age': int.tryParse(_ageController.text) ?? 0,
          'gender': _genderController.text,
          'birthdate': _birthdateController.text,
          'contactNumber': _contactController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'school': _schoolController.text,
          'course': _courseController.text,
          'yearLevel': _yearLevelController.text,
          'skills': _skillsController.text,
          'hobbies': _hobbiesController.text,
          'createdAt': Timestamp.now(),
        });

        // Linisin ang mga fields pagkatapos i-save
        _nameController.clear();
        _ageController.clear();
        _genderController.clear();
        _birthdateController.clear();
        _contactController.clear();
        _emailController.clear();
        _addressController.clear();
        _schoolController.clear();
        _courseController.clear();
        _yearLevelController.clear();
        _skillsController.clear();
        _hobbiesController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biodata successfully saved to Firebase!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Biodata Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter age' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _genderController,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      validator: (value) => value!.isEmpty ? 'Enter gender' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _birthdateController,
                decoration: const InputDecoration(labelText: 'Birthdate (e.g., Month Day, Year)'),
                validator: (value) => value!.isEmpty ? 'Please enter your birthdate' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Please enter contact number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Please enter email address' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 24),
              
              // Educational Background Section
              const Text(
                'Educational Background',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _schoolController,
                decoration: const InputDecoration(labelText: 'School / University Name'),
                validator: (value) => value!.isEmpty ? 'Please enter school name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course / Program (e.g., BSIT)'),
                validator: (value) => value!.isEmpty ? 'Please enter your course' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _yearLevelController,
                decoration: const InputDecoration(labelText: 'Year Level (e.g., 3rd Year)'),
                validator: (value) => value!.isEmpty ? 'Please enter your year level' : null,
              ),
              const SizedBox(height: 24),

              // Skills & Hobbies Section
              const Text(
                'Skills & Hobbies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(labelText: 'Skills (e.g., Flutter, Dart, SQL)'),
                maxLines: 2,
                validator: (value) => value!.isEmpty ? 'Please enter your skills' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hobbiesController,
                decoration: const InputDecoration(labelText: 'Hobbies & Interests'),
                maxLines: 2,
                validator: (value) => value!.isEmpty ? 'Please enter your hobbies' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveBiodata,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Save Biodata to Firebase', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}