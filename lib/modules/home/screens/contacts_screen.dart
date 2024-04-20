import 'package:contacts/constants/enums/status.dart';
import 'package:contacts/modules/add_contact/bloc/add_contact_bloc.dart';
import 'package:contacts/modules/add_contact/model/contact_model.dart';
import 'package:contacts/modules/add_contact/screens/add_contact.dart';
import 'package:contacts/modules/home/screens/alert_dialogbox.dart';
import 'package:flutter/cupertino.dart';
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
  List<ContactModel> localList = [];
  List<ContactModel> searchList = [];
  TextEditingController controller = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  // bool isGetData = false;
  ValueNotifier<bool> sort = ValueNotifier<bool>(false);
  ValueNotifier<bool> isGetData = ValueNotifier<bool>(false);

  _showDialog(BuildContext context, int id) {
    continueCallBack() {
      context.read<AddContactBloc>().add(DeleteContactsEvent(id: id));
      isGetData.value = false;
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
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 170),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 43.0, left: 15, right: 8, bottom: 0),
              child: Text('Contacts',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 40, color: Colors.deepPurple)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 8, right: 8, bottom: 8),
              child: TextField(
                focusNode: myFocusNode,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.purple.shade50,
                  focusColor: Colors.purple.shade50,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: "Search Contacts",
                  hintStyle: TextStyle(
                      color: myFocusNode.hasFocus ? Colors.deepPurple : Colors.deepPurple),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.deepPurple,
                    ),
                  ),
                  border: InputBorder.none,
                ),
                controller: controller,
                onChanged: (value) {
                  searchList.clear();
                  for (int i = 0; i < localList.length; i++) {
                    if (localList[i].fName.toLowerCase().contains(value) ||
                        localList[i].lName.toLowerCase().contains(value) ||
                        localList[i].number.toLowerCase().contains(value)) {
                      searchList.add(localList[i]);
                    }
                  }
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 5, bottom: 5, right: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    sort.value = !sort.value;
                    localList = localList.reversed.toList();
                    searchList = searchList.reversed.toList();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: const BorderRadius.all(Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Sort  :  ',
                          style: TextStyle(
                            color: Colors.deepPurple,
                          ),
                        ),
                        Icon(
                          sort.value ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
                          color: Colors.deepPurple,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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

            if (!isGetData.value) {
              searchList.clear();
              localList.clear();
              localList.addAll(state.contactModelList ?? []);
              searchList.addAll(localList);
            }
            isGetData.value = true;
            sort.value ? searchList.reversed.toList() : searchList;

            if (searchList.isNotEmpty) {
              return ValueListenableBuilder(
                valueListenable: sort,
                builder: (BuildContext context, bool value, Widget? child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    // reverse: sort.value,
                    itemCount: searchList.length,
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
                                  ).then((value) {
                                    context.read<AddContactBloc>().add(GetContactsEvent());
                                    isGetData.value = false;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8, left: 15, right: 20),
                                  child: CircleAvatar(
                                    radius: 27,
                                    backgroundColor: Colors.purple.shade200,
                                    child: Text(
                                      searchList[index].fName[0],
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
                                        searchList[index].fName,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.deepPurple.shade900),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        searchList[index].lName,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.deepPurple.shade900),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        searchList[index].number,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.deepPurple.shade900),
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
                                _showDialog(context, searchList[index].id);
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
                },
              );
            } else {
              return const Center(
                child: Text(
                  'No Contacts',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.deepPurple),
                ),
              );
            }
          } else if (state is ContactsStates && state.status == Status.isError) {
            return Center(
                child: Text(
              state.errorMessage ?? '',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.deepPurple),
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
          ).then((value) {
            context.read<AddContactBloc>().add(GetContactsEvent());
            isGetData.value = false;
          });
        },
        tooltip: 'Add Contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}
