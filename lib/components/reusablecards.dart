import 'package:flutter/material.dart';
import '../network/mqtt.dart';
import 'dart:async';

class ReusableCard extends StatefulWidget {
  const ReusableCard({
    Key? key,
    required this.colour,
    required this.text,
    required this.mqttClient,
    required this.topics,
  }) : super(key: key);

  final Color colour;
  final String text;
  final MQTTClientWrapper mqttClient;
  final List<String> topics;

  @override
  State<ReusableCard> createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard> {
  Timer? _timer;
  Map<String, String> _messages = {};

  @override
  void initState() {
    super.initState();
    // Poll for messages every 500ms
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _messages = {};
          for (final topic in widget.topics) {
            final message = widget.mqttClient.getMessageForTopic(topic);
            if (message != null) {
              _messages[topic] = message;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.colour,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_messages.isEmpty)
            const Text(
              'No data received',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ..._messages.entries.map((entry) {
            final topicName = entry.key.split('/').last;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$topicName:',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
