import 'package:flutter/material.dart';
import 'package:job_finder/views/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllWorkersWidget extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final String phone;
  final String userImageUrl;

  const AllWorkersWidget({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.phone,
    required this.userImageUrl,
  }) : super(key: key);

  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {

  void _mailTo() async{
    final Uri params = Uri(
      scheme: 'mailto',
      path: widget.userEmail,
      query:
      'subject=Write Subject Here&body=Hello, please write details.',
    );
    final url = params.toString();
    launchUrlString(url);

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white10,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(userId: widget.userId),
            ),
          );
        },
        contentPadding: const EdgeInsets.only(right: 12),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(
              widget.userImageUrl == null
                  ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
                  : widget.userImageUrl,
            ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text("Visit Profile",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey,
            ),)
          ],
        ),
        trailing: IconButton(
          onPressed: (){
            _mailTo();
          },
          icon: Icon(Icons.mail_outline,
          size: 30,
          color: Colors.grey,),
        ),
      ),
    );
  }
}
