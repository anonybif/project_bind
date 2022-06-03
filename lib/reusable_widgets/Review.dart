import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewManagement {
  Map reviewData = Map<String, dynamic>();

  storeNewReview(json, context) async {
    final docRef = FirebaseFirestore.instance
        .collection('business')
        .doc('mR2hVOogJqDvH9d5I2Z8')
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

  updateReviewLikes(String Rid, String operation) async {
    final ds = await FirebaseFirestore.instance
        .collection('business')
        .doc('mR2hVOogJqDvH9d5I2Z8')
        .collection('review')
        .where('Rid', isEqualTo: Rid)
        .get();
    for (var doc in ds.docs) {
      reviewData = doc.data();
      var ref = doc.reference;

      if (operation == 'plus') {
        var likes = double.parse(reviewData["Likes"].toString()) + 1;
        setReviewLikes(ref, likes);
      } else if (operation == 'minus') {
        var likes = double.parse(reviewData["Likes"].toString()) - 1;
        setReviewLikes(ref, likes);
      }
    }
  }

  setReviewLikes(DocumentReference docRef, double likes) async {
    docRef.update({'Likes': likes});
  }
}
