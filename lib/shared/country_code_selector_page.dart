import 'package:flutter/material.dart';
import 'package:partner/shared/country_codes.dart';

class CountryCodeSelectorPage extends StatefulWidget {
  const CountryCodeSelectorPage({Key? key}) : super(key: key);

  @override
  State<CountryCodeSelectorPage> createState() =>
      _CountryCodeSelectorPageState();
}

class _CountryCodeSelectorPageState extends State<CountryCodeSelectorPage> {
  List<Map<String, String>> displayedCodes = AppCountryCodes.countryDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your country'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                value = value.toLowerCase();
                setState(() {
                  displayedCodes =
                      AppCountryCodes.countryDetails.where((element) {
                    if (element['name']!.toLowerCase().contains(value) ||
                        element['code']!.toLowerCase().contains(value) ||
                        element['dial_code']!.toLowerCase().contains(value)) {
                      return true;
                    }
                    return false;
                  }).toList();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              if (displayedCodes.isEmpty) {
                return const Center(
                  child: Text('Country not found'),
                );
              }
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pop(displayedCodes[index]);
                      },
                      leading: Text(displayedCodes[index]['flag']!),
                      title: Text(displayedCodes[index]['name']!),
                      trailing: Text(displayedCodes[index]['dial_code']!),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: displayedCodes.length);
            }),
          )
        ],
      ),
    );
  }
}
