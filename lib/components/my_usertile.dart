import 'package:flutter/material.dart';

class UserTile extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, required this.onTap});

  @override
  State<UserTile> createState() => _MyUsertileState();
}

class _MyUsertileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
      
        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            //icon
            const Icon(Icons.person),

            const SizedBox(width: 10,),

            //username
            Text(widget.text),
          ],
        ),
      ),
    );
  }
}
