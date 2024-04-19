import 'package:contacts/constants/enums/status.dart';
import 'package:contacts/constants/widgets/custom_inputfield.dart';
import 'package:contacts/modules/add_contact/bloc/add_contact_bloc.dart';
import 'package:contacts/modules/add_contact/model/contact_model.dart';
import 'package:contacts/modules/add_contact/screens/add_contact.dart';
import 'package:contacts/modules/home/screens/alert_dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllContactsScreen extends StatefulWidget {
  const AllContactsScreen({super.key});

  static Widget create() {
    return BlocProvider(
      create: (BuildContext context) => AddContactBloc()..add(GetContactsEvent()),
      child: const AllContactsScreen(),
    );
  }

  @override
  State<AllContactsScreen> createState() => _AllContactsScreenState();
}

class _AllContactsScreenState extends State<AllContactsScreen> {
  _showDialog(BuildContext context, int id) {
    continueCallBack() {
      context.read<AddContactBloc>().add(DeleteContactsEvent(id: id));
      Navigator.pop(context);
    }

    BlurryDialog alert =
        BlurryDialog("Delete", "Are you sure you want to delete this contact?", continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.maxFinite, 60),
        child: Padding(
          padding: EdgeInsets.only(top: 35.0),
          child: CustomTextFormField(
            hintText: 'Search',
          ),
        ),
      ),
      body: BlocConsumer<AddContactBloc, AddContactState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is ContactsStates && state.status == Status.isLoaded) {
            state.contactModelList?.sort(
              (a, b) => a.fName.toLowerCase().compareTo(b.fName.toLowerCase()),
            );

            // final Map<String, List<ContactModel>> groupedLists = {};
            //
            // void groupMyList() {
            //   state.contactModelList?.forEach((person) {
            //     if (groupedLists[person.fName[0]] == null) {
            //       groupedLists[person.fName[0]] = <ContactModel>[];
            //     }
            //
            //     groupedLists[person.fName[0]]?.add(person);
            //   });
            // }

            return ListView.builder(
              itemCount: state.contactModelList?.length ?? 0,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddContactScreen.create(),
                                settings: RouteSettings(arguments: {
                                  'fName': state.contactModelList?[index].fName,
                                  'lName': state.contactModelList?[index].lName,
                                  'phoneNo': state.contactModelList?[index].number,
                                  'id': state.contactModelList?[index].id,
                                  'isEdit': true,
                                }),
                              ),
                            ).then(
                                (value) => context.read<AddContactBloc>().add(GetContactsEvent()));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 20),
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor: Colors.purple.shade200,
                              child: Text(
                                state.contactModelList?[index].fName[0] ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  state.contactModelList?[index].fName ?? '',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  state.contactModelList?[index].lName ?? '',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  state.contactModelList?[index].number ?? '',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: () {
                          _showDialog(context, state.contactModelList?[index].id ?? 0);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (state is ContactsStates && state.status == Status.isError) {
            return Center(
                child: Text(
              state.errorMessage ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddContactScreen.create(),
            ),
          ).then((value) => context.read<AddContactBloc>().add(GetContactsEvent()));
        },
        tooltip: 'Add Contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}
