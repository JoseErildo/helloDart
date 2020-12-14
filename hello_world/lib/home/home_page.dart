import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Padding(
      padding: const EdgeInsets.only(top: 42, left: 24),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Text("Browse",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Text("Recommended",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400]
                ),
              )
            ],
          ),
          BlocBuilder<HomePageBloc, HomePageState>(
            bloc: BlocProvider.of<HomePageBloc>(context),
            builder: (context, state) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext c, int index) {
                    final category = categories.elementAt(index);
                    final isSelectedCategory = category == state.category;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<HomePageBloc>(context)
                              .dispatch(HomePageSearchEvent(category: category));
                        },
                        child: Chip(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          backgroundColor: isSelectedCategory ? Colors.blue : Colors.grey[200],
                          label: Text(category,
                            style: TextStyle(
                                color: isSelectedCategory ? Colors.white : Colors.grey[500]
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          BlocBuilder<HomePageBloc, HomePageState>(
            bloc: BlocProvider.of<HomePageBloc>(context),
            builder: (context, state) {
              if(state.books.status == ResultStatus.loading)
                return Center(child: CircularProgressIndicator());
              if(state.books.status == ResultStatus.failed)
                return Center(child: Text(state.books.error));
              if(state.books.status == ResultStatus.success) {
                final books = state.books;
                return Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: books.data.length,
                      itemBuilder: (context, index) {
                        final item = books.data.elementAt(index);
                        return BookWidget(book: item);
                      },
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    ),
  );
}




}