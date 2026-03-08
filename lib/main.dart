import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BankEdge Prep',
      theme: ThemeData(
        primaryColor: const Color(0xff1e3c72),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1e3c72)),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) return const DashboardScreen();
          return const LoginScreen();
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
// 1. BRANDED LOGIN SCREEN (With Account Picker Fix)
// ------------------------------------------------------------------
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // Forces the account selection dialog
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1e3c72), Color(0xff2a5298)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "BANK EDGE",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2),
            ),
            const Text("Your Path to Banking Success",
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login),
                    SizedBox(width: 12),
                    Text("Continue with Google",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// 2. DASHBOARD (MAIN NAVIGATION)
// ------------------------------------------------------------------
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const PlaceholderTab(
        title: "Mock Tests",
        subtitle: "Full-length mock tests are coming soon!"),
    const PlaceholderTab(
        title: "Leaderboard",
        subtitle: "Rankings will be available after the next live mock."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BankEdge Prep",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xff1e3c72),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xff1e3c72),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Tests"),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: "Ranking"),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// 3. HOME TAB (With Personalized Profile Header)
// ------------------------------------------------------------------
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String fullName = user?.displayName ?? "Aspirant";
    String firstName = fullName.split(' ')[0];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PERSONALIZED PROFILE HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xff1e3c72),
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? const Icon(Icons.person, color: Colors.white, size: 30)
                    : null,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome, $firstName!",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(user?.email ?? "Banking Aspirant",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 35),

          // EXAM PORTAL CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xff1e3c72), Color(0xff2a5298)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xff1e3c72).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.campaign, color: Colors.amber, size: 28),
                    SizedBox(width: 10),
                    Text("EXAM PORTAL",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 15),
                const Text("Upcoming Bank Exams",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const Text(
                    "Select from the latest banking recruitment exams and start your practice.",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExamListScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xff1e3c72),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("View All Exams",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// 4. PLACEHOLDER TAB (Non-Functional)
// ------------------------------------------------------------------
class PlaceholderTab extends StatelessWidget {
  final String title;
  final String subtitle;
  const PlaceholderTab(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// 5. EXAM LIST SCREEN
// ------------------------------------------------------------------
class ExamListScreen extends StatelessWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Upcoming Exams"),
          backgroundColor: const Color(0xff1e3c72),
          foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Questions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final exams = snapshot.data!.docs
              .map((doc) => doc['exam'].toString())
              .toSet()
              .toList();
          if (exams.isEmpty)
            return const Center(child: Text("No exams found in database."));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final examId = exams[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.account_balance,
                      color: Color(0xff1e3c72)),
                  title: Text(examId.replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StageScreen(examId: examId))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
// 6. STAGE SCREEN (Prelims / Mains)
// ------------------------------------------------------------------
class StageScreen extends StatelessWidget {
  final String examId;
  const StageScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    final stages = ['prelims', 'mains'];
    return Scaffold(
      appBar: AppBar(title: Text(examId.replaceAll('_', ' ').toUpperCase())),
      body: ListView.builder(
        itemCount: stages.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(stages[index].toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SectionScreen(examId: examId, stage: stages[index])),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// 7. SECTION SCREEN
// ------------------------------------------------------------------
class SectionScreen extends StatelessWidget {
  final String examId;
  final String stage;
  const SectionScreen({super.key, required this.examId, required this.stage});

  @override
  Widget build(BuildContext context) {
    final sections = [
      {'label': 'English Language', 'dbValue': 'english'},
      {'label': 'Reasoning Ability', 'dbValue': 'reasoning'},
      {'label': 'Quantitative Aptitude', 'dbValue': 'quantitative_aptitude'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("${stage.toUpperCase()} Sections")),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.edit_note, color: Color(0xff1e3c72)),
          title: Text(sections[index]['label']!),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                examId: examId,
                stage: stage,
                subject: sections[index]['dbValue']!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// 8. FINAL QUIZ SCREEN
// ------------------------------------------------------------------
class QuizScreen extends StatefulWidget {
  final String examId;
  final String stage;
  final String subject;

  const QuizScreen(
      {super.key,
      required this.examId,
      required this.stage,
      required this.subject});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<int, int?> selectedAnswers = {};
  Map<int, bool> showExplanations = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.subject.replaceAll('_', ' ').toUpperCase())),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Questions')
            .where('exam', isEqualTo: widget.examId)
            .where('stage', isEqualTo: widget.stage)
            .where('subject', isEqualTo: widget.subject)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty)
            return const Center(child: Text("No questions found."));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final qData = docs[index].data() as Map<String, dynamic>;
              final options = List<String>.from(qData['options'] ?? []);
              final correctAns = qData['answer'];

              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Q${index + 1}: ${qData['question']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 15),
                      ...List.generate(options.length, (oIndex) {
                        bool isCorrect = options[oIndex] == correctAns;
                        bool isPicked = selectedAnswers[index] == oIndex;
                        Color? tileColor;
                        if (selectedAnswers[index] != null) {
                          if (isCorrect)
                            tileColor = Colors.green.withOpacity(0.15);
                          else if (isPicked)
                            tileColor = Colors.red.withOpacity(0.15);
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              color: tileColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: RadioListTile<int>(
                            title: Text(options[oIndex]),
                            value: oIndex,
                            groupValue: selectedAnswers[index],
                            onChanged: (val) {
                              setState(() {
                                selectedAnswers[index] = val;
                                showExplanations[index] = true;
                              });
                            },
                          ),
                        );
                      }),
                      if (showExplanations[index] == true)
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("Explanation: ${qData['explanation']}",
                              style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontStyle: FontStyle.italic)),
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
