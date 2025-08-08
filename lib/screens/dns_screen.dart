import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:orban_vpn_desktop/controllers/home_controller.dart';

import '../controllers/laungage_controller.dart';
import '../helpers/pref.dart';

class DnsScreen extends StatefulWidget {
  @override
  _DnsScreenState createState() => _DnsScreenState();
}

class _DnsScreenState extends State<DnsScreen> {
  late bool isDnsEnabled;
  late String vpnMode;
  late String dnsRecord;

  final LanguageController languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    isDnsEnabled = Pref.isDnsEnabled;
    vpnMode = Pref.isVPNMode;
    dnsRecord = Pref.dnsRecord;
  }

  void _toggleDns(bool value) {
    setState(() {
      isDnsEnabled = value;
      Pref.isDnsEnabled = value;
    });
  }

  void _editDnsRecord(String? existingRecord) async {
    String? newRecord = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String inputText = existingRecord ?? '';
        return AlertDialog(
          title: Text(existingRecord == null
              ? languageController.translate('add_dns_record')
              : languageController.translate('edit_dns_record')),
          content: TextField(
            controller: TextEditingController(text: inputText),
            onChanged: (value) => inputText = value,
            decoration: InputDecoration(
                hintText: languageController.translate('enter_dns_server')),
          ),
          actions: [
            TextButton(
              child: Text(languageController.translate('cancel')),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(languageController.translate('save')),
              onPressed: () => Navigator.pop(context, inputText),
            ),
          ],
        );
      },
    );

    if (newRecord != null && newRecord.isNotEmpty) {
      setState(() {
        dnsRecord = newRecord;
        Pref.dnsRecord = dnsRecord;
      });
    }
  }

  void _changeVpnMode() async {
    String? selectedMode = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['VPN', 'System Proxy'].map((mode) {
              return ListTile(
                title: Text(mode),
                onTap: () => Navigator.pop(context, mode),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedMode != null) {
      setState(() {
        vpnMode = selectedMode;
        Pref.isVPNMode = selectedMode;
      });
    }
  }

  Future<void> _resetNetwork() async {
    var shell = Shell();

    try {
      Pref.clearAuthData();
      await shell.run('netsh winsock reset');
      await shell.run('netsh int ip reset');

      Get.snackbar(
        "Success",
        "Network settings reset. Restart your PC to apply changes.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to reset network: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageController.translate('dns_management'),
          style: Get.theme.textTheme.bodyMedium!
              .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        leadingWidth: 80,
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xff3A3A4D).withOpacity(0.5),
              child: ListTile(
                title: Text(
                  languageController.translate('enable_dns'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(languageController.translate('dns_processed')),
                trailing: Switch(
                  value: isDnsEnabled,
                  onChanged: _toggleDns,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xff3A3A4D).withOpacity(0.5),
              child: ListTile(
                title: Text(
                  languageController.translate('vpn_dns'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(dnsRecord),
                onTap: () => _editDnsRecord(dnsRecord),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xff3A3A4D).withOpacity(0.5),
              child: ListTile(
                title: Text(
                  languageController.translate('mode'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: Text(languageController.translate(vpnMode)),
                onTap: _changeVpnMode,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xff3A3A4D).withOpacity(0.5),
              child: ListTile(
                title: Text(
                  languageController.translate('Reset Network'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: ElevatedButton.icon(
                  onPressed: _resetNetwork,
                  icon: Icon(Icons.refresh),
                  label: Text("Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ),
            GetBuilder<HomeController>(builder: (controller) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        languageController.translate('logs'),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                          onPressed: () {
                            controller.logs.forEach((element) {
                              Clipboard.setData(ClipboardData(text: element));
                            });
                          },
                          icon: Icon(Icons.copy_outlined))
                    ],
                  ),
                  SizedBox(
                    height: Get.height / 4,
                    child: ListView.builder(
                        itemCount: controller.logs.length,
                        itemBuilder: (context, index) => SelectableText(
                              controller.logs[index],
                            )),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
