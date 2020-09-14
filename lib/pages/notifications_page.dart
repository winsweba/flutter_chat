import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/home_page.dart';
import 'package:flutter_chat/pages/post_srcreen_page.dart';
import 'package:flutter_chat/pages/profile_page.dart';
import 'package:flutter_chat/widget/header_widget.dart';
import 'package:flutter_chat/widget/progress_widget.dart';
import 'package:timeago/timeago.dart' as tAgo;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,strTitle: "Notification"),
      body: Container(
        child: FutureBuilder(
          future: retrieveNotifications(),
          builder: (context, dataSnapshot){
            if(!dataSnapshot.hasData){
              return circularProgress();
            }
            return ListView(children: dataSnapshot.data,);
          },
        ),
      ),
    );
  }

  retrieveNotifications () async{
    QuerySnapshot querySnapshot = await activityFeedReference.document(currentUser.id)
    .collection("feedItems").orderBy("timestamp", descending: true)
    .limit(60).getDocuments();

    List<NotificationsItem> notificationsItem = [];
    
    querySnapshot.documents.forEach((document) {
      notificationsItem.add(NotificationsItem.fromDocument(document));
     });
     return notificationsItem;
  }
}

String notificationItemText;
Widget mediaPreview;

class NotificationsItem extends StatelessWidget {
  
  final String username;
  final String type;
  final String commentData;
  final String postId;
  final String userId;
  final String userProfileImg;
  final String url;
  final Timestamp timestamp;

  NotificationsItem({this.username, this.type, this.commentData, this.postId, this.userId, this.userProfileImg, this.url, this.timestamp});

  factory NotificationsItem.fromDocument(DocumentSnapshot documentSnapshot){
    return NotificationsItem(
      username: documentSnapshot["username"],
      type: documentSnapshot["type"],
      commentData: documentSnapshot["commentData"],
      postId: documentSnapshot["postId"],
      userId: documentSnapshot["userId"],
      userProfileImg: documentSnapshot["userProfileImg"],
      url: documentSnapshot["url"],
      timestamp: documentSnapshot["timestamp"],
    );
  }

  @override
  Widget build(BuildContext context) {

  configureMediaPrivew(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => disPlayUserProfile(context, userProfileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(fontSize: 14.0, color: Colors.black),
                children: [
                  TextSpan(text: username, style: TextStyle(fontWeight: FontWeight.bold),),
                  TextSpan(text: " $notificationItemText"),
                ]
              )
              ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(tAgo.format(timestamp.toDate()),overflow: TextOverflow.ellipsis,),
          trailing: mediaPreview,
        ),
      ),
      
    );
  }

  configureMediaPrivew(context){

    if (type == "comment" || type == "like") {
      mediaPreview = GestureDetector(
        onTap: () => disPlayFullPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(url)),
              )
            ),
            ),
        ),
      );
    }

    else{
      mediaPreview = Text("");
    }

    if (type == "like" ) {
      notificationItemText = "Liked your post.";
    }

    else if (type == "comment" ) {
      notificationItemText = "replied: $commentData";
    }
    else if (type == "follow" ) {
      notificationItemText = "started following you.";
    }
    else{
      notificationItemText = "Error, Unknown type = $type";
    }

  }

  disPlayFullPost(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreenPage(postId: postId, userId: userId,) ));
  }

  disPlayUserProfile(BuildContext context, {String userProfileId}){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userProfileId: userProfileId) ));
  }
}