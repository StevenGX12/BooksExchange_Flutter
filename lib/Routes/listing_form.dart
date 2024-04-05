import 'package:books_exchange/Helpers/Firebase_Services/listing_page.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class ListingForm extends StatefulWidget {
  final String userID;
  const ListingForm({Key? key, required this.userID}) : super(key: key);

  @override
  _ListingFormState createState() => _ListingFormState();
}

class _ListingFormState extends State<ListingForm> {
  final _formKey = GlobalKey<FormState>();
  final MultiSelectController _genreController = MultiSelectController();
  String? _bookTitle;
  String? _author;
  String? _synopsis;
  String? _exchangeDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Book Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Book Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _bookTitle = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter author';
                  }
                  return null;
                },
                onSaved: (value) {
                  _author = value;
                },
              ),
              const SizedBox(height: 10),
              genreField(),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Book Synopsis'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book synopsis';
                  }
                  return null;
                },
                onSaved: (value) {
                  _synopsis = value;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Exchange Details'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time and location for exchange';
                  }
                  return null;
                },
                onSaved: (value) {
                  _exchangeDetails = value;
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget genreField() {
    return MultiSelectDropDown(
      controller: _genreController,
      hint: 'Select Genres',
      onOptionSelected: (List<ValueItem> selectedOptions) {},
      options: const <ValueItem>[
        ValueItem(label: 'Adventure', value: 'Adventure'),
        ValueItem(label: 'Anthologies', value: 'Anthologies'),
        ValueItem(label: 'Art & Photography', value: 'Art & Photography'),
        ValueItem(
            label: 'Biography/Autobiography', value: 'Biography/Autobiography'),
        ValueItem(label: 'Business & Economics', value: 'Business & Economics'),
        ValueItem(label: 'Children\'s Fiction', value: 'Children\'s Fiction'),
        ValueItem(label: 'Classics', value: 'Classics'),
        ValueItem(
            label: 'Cooking, Food, & Wine', value: 'Cooking, Food, & Wine'),
        ValueItem(label: 'Drama/Play', value: 'Drama/Play'),
        ValueItem(label: 'Erotica', value: 'Erotica'),
        ValueItem(label: 'Essays', value: 'Essays'),
        ValueItem(
            label: 'Fairy Tales & Folklore', value: 'Fairy Tales & Folklore'),
        ValueItem(label: 'Fantasy', value: 'Fantasy'),
        ValueItem(
            label: 'Graphic Novels/Comics', value: 'Graphic Novels/Comics'),
        ValueItem(label: 'Health & Wellness', value: 'Health & Wellness'),
        ValueItem(label: 'Historical Fiction', value: 'Historical Fiction'),
        ValueItem(label: 'History', value: 'History'),
        ValueItem(label: 'Horror', value: 'Horror'),
        ValueItem(label: 'Humor', value: 'Humor'),
        ValueItem(label: 'Literary Fiction', value: 'Literary Fiction'),
        ValueItem(label: 'Memoir', value: 'Memoir'),
        ValueItem(label: 'Mystery', value: 'Mystery'),
        ValueItem(label: 'Philosophy', value: 'Philosophy'),
        ValueItem(label: 'Poetry', value: 'Poetry'),
        ValueItem(
            label: 'Politics & Current Affairs',
            value: 'Politics & Current Affairs'),
        ValueItem(label: 'Psychology', value: 'Psychology'),
        ValueItem(
            label: 'Religion & Spirituality', value: 'Religion & Spirituality'),
        ValueItem(label: 'Romance', value: 'Romance'),
        ValueItem(label: 'Satire', value: 'Satire'),
        ValueItem(label: 'Science', value: 'Science'),
        ValueItem(label: 'Science Fiction', value: 'Science Fiction'),
        ValueItem(label: 'Self-help', value: 'Self-help'),
        ValueItem(label: 'Short Stories', value: 'Short Stories'),
        ValueItem(label: 'Technology', value: 'Technology'),
        ValueItem(label: 'Thriller', value: 'Thriller'),
        ValueItem(label: 'Travel', value: 'Travel'),
        ValueItem(label: 'True Crime', value: 'True Crime'),
        ValueItem(label: 'Western', value: 'Western'),
        ValueItem(
            label: 'Young Adult (YA) Fiction',
            value: 'Young Adult (YA) Fiction'),
      ],
      selectionType: SelectionType.multi,
      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
      dropdownHeight: 300,
      optionTextStyle: const TextStyle(fontSize: 16),
      selectedOptionIcon: const Icon(Icons.check_circle),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formKey.currentState!.reset();
      FirebaseServiceListing().createListing(
          widget.userID,
          _bookTitle!,
          _author!,
          _genreController.selectedOptions.map((e) => e.value).toList(),
          _exchangeDetails!,
          _synopsis!);
      Navigator.pop(context);
    }
  }
}
