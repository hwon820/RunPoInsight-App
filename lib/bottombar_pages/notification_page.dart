import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/long_polling_service.dart';
import '/notifications_model.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<LongPollingService>(context, listen: false).startListening();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Provider.of<LongPollingService>(context, listen: false).stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Notifications'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<NotificationModel>(
              builder: (context, notificationModel, child) => Text(
                notificationModel.lastMessage.isNotEmpty
                    ? notificationModel.lastMessage
                    : "Waiting for messages...",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
