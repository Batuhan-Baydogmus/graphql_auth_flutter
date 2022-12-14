import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:video_player/video_player.dart';

const productsGraphQL = """
query products{
products(first:30, channel: "default-channel"){
    edges {
      node {
        id
        name
        description
        thumbnail {
          url
        }
      }
    }
  }
}
""";

class SecondPage extends StatefulWidget {
  final String? username;
  final String? password;

  const SecondPage({
    Key? key,
    required this.username,
    required this.password,
  }) : super(key: key);
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final VideoPlayerController _video =
      VideoPlayerController.asset('assets/videos/SecondPageVideo2.mp4');
  String? password;
  String? username;
  @override
  void initState() {
    super.initState();
    _video.setVolume(0);
    _video.setLooping(true);
    _video.play();
    _video.initialize().then((void value) => setState(() {}));
  }

// This is for to get username to this screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 13),
          child: FloatingActionButton.extended(
            label: const Text('Back'),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            backgroundColor: Color.fromARGB(255, 97, 93, 93).withOpacity(0.7),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,

        /*  appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.1),
          title: const Text('Second Page'),
        ), */

        body: Stack(children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _video.value.size.width,
                height: _video.value.size.height,
                child: VideoPlayer(_video),
              ),
            ),
          ),
          Query(
              options: QueryOptions(document: gql(productsGraphQL)),
              builder: (QueryResult result, {fetchMore, refetch}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                if (result.isLoading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                          strokeWidth: 5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Loading Please Wait..',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  );
                }
                final productList = result.data?['products']['edges'];

                // print(productList);

                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 77,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: Colors.white.withOpacity(0.5)))),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        // Welcome user name section with big letters
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome back: $username",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Container for list and appbar space.
                    Container(height: 22),
                    Expanded(
                        child: GridView.builder(
                            itemCount: productList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisSpacing: 3.0,
                                    crossAxisSpacing: 3.0,
                                    childAspectRatio: 0.9),
                            itemBuilder: (_, index) {
                              var product = productList[index]['node'];
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 0.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orangeAccent
                                              .withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0, 0),
                                          // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    width: 200,
                                    height: 200,
                                    // For pictures rounded.
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(30),
                                        child: Image.network(
                                            product['thumbnail']['url'],
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text(
                                      product['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              );
                            }))
                  ],
                );
              }),
        ]));
  }
}
