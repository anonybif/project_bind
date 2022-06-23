import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewManagement {
  Map reviewData = Map<String, dynamic>();

  storeNewReview(json, context, String Bid, String Uid) async {
    final docRef = FirebaseFirestore.instance
        .collection('business')
        .doc(Bid)
        .collection('review')
        .doc();
    final docId = docRef.id;

    await docRef.set(json).catchError((e) {
      print(e);
    });
    final userRef = FirebaseFirestore.instance.collection('user').doc(Uid);
    var ds = await userRef.get();
    var reviews = ds.data()!['Reviews'];
    reviews = reviews + 1;
    setUserReviews(userRef, reviews);
    setReviewId(docRef, docId);
  }

  setReviewId(DocumentReference docRef, String docId) async {
    docRef.update({'Rid': docId});
  }

  setUserReviews(DocumentReference userRef, double reviews) async {
    userRef.update({'Reviews': reviews});
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
      final userRef = reviewData['Uid'];

      var ref = doc.reference;
      List<String> LikedUserUid = <String>[];
      LikedUserUid = List.from(reviewData['LikedUserUid']);
      LikedUserUid.removeWhere((element) => element == '');

      if (operation == 'plus') {
        var likes = double.parse(reviewData["Likes"].toString()) + 1;
        var Uid = FirebaseAuth.instance.currentUser!.uid;
        LikedUserUid.add(Uid);
        setReviewLikes(ref, likes, LikedUserUid);
        setUserLikes(userRef, likes);
      } else if (operation == 'minus') {
        var likes = double.parse(reviewData["Likes"].toString()) - 1;
        var Uid = FirebaseAuth.instance.currentUser!.uid;
        LikedUserUid.removeWhere((element) => element == Uid);
        setReviewLikes(ref, likes, LikedUserUid);
        setUserLikes(userRef, likes);
      }
    }
  }

  Future setReviewLikes(
      DocumentReference docRef, double likes, List<String> LikedUserUid) async {
    docRef.update({'Likes': likes});
    docRef.update({'LikedUserUid': LikedUserUid});
    print('likes');
  }

  Future setUserLikes(DocumentReference docRef, double likes) async {
    docRef.update({'Likes': likes});

    print('likes');
  }

  Future reportReview(String Bid, String Rid) async {
    var doc = await FirebaseFirestore.instance
        .collection('business')
        .doc(Bid)
        .collection('review')
        .doc(Rid)
        .get();

    reviewData = doc.data()!;
    var ref = doc.reference;

    var reports = double.parse(reviewData['Reports'].toString());
    reports = reports + 1;
    setReviewReports(reports, ref);
  }

  setReviewReports(
    double reports,
    DocumentReference docRef,
  ) async {
    docRef.update({'Reports': reports});
  }
}
