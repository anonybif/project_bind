import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewManagement {
  Map reviewData = Map<String, dynamic>();

  storeNewReview(json, context, String Bid) async {
    final docRef = FirebaseFirestore.instance
        .collection('business')
        .doc(Bid)
        .collection('review')
        .doc();
    final docId = docRef.id;

    await docRef.set(json).catchError((e) {
      print(e);
    });
    setReviewId(docRef, docId);
  }

  setReviewId(DocumentReference docRef, String docId) async {
    docRef.update({'Rid': docId});
  }

  updateReviewLikes(String Rid, String operation, String Bid) async {
    final ds = await FirebaseFirestore.instance
        .collection('business')
        .doc(Bid)
        .collection('review')
        .where('Rid', isEqualTo: Rid)
        .get();
    for (var doc in ds.docs) {
      reviewData = doc.data();
      var ref = doc.reference;
      List<String> LikedUserUid = <String>[];
      LikedUserUid = List.from(reviewData['LikedUserUid']);
      LikedUserUid.removeWhere((element) => element == '');

      if (operation == 'plus') {
        var likes = double.parse(reviewData["Likes"].toString()) + 1;
        var Uid = FirebaseAuth.instance.currentUser!.uid;
        LikedUserUid.add(Uid);
        setReviewLikes(ref, likes, LikedUserUid);
      } else if (operation == 'minus') {
        var likes = double.parse(reviewData["Likes"].toString()) - 1;
        var Uid = FirebaseAuth.instance.currentUser!.uid;
        LikedUserUid.removeWhere((element) => element == Uid);
        setReviewLikes(ref, likes, LikedUserUid);
      }
    }
  }

  setReviewLikes(
      DocumentReference docRef, double likes, List<String> LikedUserUid) async {
    docRef.update({'Likes': likes});
    docRef.update({'LikedUserUid': LikedUserUid});
  }
}
