import 'dart:math';

import 'package:contacts/constants/widgets/custom_inputfield.dart';
import 'package:contacts/modules/add_contact/bloc/add_contact_bloc.dart';
import 'package:contacts/modules/add_contact/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  static Widget create() {
    return BlocProvider(
      create: (BuildContext context) => AddContactBloc()..add(GetContactsEvent()),
      child: const AddContactScreen(),
    );
  }

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  GlobalKey<FormState> formAddKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController dob = TextEditingController();
  int? id;
  bool isUpdate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)?.settings.arguments;

    if(data is Map){
      firstName.text = data['fName'];
      lastName.text = data['lName'];
      phoneNo.text = data['phoneNo'];
      id = data['id'];
      isUpdate = data['isEdit'];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isUpdate ? const Text('Create contact') : const Text('Create contact'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: ElevatedButton(
              onPressed: () {
                if (formAddKey.currentState?.validate() ?? false) {

                  if(isUpdate){
                    context.read<AddContactBloc>().add(
                      EditContactsEvent(
                        contactModel: ContactModel(
                          fName: firstName.text.trim(),
                          lName: lastName.text.trim(),
                          number: phoneNo.text.trim(),
                          isFav: false,
                          id: id ?? 0,
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  }else{
                    context.read<AddContactBloc>().add(
                      CreateContactEvent(
                        contactModel: ContactModel(
                          fName: firstName.text.trim(),
                          lName: lastName.text.trim(),
                          number: phoneNo.text.trim(),
                          isFav: false,
                          id: Random().nextInt(99999999),
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  }

                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: Form(
        key: formAddKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 0, left: 8, right: 8),
                    child: Icon(Icons.person_outline_rounded),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField(
                            controller: firstName,
                            hintText: 'First Name',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField(
                            controller: lastName,
                            hintText: 'Last Name',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 0, left: 8, right: 8),
                    child: Icon(Icons.phone),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextFormField(
                        textInputType: TextInputType.number,
                        controller: phoneNo,
                        maxLength: 10,
                        validType: 'phone',
                        hintText: 'Phone',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 0, left: 8, right: 8),
                    child: Icon(Icons.calendar_month_outlined),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextFormField(
                        controller: dob,
                        hintText: 'Significant date',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
