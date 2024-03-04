// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felix/models/recommendation.dart';
import 'package:felix/models/search.dart';
import 'package:felix/models/topsearches.dart';
import 'package:felix/pages/descriptionPage.dart';
import 'package:felix/services/api_services.dart';
import 'package:felix/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchcontroller = TextEditingController();
  ApiServices apiServices = ApiServices();
  SearchModel? searchModel;
  late Future<TopSearchesModel> popularmovies;

  void search(String query) {
    apiServices.getSearchedMovies(query).then((results) {
      setState(() {
        searchModel = results;
      });
    });
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    popularmovies = apiServices.getTopSearchedMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CupertinoSearchTextField(
                controller: searchcontroller,
                style: TextStyle(color: Colors.white),
                backgroundColor: Colors.grey.withOpacity(0.2),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                suffixIcon: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      searchModel = null;
                    });
                  } else {
                    search(searchcontroller.text);
                  }
                },
              ),
              searchcontroller.text.isEmpty
                  ? FutureBuilder(
                      future: popularmovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data?.results;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Top Searches",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DescriptionPage(
                                              movieId: data[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 150.0,
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Image.network(
                                              "$imageUrl${data[index].posterPath}",
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            SizedBox(
                                              width: 260.0,
                                              child: Text(
                                                data[index].title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('{$snapshot.error}');
                        } else {
                          return const SizedBox.shrink();
                        }
                      })
                  : searchModel == null
                      ? SizedBox.shrink()
                      : GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchModel?.results.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            //mainAxisSpacing: 10,
                            crossAxisSpacing: 5,
                            childAspectRatio: 1.2 / 2,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DescriptionPage(
                                            movieId:
                                                searchModel!.results[index].id,
                                          )),
                                );
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "$imageUrl${searchModel!.results[index].backdropPath}",
                                    height: 170.0,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      searchModel!.results[index].title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
            ],
          ),
        ),
      ),
    );
  }
}
