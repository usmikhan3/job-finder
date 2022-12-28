import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_finder/services/global_variables.dart';
import 'package:job_finder/widgets/all_companies_widget.dart';
import 'package:job_finder/widgets/bottom_nav_bar.dart';

class AllWorkerScreen extends StatefulWidget {
  @override
  State<AllWorkerScreen> createState() => _AllWorkerScreenState();
}

class _AllWorkerScreenState extends State<AllWorkerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search For Companies...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white54,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        onPressed: () {
          _clearSearchQuery();
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.deepOrange.shade300,
                Colors.blueAccent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.deepOrange.shade300,
                    Colors.blueAccent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.2, 0.9]),
            ),
          ),
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('name', isGreaterThanOrEqualTo: searchQuery)
              .where('name', isNotEqualTo: name)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return AllWorkersWidget(
                      userId: snapshot.data!.docs[index]['id'],
                      userName: snapshot.data!.docs[index]['name'],
                      userEmail: snapshot.data!.docs[index]['email'],
                      phone: snapshot.data!.docs[index]['phoneNumber'],
                      userImageUrl: snapshot.data!.docs[index]['userImage'],
                    );
                  },
                );
              }else if(searchQuery == ''){
                return const Center(
                  child: Text("Please search by company name"),
                );
              }

              else {
                return const Center(
                  child: Text("Your Search Result will shown here."),
                );
              }
            }return const Center(
              child: Text("Something went wrong."),
            );
          },
        ),
      ),
    );
  }
}
