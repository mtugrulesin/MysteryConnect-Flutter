import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:MysteryConnect/network/entity/user.dart';
import '../utilities/constants.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key, required this.path});
  final String path;
  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  double _photoCount = 1;
  bool m = false;
  bool f = false;
  int _groupValue = 0;

  Future<dynamic> sendPhoto(
      String userId, File imageFile, String gender, int count) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://$baseIP/api/v1/photo/sendViaFilters"));
    request.files.add(http.MultipartFile(
        'imageFile', imageFile.readAsBytes().asStream(), imageFile.lengthSync(),
        filename: imageFile.path.split("/").last));
    request.fields['userId'] = userId;
    request.fields['gender'] = gender;
    request.fields['count'] = count.toString();

    await request.send();
  }

  @override
  Widget build(BuildContext context) {
    User user = userTemp;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 16,
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Gender             "),
                const Text("Male"),
                Radio(
                  value: 0,
                  groupValue: _groupValue,
                  onChanged: (newValue) =>
                      setState(() => _groupValue = newValue!),
                ),
                const Text("Female"),
                Radio(
                  value: 1,
                  groupValue: _groupValue,
                  onChanged: (newValue) =>
                      setState(() => _groupValue = newValue!),
                )
              ],
            ),
            Row(
              children: [
                const Text("Count         "),
                SliderTheme(
                  data: const SliderThemeData(
                      valueIndicatorColor: Colors.blue,
                      disabledThumbColor: Colors.black,
                      // valueIndicatorTextStyle: TextStyle(color: valueIndicatorColor, fontWeight: FontWeight.bold),
                      valueIndicatorTextStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  child: Slider(
                    min: 1,
                    max: 10,
                    thumbColor: Colors.blue,
                    activeColor: Colors.blue,
                    overlayColor: MaterialStateProperty.all(Colors.amber),
                    inactiveColor: Colors.lightBlueAccent,
                    divisions: 10,
                    value: _photoCount,
                    onChanged: (value) {
                      setState(() {
                        _photoCount = value;
                      });
                    },
                    label: _photoCount.round().toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(width: 3, color: Colors.blue),
                  ))),
              onPressed: () {
                print(_groupValue);
                sendPhoto(user.id, File(widget.path),
                        (_groupValue == 0) ? "M" : "F", _photoCount.toInt())
                    .then((value) => {
                          Navigator.of(context).pop(),
                          Navigator.of(context).pop(),
                        });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Send",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "assets/dia.png",
                    height: 18,
                  ),
                  const Text(
                    "5",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
