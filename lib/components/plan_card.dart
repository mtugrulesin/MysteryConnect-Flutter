import 'package:flutter/material.dart';

class MobilePlanCard extends StatelessWidget {
  final String planName;
  final String price;
  final String dataLimit;
  final String talkTime;

  const MobilePlanCard({
    super.key,
    required this.planName,
    required this.price,
    required this.dataLimit,
    required this.talkTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            planName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '\$$price/month',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Icon(Icons.data_usage, size: 16.0, color: Colors.grey[500]),
              SizedBox(width: 8.0),
              Text(dataLimit, style: TextStyle(fontSize: 16.0)),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.call, size: 16.0, color: Colors.grey[500]),
              SizedBox(width: 8.0),
              Text(talkTime, style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ],
      ),
    );
  }
}
