import 'package:flutter/material.dart';
import 'subject_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1e3c72),
              Color(0xff2a5298),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              const SizedBox(height: 30),

              const Text(
                "IBPS Prep",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Prepare for IBPS & Govt Exams",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [

                        const SizedBox(height: 20),

                        buildCard(
                          context,
                          icon: Icons.quiz,
                          title: "Mock Tests",
                          subtitle: "Practice real exam questions",
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SubjectScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        buildCard(
                          context,
                          icon: Icons.menu_book,
                          title: "Study Notes",
                          subtitle: "Important exam notes",
                          color: Colors.orange,
                          onTap: () {},
                        ),

                        const SizedBox(height: 20),

                        buildCard(
                          context,
                          icon: Icons.trending_up,
                          title: "Daily Quiz",
                          subtitle: "Improve your accuracy daily",
                          color: Colors.green,
                          onTap: () {},
                        ),

                        const SizedBox(height: 20),

                        buildCard(
                          context,
                          icon: Icons.leaderboard,
                          title: "Leaderboard",
                          subtitle: "Compare with other students",
                          color: Colors.purple,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),

        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),

            const SizedBox(width: 18),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const Spacer(),

            const Icon(Icons.arrow_forward_ios, size: 18)
          ],
        ),
      ),
    );
  }
}