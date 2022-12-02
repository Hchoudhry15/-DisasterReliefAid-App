import 'package:disaster_relief_aid_flutter/component/MultiSelectDropDown.component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import "package:intl/intl.dart";

import '../DRA.config.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: const RegistrationForm());
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Row(
                      children: const [Expanded(child: LanguageDropDown())]),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Row(children: [
                    Expanded(
                        child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "First Name",
                        hintText: "Enter your first name",
                      ),
                      autofillHints: const [AutofillHints.givenName],
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ))
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child:
                      Row(children: const [Expanded(child: BirthdayPicker())]),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Row(children: [
                    Expanded(
                        child: CustomMultiselectDropDown(
                      listOFStrings: Config.vulnerabilities.toList(),
                      selectedList: vulnerabilitySelected,
                      labelText: "Vulnerabilities",
                      hintText: "Select your vulnerabilities",
                    ))
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // process data woo!
                          }
                        },
                        child: const Text("Submit"))
                  ],
                )
              ],
            ))));
  }
}

dynamic vulnerabilitySelected(List<String> selected) {
  print(selected);
}

class LanguageDropDown extends StatefulWidget {
  const LanguageDropDown({super.key});

  @override
  State<LanguageDropDown> createState() => _LanguageDropDownState();
}

class _LanguageDropDownState extends State<LanguageDropDown> {
  String dropdownValue = Config.languages[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: dropdownValue,
      items: Config.languages.map<DropdownMenuItem<String>>((String e) {
        return DropdownMenuItem<String>(value: e, child: Text(e));
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      isExpanded: true,
      decoration: const InputDecoration(
          labelText: "Language", hintText: "Select your language"),
    );
  }
}

class BirthdayPicker extends StatefulWidget {
  const BirthdayPicker({super.key});

  @override
  State<BirthdayPicker> createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        labelText: "Birthdate",
      ),
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a birthdate";
        }
      },
      autofillHints: const [AutofillHints.birthday],
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          String formatted = DateFormat("MM/dd/yyyy").format(pickedDate);
          setState(() {
            dateController.text = formatted;
          });
        } else {
          print("Date is not selected");
        }
      },
    );
  }
}

class VulnerabilitiesDropdown extends StatefulWidget {
  const VulnerabilitiesDropdown({super.key});

  @override
  State<VulnerabilitiesDropdown> createState() =>
      _VulnerabilitiesDropdownState();
}

class _VulnerabilitiesDropdownState extends State<VulnerabilitiesDropdown> {
  String dropdownValue = Config.vulnerabilities[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      // value: dropdownValue,
      items: Config.vulnerabilities.map<DropdownMenuItem<String>>((String e) {
        return DropdownMenuItem<String>(value: e, child: Text(e));
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: "Vulnerabilities",
        // hintText: "Select your vulnerabilities"
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a vulnerability or select 'None'";
        }
      },
      hint: const Text("Select your vulnerabilities"),
    );
  }
}

// -------- DropDown (can only select one) --------

// class _VulnerabilitiesDropdownState extends State<VulnerabilitiesDropdown> {
//   String dropdownValue = Config.vulnerabilities[0];

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       // value: dropdownValue,
//       items: Config.vulnerabilities.map<DropdownMenuItem<String>>((String e) {
//         return DropdownMenuItem<String>(value: e, child: Text(e));
//       }).toList(),
//       onChanged: (String? value) {
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       isExpanded: true,
//       decoration: const InputDecoration(
//         labelText: "Vulnerabilities",
//         // hintText: "Select your vulnerabilities"
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "Please enter a vulnerability or select 'None'";
//         }
//       },
//       hint: const Text("Select your vulnerabilities"),
//     );
//   }
// }