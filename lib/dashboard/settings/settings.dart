import 'package:aquatrack/dashboard/settings/pages/feedback.dart';
import 'package:aquatrack/dashboard/settings/utils/share_dialog.dart';
import 'package:aquatrack/dashboard/settings/utils/update_dialog.dart';
import 'package:aquatrack/main.dart';
import 'package:aquatrack/utils/routes.dart';
import 'package:aquatrack/utils/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final UserService _userService = UserService();

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Remove login status

    // Navigate back to the login screen
    Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      // Fetch the user ID first
      future: _userService.getUserId(),
      builder: (context, userIdSnapshot) {
        if (userIdSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userIdSnapshot.hasError) {
          return Center(child: Text('Error: ${userIdSnapshot.error}'));
        }

        if (!userIdSnapshot.hasData) {
          return const Center(child: Text('No user logged in'));
        }

        String userId = userIdSnapshot.data!;

        // Use the user ID to fetch the user settings
        return FutureBuilder<DocumentSnapshot>(
          future: _userService.getUserSettings(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No user data found'));
            }

            // Extract the data using your helper function
            var userData = _userService.getUserDataFromSnapshot(snapshot.data!);
            String age = userData['Age'] ?? 0;
            double targetIntake = userData['targetIntake'] ?? 0.0;
            String gender = userData['Gender'] ?? 'Not Set';
            String wakeupTime = userData['Wake-up Time'] ?? 'Not Set';
            String bedtime = userData['Bedtime'] ?? 'Not Set';
            String weight = userData['Weight'] ?? 0.0;

            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Options Section
                    _buildSectionHeader('Settings'),
                    _buildListTile(
                      'assets/images/notification.png',
                      'Notifications',
                      '',
                      () {
                        Navigator.pushNamed(
                            context, MyRoutes.notificationRoute);
                      },
                      context,
                    ),
                    _buildListTile(
                      'assets/images/theme.png',
                      'Theme',
                      '',
                      null,
                      context,
                      trailing: Switch(
                        value: Provider.of<ThemeModel>(context).mode ==
                            ThemeMode.dark,
                        onChanged: (_) =>
                            Provider.of<ThemeModel>(context, listen: false)
                                .toggleTheme(),
                      ),
                    ),
                    _buildListTile(
                      'assets/images/ribbon.png',
                      'Daily Goal',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$targetIntake ml',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => UpdateDialog(
                                  fieldName: 'Daily Goal',
                                  userId: userId,
                                  onSave: (newValue) async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .update({
                                      'targetIntake': double.parse(newValue)
                                    });
                                    setState(() {}); // Refresh UI
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildListTile(
                      'assets/images/gender.png',
                      'Gender',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$gender',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => UpdateDialog(
                                  fieldName: 'Gender',
                                  userId: userId,
                                  onSave: (newValue) async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .update({'Gender': newValue});
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildListTile(
                      'assets/images/age-group.png',
                      'Age',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$age',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => UpdateDialog(
                                  fieldName: 'Age',
                                  userId: userId,
                                  onSave: (newValue) async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .update({'Age': newValue});
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildListTile(
                      'assets/images/weight.png',
                      'Weight',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$weight',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => UpdateDialog(
                                  fieldName: 'Weight',
                                  userId: userId,
                                  onSave: (newValue) async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .update({'Weight': newValue});
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildListTile(
                      'assets/images/sun.png',
                      'Wake-up Time',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$wakeupTime',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => UpdateDialog(
                                  fieldName: 'Wake-up Time',
                                  userId: userId,
                                  onSave: (newValue) async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .update({'Wake-up Time': newValue});
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildListTile(
                      'assets/images/moon-settings.png',
                      'Bedtime',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$bedtime',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => UpdateDialog(
                                  fieldName: 'Bedtime',
                                  userId: userId,
                                  onSave: (newValue) async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .update({'Bedtime': newValue});
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    _buildSectionHeader('Support'),
                    _buildListTile(
                      'assets/images/share.png',
                      'Share',
                      '',
                      () {
                        showDialog(
                          context: context,
                          builder: (context) => const ShareDialog(),
                        );
                      },
                      context,
                    ),
                    _buildListTile(
                      'assets/images/review.png',
                      'Feedback',
                      '',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FeedbackPage()),
                        );
                      },
                      context,
                    ),
                    _buildListTile(
                      'assets/images/insurance.png',
                      'Privacy Policy',
                      '',
                      () {
                        // Add privacy policy functionality here
                      },
                      context,
                    ),
                    const Divider(),
                    _buildListTile(
                      'assets/images/logout.png',
                      'Logout',
                      '',
                      () => _logout(),
                      context,
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildListTile(
    String imagePath,
    String title,
    String value,
    VoidCallback? onTap,
    BuildContext context, {
    Widget? trailing,
  }) {
    // Use the provided trailing widget or assign a default one based on title
    Widget defaultTrailing;
    if (trailing != null) {
      defaultTrailing = trailing;
    } else if (['Notifications', 'Share', 'Feedback', 'Privacy Policy']
        .contains(title)) {
      defaultTrailing =
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey);
    } else if (title == 'Theme') {
      defaultTrailing = Switch(
        value: Provider.of<ThemeModel>(context).mode == ThemeMode.dark,
        onChanged: (_) =>
            Provider.of<ThemeModel>(context, listen: false).toggleTheme(),
        activeColor: Colors.blue[800],
      );
    } else {
      defaultTrailing = Text(
        value,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
        ),
      );
    }

    return ListTile(
      leading: Image.asset(
        imagePath,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        width: 30,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: defaultTrailing,
      ),
      onTap: onTap,
    );
  }
}
