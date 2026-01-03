import 'package:flutter/material.dart';
import '../network/mqtt.dart';
import 'reusablecards.dart';
import '../screens/login_screen.dart';

getDrawerWidget(
  int index,
  BuildContext context,
  MQTTClientWrapper mqttClient,
  Function updateState,
) {
  switch (index) {
    case 0:
      return _homeListView(context, mqttClient, updateState);
    case 1:
      return _analyticsView(context);
    case 2:
      return _profileView(context, mqttClient);
  }
}

Widget _homeListView(
  BuildContext context,
  MQTTClientWrapper mqttClient,
  Function updateState,
) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 16.0, 16.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                if (mqttClient.connectionState !=
                    MqttCurrentConnectionState.CONNECTED)
                  ElevatedButton.icon(
                    onPressed: () async {
                      await mqttClient.connectClient();
                      if (mqttClient.connectionState ==
                          MqttCurrentConnectionState.CONNECTED) {
                        mqttClient.subscribeToTopics([
                          '/temperature',
                          '/humidity',
                          '/rfidstatus',
                          '/powerstatus',
                        ]);
                      }
                      updateState();
                    },
                    icon: const Icon(Icons.link, size: 18),
                    label: const Text('Connect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff21b409),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                if (mqttClient.connectionState ==
                    MqttCurrentConnectionState.CONNECTED)
                  ElevatedButton.icon(
                    onPressed: () {
                      mqttClient.subscribeToTopics([
                        '/temperature',
                        '/humidity',
                        '/rfidstatus',
                        '/powerstatus',
                      ]);
                      updateState();
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Subscribe'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                if (mqttClient.connectionState ==
                    MqttCurrentConnectionState.CONNECTED)
                  const SizedBox(width: 8),
                if (mqttClient.connectionState ==
                    MqttCurrentConnectionState.CONNECTED)
                  ElevatedButton.icon(
                    onPressed: () {
                      mqttClient.client.disconnect();
                      updateState();
                    },
                    icon: const Icon(Icons.link_off, size: 18),
                    label: const Text('Disconnect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView(
          children: <Widget>[
            // MQTT Connection Status Card
            GestureDetector(
              onTap: () async {
                if (mqttClient.connectionState !=
                    MqttCurrentConnectionState.CONNECTED) {
                  await mqttClient.connectClient();
                  updateState();
                }
              },
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      mqttClient.connectionState ==
                          MqttCurrentConnectionState.CONNECTED
                      ? Colors.green[100]
                      : Colors.red[100],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          mqttClient.connectionState ==
                                  MqttCurrentConnectionState.CONNECTED
                              ? Icons.cloud_done
                              : Icons.cloud_off,
                          color:
                              mqttClient.connectionState ==
                                  MqttCurrentConnectionState.CONNECTED
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                        const SizedBox(width: 10),
                        Text(
                          mqttClient.connectionState ==
                                  MqttCurrentConnectionState.CONNECTED
                              ? 'MQTT Connected'
                              : 'MQTT Disconnected',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                mqttClient.connectionState ==
                                    MqttCurrentConnectionState.CONNECTED
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                        if (mqttClient.connectionState !=
                            MqttCurrentConnectionState.CONNECTED)
                          const SizedBox(width: 10),
                        if (mqttClient.connectionState !=
                            MqttCurrentConnectionState.CONNECTED)
                          Icon(Icons.refresh, size: 20, color: Colors.red[700]),
                      ],
                    ),
                    if (mqttClient.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          mqttClient.errorMessage!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            ReusableCard(
              colour: (Colors.blue[100])!,
              text: 'Temperature & Humidity',
              mqttClient: mqttClient,
              topics: const ['/temperature', '/humidity'],
            ),
            ReusableCard(
              colour: (Colors.orange[100])!,
              text: 'RFID Status',
              mqttClient: mqttClient,
              topics: const ['/rfidstatus'],
            ),
            ReusableCard(
              colour: (Colors.purple[100])!,
              text: 'Power Status',
              mqttClient: mqttClient,
              topics: const ['/powerstatus'],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _profileView(BuildContext context, MQTTClientWrapper mqttClient) {
  return Column(
    children: [
      const SizedBox(height: 20.0),
      Expanded(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  print('profile tapped');
                },
                child: Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  alignment: Alignment.center,
                  child: const CircleAvatar(radius: 80.0),
                ),
              ),
              title: const Text('Hi, User'),
              trailing: GestureDetector(
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      // title: const Text('AlertDialog Title'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Disconnect MQTT before logout
                            mqttClient.client.disconnect();
                            // Navigate to login screen
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              LoginScreen.id,
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(
                  Icons.power_settings_new_sharp,
                  color: Colors.red,
                  size: 36,
                ),
              ),
              dense: false,
            ),
            const SizedBox(height: 20.0),
            const Card(child: ListTile(title: Text('Change Login Password'))),
            const Card(child: ListTile(title: Text('About Us'))),
          ],
        ),
      ),
    ],
  );
}

Widget _analyticsView(BuildContext context) {
  // Sample data - replace with actual data from your backend
  final List<Map<String, dynamic>> analyticsData = [
    {'sno': 1, 'datetime': '2026-01-03 10:30', 'value': '23.5', 'user': 'John'},
    {'sno': 2, 'datetime': '2026-01-03 11:15', 'value': '24.1', 'user': 'Mary'},
    {'sno': 3, 'datetime': '2026-01-03 12:00', 'value': '22.8', 'user': 'Alex'},
    {'sno': 4, 'datetime': '2026-01-03 13:45', 'value': '25.3', 'user': 'John'},
    {
      'sno': 5,
      'datetime': '2026-01-03 14:20',
      'value': '23.9',
      'user': 'Sarah',
    },
  ];

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Analytics Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.blue[100]),
              border: TableBorder.all(color: Colors.grey[300]!),
              columns: const [
                DataColumn(
                  label: Text(
                    'SNo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Datetime',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Value',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'User',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: analyticsData
                  .map(
                    (data) => DataRow(
                      cells: [
                        DataCell(Text(data['sno'].toString())),
                        DataCell(Text(data['datetime'])),
                        DataCell(Text(data['value'])),
                        DataCell(Text(data['user'])),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    ],
  );
}
