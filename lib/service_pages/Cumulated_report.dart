import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../user_model.dart';
import '../utils.dart';

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
  String _selectedEvent = '종목 선택';
  final TextEditingController _recordController = TextEditingController();
  final TextEditingController _paceController = TextEditingController();

  final List<String> _eventlist = [
    '종목 선택',
    '풀(Full)',
    '하프(Half)',
    '10km 로드',
    '5km'
  ];

  @override
  void initState() {
    super.initState();
    loadRecords();
    _validateSelectedEvent();
  }

  void _validateSelectedEvent() {
    if (!_eventlist.contains(_selectedEvent)) {
      setState(() {
        _selectedEvent = _eventlist.first;
      });
    }
  }

  File? _image;

  // 이미지 가져오기
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 이미지 Url로 변경.. 은 어떻게 하지

  // 날짜 선택
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date to today's date
      firstDate: DateTime(
          2000), // Users can select a date as far back as the year 2000
      lastDate:
          DateTime(2100), // Users can select a date up until the year 2100
    );
    if (pickedDate != null) {
      // Format the date and update the text field
      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
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
            event: _selectedEvent,
            record: _recordController.text,
            pace: _paceController.text,
            image: _image,
          ),
        );
        _validateSelectedEvent(); // 기록을 추가한 후 유효성 검사
      });
      saveRecords(); // 데이터 저장
      _clearFields(); // 필드 초기화
      Navigator.of(context).pop(); // 다이얼로그 닫기
    }
  }

  // 서버에 보내기
  void _handleUpdate() {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    Map<String, dynamic> newDetails = {
      'date': _dateController.text,
      'event_name': _nameController.text,
      'number_img': _image?.path, // 이미지 경로만 전송
      'pace': _paceController.text,
      'record': _recordController.text,
      'run_type': _selectedEvent
    };

    // newDetails를 castMap 함수로 타입 변환하여 String key를 가진 Map으로 변환
    newDetails = castMap(newDetails);

    // userModel.name을 추가하여 사용자 구분 가능
    userModel.updateMarathonDetails(
        userModel.name, _dateController.text, newDetails);

    userModel.updateRunDetails('http://192.168.0.13:5000/users', 1, newDetails);
  }

  // 필드 초기화 함수
  void _clearFields() {
    _nameController.clear();
    _dateController.clear();
    _selectedEvent = "종목";
    _recordController.clear();
    _paceController.clear();
    _image = null;
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
        _validateSelectedEvent(); // 이 부분을 추가
      });
    } catch (e) {
      print('Failed to load data: $e');
      _marathonRecords = [];
      _validateSelectedEvent(); // 여기도 추가
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(238, 241, 98, 3),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          iconSize: 40,
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Color.fromARGB(238, 241, 98, 3),
      body: ListView.builder(
        itemCount: _marathonRecords.length,
        itemBuilder: (context, index) {
          var record = _marathonRecords[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Card(
              elevation: 8.0,
              color: Color.fromRGBO(22, 22, 22, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Color.fromARGB(255, 255, 100, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: Stack(clipBehavior: Clip.none, children: <
                                Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(18.0),
                                      top: Radius.circular(50)),
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ListBody(
                                      children: [
                                        // 배번표 사진
                                        SizedBox(
                                          height: 100,
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "참가 날짜",
                                                  style:
                                                      GoogleFonts.nanumGothic(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17,
                                                    color: Colors.black
                                                        .withAlpha(210),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Text(
                                                  "종목",
                                                  style:
                                                      GoogleFonts.nanumGothic(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17,
                                                    color: Colors.black
                                                        .withAlpha(210),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Text(
                                                  "완주 기록",
                                                  style:
                                                      GoogleFonts.nanumGothic(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17,
                                                    color: Colors.black
                                                        .withAlpha(210),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Text(
                                                  "페이스(Pace)",
                                                  style:
                                                      GoogleFonts.nanumGothic(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17,
                                                    color: Colors.black
                                                        .withAlpha(210),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 35),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${record.date}",
                                                  style:
                                                      GoogleFonts.nanumGothic(
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                            255, 255, 100, 0)
                                                        .withAlpha(220),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Text(
                                                  "${record.event}",
                                                  style:
                                                      GoogleFonts.nanumGothic(
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                            255, 255, 100, 0)
                                                        .withAlpha(220),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Text(
                                                  "${record.record}",
                                                  style:
                                                      GoogleFonts.nanumGothic(
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                            255, 255, 100, 0)
                                                        .withAlpha(220),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Text(
                                                  "${record.pace}",
                                                  style:
                                                      GoogleFonts.nanumGothic(
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                            255, 255, 100, 0)
                                                        .withAlpha(220),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                      255, 255, 100, 0)
                                                  .withAlpha(220),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: Text(
                                              '기록 삭제',
                                              style: GoogleFonts.nanumGothic(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // 다이얼로그 닫기
                                              _deleteMarathonRecord(
                                                  index); // 기록 삭제
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (record.image != null)
                                Positioned(
                                  top: -75,
                                  left: 50,
                                  right: 50,
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: FileImage(record.image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                            ]),
                          ),
                        );
                      });
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // 그림자 색상과 투명도 설정
                              spreadRadius: 1, // 그림자의 확장 범위
                              blurRadius: 5, // 그림자의 흐릿한 정도
                              offset: Offset(0, 0), // 그림자의 위치 조정 (가로, 세로)
                            ),
                          ],
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
                            Row(
                              children: [
                                Text(
                                  record.name,
                                  style: GoogleFonts.nanumGothic(
                                    color: Colors.white.withAlpha(230),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  " ${record.event}",
                                  style: GoogleFonts.nanumGothic(
                                    color: Colors.white.withAlpha(230),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 7),
                            Text(
                              record.date,
                              style: GoogleFonts.nanumGothic(
                                fontSize: 13,
                                color: Colors.white.withAlpha(230),
                              ),
                            ),
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
                        style: GoogleFonts.nanumGothic(
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
                                setState(() {});
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
                                  hintStyle: GoogleFonts.nanumGothic(
                                      color: Colors.white.withAlpha(80)),
                                ),
                                style: GoogleFonts.nanumGothic(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: 230,
                              height: 45,
                              child: TextFormField(
                                controller: _dateController,
                                decoration: InputDecoration(
                                  hintText: '날짜 선택',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 51, 51, 51),
                                  hintStyle: GoogleFonts.nanumGothic(
                                      color: Colors.white.withAlpha(80)),
                                ),
                                style: GoogleFonts.nanumGothic(
                                  color: Colors.white,
                                ),
                                readOnly: true,
                                onTap: () {
                                  _selectDate(context);
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: 230,
                              height: 45,
                              child: Container(
                                width: 230,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white), // 보더 라인 추가
                                  borderRadius:
                                      BorderRadius.circular(20.0), // 보더 라운드 처리
                                  color:
                                      Color.fromARGB(255, 51, 51, 51), // 배경색 설정
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 11.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedEvent,
                                      style: GoogleFonts.nanumGothic(
                                          color: Colors.white.withAlpha(80),
                                          fontSize: 16),
                                      items: _eventlist.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedEvent =
                                              newValue ?? _eventlist.first;
                                        });
                                      },
                                    ),
                                  ),
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
                                  hintStyle: GoogleFonts.nanumGothic(
                                      color: Colors.white.withAlpha(80)),
                                ),
                                style: GoogleFonts.nanumGothic(
                                  color: Colors.white,
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
                                  hintStyle: GoogleFonts.nanumGothic(
                                      color: Colors.white.withAlpha(80)),
                                ),
                                style: GoogleFonts.nanumGothic(
                                  color: Colors.white,
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
                                  style: GoogleFonts.nanumGothic(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  _handleUpdate();
                                  _addMarathonRecord();
                                },
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
          size: 30,
          color: Color.fromARGB(255, 255, 100, 0),
        ),
        backgroundColor: Color.fromRGBO(22, 22, 22, 1),
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
