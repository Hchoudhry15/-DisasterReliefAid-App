import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final Function(String)? onSubmittedSearch;

  SearchBox({super.key, this.onSubmittedSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Enter Email',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              String searchText = searchController.text;
              onSubmittedSearch?.call(searchText);
            },
          ),
        ),
        onSubmitted: onSubmittedSearch,
      ),
    );
  }
}
