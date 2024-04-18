import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// 데이터 유지되게

// 추후 이 데이터를 서버로 보내야함.
// 서버에 저장하는 key -> 대회명
class MarathonRecord {
  String name; // 대회명
  String date;
  String event;
  String record;
  String pace;
  File? image;

  MarathonRecord({
    required this.name,
    required this.date,
    required this.event,
    required this.record,
    required this.pace,
    this.image,
  });

  // json 형태로 변환
  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'event': event,
        'record': record,
        'pace': pace,
        'imagePath': image?.path
      };

  // Map 형성    -> 나중엔 map에 맞춰 저장...?
  factory MarathonRecord.fromJson(Map<String, dynamic> json) {
    return MarathonRecord(
      name: json['name'],
      date: json['date'],
      event: json['event'],
      record: json['record'],
      pace: json['pace'],
      image: json['imagePath'] != null ? File(json['imagePath']) : null,
    );
  }
}

class CumulReport extends StatefulWidget {
  const CumulReport({Key? key}) : super(key: key);

  @override
  _CumulReportState createState() => _CumulReportState();
}

class _CumulReportState extends State<CumulReport> {
  List<MarathonRecord> _marathonRecords = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _recordController = TextEditingController();
  final TextEditingController _paceController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 기록 추가 함수
  void _addMarathonRecord() {
    if (_nameController.text.isNotEmpty && _dateController.text.isNotEmpty) {
      setState(() {
        _marathonRecords.insert(
          0,
          MarathonRecord(
            name: _nameController.text,
            date: _dateController.text,
            event: _eventController.text,
            record: _recordController.text,
            pace: _paceController.text,
            image: _image,
          ),
        );
      });
      saveRecords(); // 데이터 저장
      _clearFields(); // 필드 초기화
      Navigator.of(context).pop(); // Close dialog
    }
  }

  // 필드 초기화 함수
  void _clearFields() {
    _nameController.clear();
    _dateController.clear();
    _eventController.clear();
    _recordController.clear();
    _paceController.clear();
    _image = null;
  }

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  // 기록 삭제 함수
  void _deleteMarathonRecord(int index) {
    setState(() {
      _marathonRecords.removeAt(index);
    });
    saveRecords(); // 변경사항 파일에 저장
  }

  Future<String> get _localPath async {
    final directory = await getApplicationCacheDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/marathon_records.json');
  }

  Future<void> saveRecords() async {
    try {
      final file = await _localFile;
      List<Map<String, dynamic>> jsonRecords =
          _marathonRecords.map((record) => record.toJson()).toList();
      String jsonString = json.encode(jsonRecords);
      await file.writeAsString(jsonString);
      print('Data saved to $file');
    } catch (e) {
      print('Failed to save data: $e');
    }
  }

  Future<void> loadRecords() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonResponse = json.decode(contents);
      setState(() {
        _marathonRecords =
            jsonResponse.map((data) => MarathonRecord.fromJson(data)).toList();
      });
      print('Data loaded from $file');
    } catch (e) {
      print('Failed to load data: $e');
      _marathonRecords = [];
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('누적 기록',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.black26,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: _marathonRecords.length,
        itemBuilder: (context, index) {
          var record = _marathonRecords[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Card(
              color: Colors.white.withAlpha(220),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Color.fromARGB(255, 243, 243, 243),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      title: Center(
                        child: Text(
                          record.name,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 100, 0),
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "참가 날짜",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black.withAlpha(210),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "종목",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black.withAlpha(210),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "완주 기록",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black.withAlpha(210),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "페이스(Pace)",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black.withAlpha(210),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 60,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${record.date}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color:
                                              Color.fromARGB(255, 255, 100, 0)
                                                  .withAlpha(220),
                                        ),
                                      ),
                                      Text(
                                        "${record.event}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color:
                                              Color.fromARGB(255, 255, 100, 0)
                                                  .withAlpha(220),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "${record.record}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color:
                                              Color.fromARGB(255, 255, 100, 0)
                                                  .withAlpha(220),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "${record.pace}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color:
                                              Color.fromARGB(255, 255, 100, 0)
                                                  .withAlpha(220),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (record.image != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 20),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(record.image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 180,
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 100, 0)
                                            .withAlpha(200),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    '기록 삭제',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    _deleteMarathonRecord(index); // 기록 삭제
                                  },
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: record.image != null
                                ? FileImage(record.image!)
                                : AssetImage('assets/placeholder_image.jpg')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${record.name} (${record.event})",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(record.date, style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                    ),
                    backgroundColor: Color.fromARGB(255, 51, 51, 51),
                    title: Center(
                      child: Text(
                        '새로운 기록',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 100, 0),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                await _pickImage();
                                setState(() {}); // Update dialog UI
                              },
                              child: Container(
                                height: 150,
                                width: 150,
                                color: Colors.grey,
                                child: _image != null
                                    ? Image.file(_image!, fit: BoxFit.cover)
                                    : Icon(
                                        Icons.add_photo_alternate,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            SizedBox(height: 25),
                            SizedBox(
                              width: 230,
                              height: 45,
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: ' 대회명',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  fillColor: Color.fromARGB(255, 51, 51, 51),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withAlpha(80)),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: 230,
                              height: 45,
                              child: TextField(
                                controller: _dateController,
                                decoration: InputDecoration(
                                  hintText: ' 참가 날짜',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  fillColor: Color.fromARGB(255, 51, 51, 51),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withAlpha(80)),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: 230,
                              height: 45,
                              child: TextField(
                                controller: _eventController,
                                decoration: InputDecoration(
                                  hintText: ' 종목',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  fillColor: Color.fromARGB(255, 51, 51, 51),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withAlpha(80)),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: 230,
                              height: 45,
                              child: TextField(
                                controller: _recordController,
                                decoration: InputDecoration(
                                  hintText: ' 완주 기록',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  fillColor: Color.fromARGB(255, 51, 51, 51),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withAlpha(80)),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: 230,
                              height: 45,
                              child: TextField(
                                controller: _paceController,
                                decoration: InputDecoration(
                                  hintText: ' 페이스(pace)',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  fillColor: Color.fromARGB(255, 51, 51, 51),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withAlpha(80)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 260,
                              height: 46,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 100, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  '추가',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: _addMarathonRecord,
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 255, 100, 0),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CumulReport(),
  ));
}
