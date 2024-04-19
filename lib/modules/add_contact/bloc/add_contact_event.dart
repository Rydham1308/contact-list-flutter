part of 'add_contact_bloc.dart';

@immutable
abstract class AddContactEvent {}

class CreateContactEvent extends AddContactEvent {
  final ContactModel contactModel;

  CreateContactEvent({required this.contactModel});
}

class GetContactsEvent extends AddContactEvent {}

class DeleteContactsEvent extends AddContactEvent {
  final int id;

  DeleteContactsEvent({required this.id});
}

class EditContactsEvent extends AddContactEvent {
  final ContactModel contactModel;

  EditContactsEvent({required this.contactModel});
}