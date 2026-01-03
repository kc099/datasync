import 'dart:async';
import 'dart:math';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// connection states for easy identification
enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING,
}

enum MqttSubscriptionState { IDLE, SUBSCRIBED }

class MQTTClientWrapper {
  late MqttServerClient client;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;
  String? errorMessage;

  // Store messages for each topic
  final Map<String, String> topicMessages = {};
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _subscription;

  MQTTClientWrapper() {
    // Generate unique client ID to prevent reconnection conflicts
    final clientId = 'brothers_${Random().nextInt(100000)}';
    client = MqttServerClient.withPort('13.203.2.58', clientId, 1883);

    // Lightweight initialization only - heavy work moved to connectClient
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  // using async tasks, so the connection won't hinder the code flow
  void prepareMqttClient() {
    // _setupMqttClient();
    // await _connectClient();
    // _subscribeToTopic('indusrain/home/test');
    // _publishMessage('Hello');
  }

  // waiting for the connection, if an error occurs, print it and disconnect
  Future<void> connectClient() async {
    // If already connected, don't reconnect
    if (connectionState == MqttCurrentConnectionState.CONNECTED) {
      return;
    }

    // Disconnect any existing connection first
    if (client.connectionStatus?.state == MqttConnectionState.connected ||
        client.connectionStatus?.state == MqttConnectionState.connecting) {
      client.disconnect();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      connectionState = MqttCurrentConnectionState.CONNECTING;
      errorMessage = null;
      // Connect with anonymous auth (no username/password for allow_anonymous = true)
      await client.connect();
    } on Exception catch (e) {
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      errorMessage = 'Exception: $e';
      client.disconnect();
      return;
    }

    // when connected, print a confirmation, else print an error
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      errorMessage = null;
    } else {
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      errorMessage =
          'Failed: ${client.connectionStatus?.returnCode?.toString() ?? "Unknown error"}';
      client.disconnect();
    }
  }

  void subscribeToTopics(List<String> topics) {
    if (connectionState != MqttCurrentConnectionState.CONNECTED) {
      return;
    }

    for (final topic in topics) {
      client.subscribe(topic, MqttQos.atMostOnce);
    }

    // Listen for incoming messages
    _subscription?.cancel();
    _subscription = client.updates!.listen((
      List<MqttReceivedMessage<MqttMessage>>? messages,
    ) {
      if (messages == null || messages.isEmpty) return;

      for (final message in messages) {
        final recMess = message.payload as MqttPublishMessage;
        final content = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );
        topicMessages[message.topic] = content;
      }
    });
  }

  String? getMessageForTopic(String topic) {
    return topicMessages[topic];
  }

  void publishMessage(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    // print('Publishing message "$message" to topic ${'indus/home/test'}');
    client.publishMessage(
      'indus/home/test',
      MqttQos.exactlyOnce,
      builder.payload!,
    );
    // print('Published.');
  }

  // callbacks for different events
  void _onSubscribed(String topic) {
    // print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    // print('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    // print('OnConnected client callback - Client connection was successful');
  }
}
