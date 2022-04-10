import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_memo/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final commentController = TextEditingController();
  String title = '';
  String comment = '';
  bool icon = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      title = prefs.getString(titleKey)!;
      comment = prefs.getString(commentKey)!;
      icon = prefs.getBool(iconKey)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Simple Memo',
                style: TextStyle(fontSize: 38.0, fontWeight: FontWeight.w100),
              ),
              ListTile(
                leading: icon == false
                    ? const Icon(Icons.chat_bubble_outline)
                    : const Icon(Icons.chat),
                tileColor: Colors.white24,
                title: Text(title),
                subtitle: Text(comment),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'タイトルを入力してね'),
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(hintText: 'コメントを入力してね'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString(titleKey, titleController.text);
                      prefs.setString(commentKey, commentController.text);
                      prefs.setBool(iconKey, true);
                      setState(() {
                        title = prefs.getString(titleKey)!;
                        comment = prefs.getString(commentKey)!;
                        prefs.setBool(iconKey, true);
                        if (title != '' && comment != '') {
                          icon = true;
                        }
                      });
                    },
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      setState(() {
                        icon = false;
                        title = '';
                        titleController.text = '';
                        comment = '';
                        commentController.text = '';
                        prefs.remove(titleKey);
                        prefs.remove(commentKey);
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
