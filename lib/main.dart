import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dynamic_color_demo/service_pages/Cumulated_report.dart';
import 'package:dynamic_color_demo/service_pages/analysis_page.dart';
import 'package:dynamic_color_demo/bottombar_pages/bookmark_page.dart';
import 'package:dynamic_color_demo/widgets/circular_border_avatar.dart';
import 'package:dynamic_color_demo/widgets/my_container.dart';
import 'package:dynamic_color_demo/service_pages/my_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'user_model.dart';
import 'bottombar_pages/notification_page.dart';
import 'bottombar_pages/bookmark_page.dart';
import 'bottombar_pages/settings_page.dart';

void main() {
  Config.init(); // Config 설정 초기화
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserModel()),
    ],
    child: const DynamicColorDemo(),
  ));
}

// void main() {
//   Config.init();
//   runApp(const DynamicColorDemo());
// }

// 돈 터치 영역
const seedColor = Colors.white;
const outPadding = 25.0;

class DynamicColorDemo extends StatelessWidget {
  const DynamicColorDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        // 이 부분 함부로 건들지 맙시다...
        theme: ThemeData(
          colorSchemeSeed: seedColor,
          brightness: Brightness.dark,
          textTheme: GoogleFonts.notoSansNKoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: SplashScreen());
  }
}
//----------------

// 로딩 화면
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color.fromRGBO(20, 20, 20, 0),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 90),
                Image.network(
                  'https://i.ibb.co/DQ0356M/logo-beta.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Text(
                  "Getting ready to run...",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 로그인 화면
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 성공 여부 판단
  void _attemptLogin() async {
    var response = await http.get(
      Uri.parse('${Config.serverUrl}'), // 서버에서 모든 사용자 데이터를 가져오는 API 주소
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> userDataList = json.decode(response.body);
      // userDataList는 서버에서 받은 모든 사용자 목록입니다.

      // 입력한 ID와 Password를 가진 사용자를 찾습니다.
      var userData = userDataList.firstWhere(
          (user) =>
              user['identifier'] == _idController.text &&
              user['password'] == _passwordController.text,
          orElse: () => null);

      if (userData != null) {
        // 사용자 데이터를 찾았으면 UserModel에 저장하고 메인 화면으로 이동합니다.
        Provider.of<UserModel>(context, listen: false).setUser(userData);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        // 일치하는 사용자가 없을 경우 로그인 실패 메시지를 보여줍니다.
        _showErrorMessage(context, "Invalid identifier or password.");
      }
    } else {
      // 서버 연결 실패 시 메시지 표시
      _showErrorMessage(context, "Failed to connect to the server.");
    }
  }

  // 로그인 실패시 알람 띄우는 함수
  void _showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "로그인 실패",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(20, 20, 20, 0),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 160,
                ),
                // ID 입력
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "ID",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  width: 330,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ), // TextField 내부에 약간의 여백을 제공
                  child: TextField(
                    controller: _idController,
                    style: TextStyle(color: Colors.white), // 텍스트 필드 내의 글자 색상 설정
                    decoration: InputDecoration(
                      hintText: "아이디를 입력하세요", // 사용자에게 힌트 제공
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.3)), // 힌트 텍스트 스타일
                      border: InputBorder.none, // 테두리 없앰
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10), // 세로 방향 패딩 조절
                    ),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                // Password 입력
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  width: 330,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ), // TextField 내부에 약간의 여백을 제공
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true, // 비밀번호 입력 필드로 만듦
                    style: TextStyle(color: Colors.white), // 텍스트 필드 내의 글자 색상 설정
                    decoration: InputDecoration(
                      hintText: "비밀번호를 입력하세요", // 사용자에게 힌트 제공
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.3)), // 힌트 텍스트 스타일
                      border: InputBorder.none, // 테두리 없앰
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10), // 세로 방향 패딩 조절
                    ),
                  ),
                ),

                const SizedBox(
                  height: 80,
                ),

                // 로그인 버튼
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Container(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _attemptLogin,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        backgroundColor: Color.fromRGBO(255, 94, 0, 1),
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Main Page - BottomBar Navigation
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selected = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    BookmarkScreen(),
    NotificationScreen(),
    SettingsScreen(), // 설정 페이지 나중 구현
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 20, 20, 0),
      body: IndexedStack(
        index: _selected,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        elevation: 0,
        onTap: (selected) {
          setState(() {
            _selected = selected;
          });
        },
        selectedItemColor: Color.fromRGBO(255, 94, 0, 1),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 35,
              ),
              label: "Home",
              backgroundColor: Color.fromRGBO(20, 20, 20, 0)),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_outline_outlined,
                size: 35,
              ),
              label: "Bookmarks",
              backgroundColor: Color.fromRGBO(20, 20, 20, 0)),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_outlined,
                size: 35,
              ),
              label: "Notifications",
              backgroundColor: Color.fromRGBO(20, 20, 20, 0)),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_outlined,
                size: 35,
              ),
              label: "Settings",
              backgroundColor: Color.fromRGBO(20, 20, 20, 0)),
        ],
      ),
    );
  }
}

// 진짜 main home
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final name = userModel.name; // 사용자 이름 가져오기

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(outPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.directions_run_outlined,
                  color: Color(0xFFFF5E00),
                  size: 35,
                ),
                Text(
                  " Run Po Insight",
                  style: TextStyle(
                    color: Color.fromRGBO(255, 94, 0, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: Container()),
                CircularBorderAvatar(
                  'https://i.ibb.co/YjNpQq7/cloudJ.jpg',
                  borderColor: Colors.black,
                  size: 45,
                )
              ],
            ),
            const SizedBox(
              height: outPadding,
            ),
            Text(
              ' 안녕하세요! $name 님,',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              ' 달릴 준비되셨나요?',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(
              height: 12,
            ),
            const _TopCard(),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    ' 나의 러닝 일지',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _ActionBtn()
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          flex: 3,
                          child: MyContainer(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CumulReport()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '누적 기록',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Text(
                                  " ",
                                  style: TextStyle(fontSize: 2),
                                ),
                                Text(
                                  '나의 결실을 확인하세요',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: outPadding,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          flex: 2,
                          child: MyContainer(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyInfo()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '내 정보',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          color: Colors.black,
                                          fontSize: 27,
                                          fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  " ",
                                  style: TextStyle(fontSize: 2),
                                ),
                                Text(
                                  '맞춤 분석에 사용돼요',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 27)
          ],
        ),
      ),
    );
  }
}

// 도움말 버튼
class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color.fromRGBO(255, 94, 0, 1),
          width: 2.0,
        ),
      ),
      child: Icon(
        Icons.question_mark_rounded,
        color: Color.fromRGBO(255, 94, 0, 1),
        size: 20,
      ),
    );
  }
}

// 자세분석결과 조회 버튼
class _TopCard extends StatelessWidget {
  const _TopCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyContainer(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnalysisPage()),
        );
      },
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.orange[700]!,
          Colors.orange[500]!,
          Colors.orange[300]!,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            '자세 분석 결과 조회',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
          ),
          Text(
            '내 러닝 습관을 알아보세요',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
