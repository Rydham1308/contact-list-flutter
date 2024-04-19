import 'dart:async';
import 'dart:convert';
import 'package:contacts/constants/keys/shared_prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contacts/modules/add_contact/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/enums/status.dart';

part 'add_contact_event.dart';

part 'add_contact_state.dart';

class AddContactBloc extends Bloc<AddContactEvent, AddContactState> {
  AddContactBloc() : super(const ContactsStates.isInitial()) {
    on<CreateContactEvent>(createNewContact);
    on<GetContactsEvent>(getContacts);
    on<DeleteContactsEvent>(deleteContact);
    on<EditContactsEvent>(editContact);
  }

  Future<void> createNewContact(CreateContactEvent event, Emitter<AddContactState> emit) async {
    try {
      emit(const ContactsStates.isLoading());
      SharedPreferences sp = await SharedPreferences.getInstance();

      List<String>? contactList = sp.getStringList(AppSpKeys.contactList) ?? [];

      if (contactList.isEmpty) {
        sp.setStringList(AppSpKeys.contactList, [jsonEncode(event.contactModel.toJson())]);
      } else {
        contactList.add(jsonEncode(event.contactModel.toJson()));
        sp.setStringList(AppSpKeys.contactList, contactList);
      }
      emit(const ContactsStates.isSuccess());
    } catch (e) {
      emit(ContactsStates.isError(errorMessage: e.toString()));
    }
  }

  Future<void> getContacts(GetContactsEvent event, Emitter<AddContactState> emit) async {
    try {
      emit(const ContactsStates.isLoading());
      SharedPreferences sp = await SharedPreferences.getInstance();

      List<String>? contactList = sp.getStringList(AppSpKeys.contactList) ?? [];

      if (contactList.isNotEmpty) {
        List<ContactModel> contactModelList =
            contactList.map((e) => ContactModel.fromJson(jsonDecode(e))).toList();
        emit(ContactsStates.isLoaded(contactModelList: contactModelList));
      } else {
        emit(const ContactsStates.isError(errorMessage: 'No Contacts'));
      }
    } catch (e) {
      emit(ContactsStates.isError(errorMessage: e.toString()));
    }
  }

  Future<void> deleteContact(DeleteContactsEvent event, Emitter<AddContactState> emit) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();

      List<String>? contactList = sp.getStringList(AppSpKeys.contactList) ?? [];

      List<ContactModel> contactModelList =
          contactList.map((e) => ContactModel.fromJson(jsonDecode(e))).toList();
      contactModelList.removeWhere((element) => element.id == event.id);
      contactList = contactModelList.map((e) => jsonEncode(e)).toList();
      sp.setStringList(AppSpKeys.contactList, contactList);
      emit(ContactsStates.isLoaded(contactModelList: contactModelList));
    } catch (e) {
      emit(ContactsStates.isError(errorMessage: e.toString()));
    }
  }

  Future<void> editContact(EditContactsEvent event, Emitter<AddContactState> emit) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();

      List<String>? contactList = sp.getStringList(AppSpKeys.contactList) ?? [];

      List<ContactModel> contactModelList =
          contactList.map((e) => ContactModel.fromJson(jsonDecode(e))).toList();
      int selectedIndex = contactModelList.indexWhere(
        (element) => element.id == event.contactModel.id,
      );
      contactModelList[selectedIndex] = event.contactModel;
      contactList = contactModelList.map((e) => jsonEncode(e)).toList();
      sp.setStringList(AppSpKeys.contactList, contactList);
      emit(ContactsStates.isLoaded(contactModelList: contactModelList));
    } catch (e) {
      emit(ContactsStates.isError(errorMessage: e.toString()));
    }
  }
}
