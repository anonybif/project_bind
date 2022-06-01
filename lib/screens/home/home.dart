// ignore_for_file: unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_bind/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/bottom_appbar_widget.dart';
import 'package:project_bind/reusable_widgets/navigation_drawer_widget.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/reusable_widgets/user.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/screens/authenticate/sign_up.dart';
//import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

const _kPages = <String, IconData>{
  'home': Icons.home,
  'write': Icons.add,
  'profile': Icons.account_circle_outlined,
};

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> user = FirebaseFirestore.instance
      .collection('user')
      .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
      .snapshots();
  String userName = '';

  TabStyle _tabStyle = TabStyle.reactCircle;

   var body;
  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;

    var itemList;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        drawer: NaviagtionDrawerWidget(),
        
        backgroundColor: Colors.white,
    
           body: CustomScrollView(
          slivers: [
            
            SliverAppBar(
    
         backgroundColor: Colors.black,
    
             expandedHeight: 300,
             floating: true,
             pinned: true,
            //  toolbarHeight: 100,
             
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset('assets/images/sliv.jpg', 
                
                fit: BoxFit.cover,
                ),
                
                centerTitle: true,
                title: Container(
                  padding: EdgeInsets.fromLTRB(8, 5, 8, 0),
                
                  child: CupertinoTextField(
           
            keyboardType: TextInputType.text,
            placeholder: 'Search',
            placeholderStyle: TextStyle(
              color: Color(0xffC4C6CC),
              fontSize: 14.0,
              fontFamily: 'Brutal',
            ),
            prefix: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
              child: Icon(
                Icons.search,
                size: 18,
                color: Colors.black,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
          ),
          
        ),
    
                ),
                
    //                   Container(
    //                /* child: Text(
    //                   "Find the best service for you",
    //                   style: (fontSize: 35,
    //                   ),
    //                 ), //text
    //                 */
    //                
    
               //  color: Colors.cyan[600],
    // // child: , can enter any widget child here
    //               ),
               // title: Text(' put sth here'),
              ), 
              
              SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
    
                  child: Container(
                    height: 175,
                    color: Colors.black54,
                  ), 
                ), 
              ), 
            ), 
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
    
                  child: Container(
                    height: 175,
                    color: Colors.black54,
                  ), 
                ), 
              ), 
            ), 
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
    
                  child: Container(
                    height: 175,
                    color: Colors.black54,
                  ), 
                ), 
              ), 
            ), 
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
    
                  child: Container(
                    height: 175,
                    color: Colors.black54,
                  ), 
                ), 
              ), 
            ), 
           ],
            ), 
    
    //           
    //            SliverToBoxAdapter(
    //             child: Padding(
    //               padding: const EdgeInsets.all(20.0),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(20),
    
    //                 child: Container(
    //                   height: 400,
    //                   color: Colors.deepPurple[300],
    //                 ), //container
    //               ), //clipRRect
    //             ), //padding
    //           ), //sliverToboxadopter
    //         ],
    //       ), //CustomScrollView
  
      
        // body: CustomScrollView(
          
        //     headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
        //       return <Widget>[
        //       //  createSilverAppBar1(),
        //         createSilverAppBar2(),
        //               SliverToBoxAdapter(
        //       child: Padding(
        //         padding: const EdgeInsets.all(20.0),
        //         child: ClipRRect(
        //           borderRadius: BorderRadius.circular(20),
                  
    
        //           child: Container(
        //             height: 400,
        //             color: Colors.deepPurple[300],
        //           ), //container
        //         ), //clipRRect
        //       ), //padding
        //     ) //sliverToboxadopter
        //       ];
        //     },
        //     body: ListView.builder(
              
             
        //       //  itemCount: itemList.length,
        //         itemBuilder: (context, index) {
        //           return Card(
                    
        //             // child: ListTile(
                      
        //             //   title: Text(itemList]),
        //             // ),
                    
        //           );
        //         }
        //         )
                
        //         ),
                
                bottomNavigationBar: ConvexAppBar.badge(
          // Optional badge argument: keys are tab indices, values can be
          // String, IconData, Color or Widget.
          /*badge=*/ const <int, dynamic>{3: '99+'},
          style: _tabStyle,
          color: Colors.blue,
          //cornerRadius: 20,
    
          backgroundColor: Colors.black87,
          items: <TabItem>[
            for (final entry in _kPages.entries)
              TabItem(icon: entry.value, title: entry.key),
          ],
          onTap: (int i) => print('click index=$i'),
        )
      ),
    );
  }

  // SliverAppBar createSilverAppBar1() {
  //   return SliverAppBar(
      
  //     //backgroundColor: Colors.grey,
  //     expandedHeight: 300,
      
  //     floating: true,
  //     elevation: 0,
  //     flexibleSpace: LayoutBuilder(
  //         builder: (BuildContext context, BoxConstraints constraints) {
  //           return FlexibleSpaceBar(
  //             collapseMode: CollapseMode.none,
  //             background: Container(
  //               color: Colors.white,
  //               child: Image.asset(
  //                 'assets/images/bar.jpg',
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }

  // SliverAppBar createSilverAppBar2() {
  //   return SliverAppBar(
  //     backgroundColor: Colors.grey[50],
  //     pinned: true,
  //     expandedHeight: 300,
      
  //     title: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 10),
  //       height: 40,
        
  //       decoration: BoxDecoration(
  //         boxShadow: <BoxShadow>[
  //           BoxShadow(
  //               color: Colors.grey.withOpacity(0.6),
  //               offset: const Offset(1.1, 1.1),
  //               blurRadius: 5.0),
  //         ],
  //       ),
  //       
       

   
    
  }
  

  fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
      //  userName = ds.data()!["Username"];
      }).catchError((e) {
        print(e);
      });
    }
  }


class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}

