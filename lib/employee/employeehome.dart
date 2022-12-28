import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:searchjob/employee/searchJob.dart';
import 'package:searchjob/employee/viewJob.dart';
class employeeHome extends StatefulWidget {
  @override
  _employeeHomeState createState() => _employeeHomeState();
}

class _employeeHomeState extends State<employeeHome> {
  DateTime now= DateTime.now();
  String btn= 'Apply';
  User? user= FirebaseAuth.instance.currentUser;
  List field= ['Marketing', 'Management', 'House-cleaning', 'Engineering', 'Plumbing', 'Carpentry',  'Developing','Babysitting', 'Writing', 'Teaching','Cooking','Others'];
  bool isLoading= false;
  TextEditingController fieldcontroller = TextEditingController();
  TextEditingController citycontroller = TextEditingController();
  InterstitialAd? _interstitialAd;
  int num_of_attempt_load = 0;
  static initialization(){
    if(MobileAds.instance == null)
    {
      MobileAds.instance.initialize();
    }
  }
  void createInterad(){
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-4619363086776822/3536279234',
      request: AdRequest(),
      adLoadCallback:InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad){
            _interstitialAd = ad;
            num_of_attempt_load =0;
          },
          onAdFailedToLoad: (LoadAdError error){
            num_of_attempt_load +1;
            _interstitialAd = null;
            if(num_of_attempt_load<=2){
              createInterad();
            }
          }),
    );
  }
