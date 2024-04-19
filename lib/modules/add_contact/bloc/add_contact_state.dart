part of 'add_contact_bloc.dart';

@immutable
abstract class AddContactState {
  const AddContactState();
}

class ContactsStates extends AddContactState {
  final Status status;
  final String? errorMessage;
  final bool? isReg;
  final List<ContactModel>? contactModelList;

  const ContactsStates._({
    required this.status,
    this.errorMessage,
    this.isReg,
    this.contactModelList,
  });

  const ContactsStates.isInitial() : this._(status: Status.isInitial);

  const ContactsStates.isSuccess() : this._(status: Status.isSuccess);

  const ContactsStates.isLoaded({required List<ContactModel>? contactModelList})
      : this._(status: Status.isLoaded, contactModelList: contactModelList);

  const ContactsStates.isLoading() : this._(status: Status.isLoading);

  const ContactsStates.isError({required String? errorMessage})
      : this._(status: Status.isError, errorMessage: errorMessage);
}
