import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  List post = [];
  List data = [];
  var dio = Dio();

  @override
  void initState() {
    fetchData();

    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Lazy Loading data"),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: isLoadingMore ?data.length+1 : data.length,
        itemBuilder: (context, index) {
          if(index < data.length){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  title: Text("${data[index]['title']}", style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(data[index]['body']),
                ),
              ),
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
  Future<void> fetchData() async{
    /*
    * Note:
    * in api without limit & skip or page we can't add add lazy loading..
    * */



    const url = "https://jsonplaceholder.typicode.com/posts";

    final response = await dio.get(url);
    if(response.statusCode == 200){
      setState(() {
        post = response.data;
        data = List.from(post.take(14));
      });

    }

  }

  void _scrollListener() async{
    // if(isLoadingMore) return;
    if (scrollController.position.pixels >=
         scrollController.position.maxScrollExtent) {

      setState(() {
        isLoadingMore = true;
      });

      setState(() {
        for(int i=0; i<data.length+14; i++){
          data = post;
        }
      });

      // await fetchData();
      setState(() {
        isLoadingMore = false;
      });
      print("call");
    }
    else{
      // print("don't call");
    }
  }
}