// show interstitial ads to user
  void showInterad(){
    if(_interstitialAd == null){
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad){
          print("ad onAdshowedFullscreen");
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad){
          print("ad Disposed");
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror){
          print('$ad OnAdFailed $aderror');
          ad.dispose();
          createInterad();
        }
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading==false?
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextFormField(
                  style: TextStyle(color: Colors.brown, fontSize: 20),
                  decoration: InputDecoration(
                    hintText: 'Field',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    prefix: Padding(
                      padding: EdgeInsets.all(4),
                    ),
                  ),
                  controller: fieldcontroller,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10,),
              child: TextFormField(
                  style: TextStyle(color: Colors.brown, fontSize: 20),
                  decoration: InputDecoration(
                    hintText: 'City',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    prefix: Padding(
                      padding: EdgeInsets.all(4),
                    ),
                  ),
                  controller: citycontroller,
              ),
            ),
            Container(
              margin:  const EdgeInsets.only(top: 20,),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.brown[200]!, Colors.brown],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                  border: Border.all(
                    color: Colors.white,
                  ),
              ),
              height: 50,
              width: double.infinity,
              child: FlatButton(
                onPressed: () {
                  final String f= fieldcontroller.text;
                  final String c= citycontroller.text;
                  if(f.isEmpty&& c.isEmpty){}
                  else
                    {
                      createInterad();
                      showInterad();
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => searchJob(f, c)));
                    }
                },
                child: Row(
                  children: [
                    Text(
                      'Search Jobs',
                      style: TextStyle(color: Colors.white60, fontSize: 20, fontWeight: FontWeight.bold ),
                    ),
                    Icon(Icons.navigate_next, color: Colors.white60,)
                  ],
                ),
              ),),
            Container(
              color: Colors.white,
              height: 70,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  children: [
                    Text('  Browse by Categories  ', style: TextStyle(color: Colors.brown[400], fontWeight: FontWeight.bold, fontSize: 20),),
                    Icon(Icons.next_plan_outlined, color: Colors.brown[400],)
                  ],
                ),
              ),
            ),
            GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 4.0,
                crossAxisCount:3,
                childAspectRatio:  1/1.8,

              ),
              shrinkWrap: true,
              physics: new ClampingScrollPhysics(),
              children: field.map((doc)
              {
                return Container(
                  child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          createInterad();
                          showInterad();
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => searchJob(doc, '')));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 6),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset('assets/images/${doc}.jpg')
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(

                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0),
                                ),
                              ),
                              child: ListTile(
                                tileColor: Colors.brown[300],
                                title: Text(doc, style: TextStyle(fontSize: 12),),
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                );
              }).toList(),
            ),
            Container(
              color: Colors.white,
              height: 70,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  children: [
                    Text('  Recommended Jobs  ', style: TextStyle(color: Colors.brown[400], fontWeight: FontWeight.bold, fontSize: 20),),
                    Icon(Icons.next_plan_outlined, color: Colors.brown[400],)
                  ],
                ),
              ),
            ),

            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Employees")
                  .doc(user!.uid)
                  .snapshots(),
    builder:
    (context, snap) {
                DocumentSnapshot document= snap.data!;
      return
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Jobs")
              .where('category', isEqualTo: document['field'])
              .snapshots(),
          builder:
              (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown)));
            }
            return snapshot.data!.size>0?
              Stack(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
                      ),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: new ClampingScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      return Card(
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.brown[500]!, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text('Job: ' + doc['title'],
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                doc['status'] == 'closed' ?
                                Container()
                                    : StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance.collection(
                                        'Employees')
                                        .doc(user!.uid)
                                        .collection('Bookmarks')
                                        .doc(doc.id)
                                        .snapshots(),
                                    builder: (context, snapsh) {
                                      if (snapsh.hasError) {
                                        return Text('Something went wrong');
                                      }

                                      if (snapsh.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown)));
                                      }
                                      return InkWell(
                                          onTap: () {
                                            if (snapsh.data!.exists == false) {
                                              FirebaseFirestore.instance.collection(
                                                  'Employees')
                                                  .doc(user!.uid)
                                                  .collection('Bookmarks')
                                                  .doc(doc.id)
                                                  .set(
                                                  { 'employer': doc['employer'],
                                                    'applicants': doc['applicants'],
                                                    'title': doc['title'],
                                                    'min': doc['min'],
                                                    'max': doc['max'],
                                                    'timeperiod': doc['timeperiod'],
                                                    'range': doc['range'],
                                                    'office': doc['office'],
                                                    'city': doc['city'],
                                                    'state': doc['state'],
                                                    'about': doc['about'],
                                                    'status': doc['status'],
                                                    'date': doc['date'],
                                                    'time': doc['time'],
                                                    'id': doc.id});
                                            }
                                            else {
                                              FirebaseFirestore.instance.collection(
                                                  'Employees')
                                                  .doc(user!.uid)
                                                  .collection('Bookmarks')
                                                  .doc(doc.id)
                                                  .delete();
                                            }
                                          },
                                          child: Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: snapsh.data!.exists== false?
                                              Icon(Icons.bookmark_border, color: Colors.black, size: 34,)
                                                  : Icon(Icons.bookmark, color: Colors.black, size: 34,)
                                          )
                                      );
                                    }
                                ),
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('₹${doc['min']}- ₹${doc['max']}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('${doc['timeperiod']} ${doc['range']}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                         trailing:
                          doc['status'] == 'closed' ?
                          Text(doc["status"].toUpperCase(), style: TextStyle(
                              color: Colors.redAccent, fontSize: 26),) :Text(''),

                           onTap: (){
                             createInterad();
                             showInterad();
                            Navigator.push(context,MaterialPageRoute(builder: (context) => viewJob(doc['title'],doc['max'],doc['min'],doc['timeperiod'],doc['range'],doc['office'],doc['city'],doc['state'],doc['about'],doc['date'],doc['time'],doc['status'],doc.id, doc['applicants'], doc['employer'], 'fromjob')));
                            },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
                :Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                height: 80,
                child: ListTile(
                tileColor: Colors.black12,
                leading: Icon(Icons.error_outline, size: 70,),
                title: Text('Sorry, there are no Recommended Jobs for your Field ${document['field']}'),
                ),
                ),
                );
          }
      );
    }
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
      ), ),
    );
  }
}
