
//  For Future Purpose V_02

// import 'package:edmyn/authentication/widgets/custom_text_filed.dart';
// import 'package:flutter/material.dart';
// import 'package:edmyn/shared/widgets/custom_text_form_field.dart';
// import 'package:edmyn/shared/utils.dart' as utils;
//
// class UserRoleSelectionScreen extends StatefulWidget {
//   @override
//   _UserRoleSelectionScreenState createState() =>
//       _UserRoleSelectionScreenState();
// }
//
// class _UserRoleSelectionScreenState extends State<UserRoleSelectionScreen> {
//   int? selectedRole;
//   final _formKey = GlobalKey<FormState>();
//
//   Map<int, Map<String, String>> userDetails = {
//     1: {
//       'id': '1',
//       'name': 'User One',
//       'email': 'userone@example.com',
//     },
//     2: {
//       'id': '2',
//       'name': 'User Two',
//       'email': 'usertwo@example.com',
//     },
//     3: {
//       'id': '3',
//       'name': 'User Three',
//       'email': 'userthree@example.com',
//     },
//     4: {
//       'id': '3',
//       'name': 'User four',
//       'email': 'userthree@example.com',
//     },
//   };
//
//   Map<String, String>? selectedUserDetails;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Role Selection'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(42.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               DropdownButtonFormField<int>(
//                 decoration: InputDecoration(
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   labelText: 'Select User Role',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 value: selectedRole,
//                 isExpanded: true, // Ensures dropdown fills the available space
//                 items: [
//                   DropdownMenuItem(
//                     value: 1,
//                     child: Text(
//                       'Publisher/Academic Publisher',
//                       style: TextStyle(fontSize: 16),
//                       maxLines: 1, // Ensures text doesn't overflow the widget
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   DropdownMenuItem(
//                     value: 2,
//                     child: Text(
//                       'Educator: Professor, Lecturer, Teacher, Coach',
//                       style: TextStyle(fontSize: 16),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   DropdownMenuItem(
//                     value: 3,
//                     child: Text(
//                       'Academic/Educational Author/Educational content creator',
//                       style: TextStyle(fontSize: 16),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   DropdownMenuItem(
//                     value: 4,
//                     child: Text(
//                       'Private Coaching Institute',
//                       style: TextStyle(fontSize: 16),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//                 onChanged: (int? value) {
//                   setState(() {
//                     selectedRole = value;
//                     selectedUserDetails = userDetails[selectedRole];
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Please select a user role';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               if (selectedRole == 1) FirstRoleUserForm(),
//               if (selectedRole == 2) SecoundRoleUserForm(),
//               if (selectedRole == 3) ThirdRoleUserForm(),
//               if (selectedRole == 4) FourRoleUserForm(),
//               if (selectedRole == null) Text('Select a role to view details'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   //  User Form (for Role 1)
//   Widget FirstRoleUserForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomTextFormField(
//             label: 'First Name',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'First Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextFormField(
//             label: 'Last Name',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Publication House',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Publishing For',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'GST No',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Address',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Address is required';
//               }
//               return null;
//             },
//             maxLines: 3,
//           ),
//           _buildLocationFields(),
//           _buildSubmitButton(),
//         ],
//       ),
//     );
//   }
//
//   //  User Form (for Role 2)
//   Widget SecoundRoleUserForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomTextFormField(
//             label: 'First Name',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'First Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextFormField(
//             label: 'Last Name',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Subject',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Institution',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'ID No',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Address',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Address is required';
//               }
//               return null;
//             },
//             maxLines: 3,
//           ),
//           _buildLocationFields(),
//           _buildSubmitButton(),
//         ],
//       ),
//     );
//   }
//
//   //  Form (for Role 3)
//   Widget ThirdRoleUserForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomTextFormField(
//             label: 'First Name',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'First Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextFormField(
//             label: 'Last Name',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Subject',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Institution Associated With',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Which Class',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'ID No',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Address',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Address is required';
//               }
//               return null;
//             },
//             maxLines: 3,
//           ),
//           _buildLocationFields(),
//           _buildSubmitButton(),
//         ],
//       ),
//     );
//   }
//
//   // Form (for Role 4)
//   Widget FourRoleUserForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomTextFormField(
//             label: 'First Name',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'First Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextFormField(
//             label: 'Last Name',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Catering to',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Coaching Institute Name',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'GST No',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Last Name is required';
//               }
//               return null;
//             },
//           ),
//           CustomTextField(
//             label: 'Address',
//             onValidate: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Address is required';
//               }
//               return null;
//             },
//             maxLines: 3,
//           ),
//           _buildLocationFields(),
//           _buildSubmitButton(),
//         ],
//       ),
//     );
//   }
//
//   // Shared location fields
//   Widget _buildLocationFields() {
//     return Column(
//       children: [
//         // First row with Country and State
//         Row(
//           children: [
//             Expanded(
//               child: CustomTextField(
//                 label: 'Country',
//                 onValidate: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Country is required';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             utils.kHTinyGap(),
//             Expanded(
//               child: CustomTextField(
//                 label: 'State',
//                 onValidate: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'State is required';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//           ],
//         ),
//         utils.kVTinyGap(), // Add spacing between rows
//
//         // Second row with City and Pincode
//         Row(
//           children: [
//             Expanded(
//               child: CustomTextField(
//                 label: 'City',
//                 onValidate: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'City is required';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             utils.kHTinyGap(),
//             Expanded(
//               child: CustomTextField(
//                 label: 'Pincode',
//                 onValidate: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Pincode is required';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // Submit Button
//   Widget _buildSubmitButton() {
//     return Align(
//       alignment: Alignment.center,
//       child: Padding(
//         padding: const EdgeInsets.only(top: 20.0),
//         child: ElevatedButton(
//           onPressed: () {
//             if (_formKey.currentState!.validate()) {
//               // Handle form submission
//             }
//           },
//           child: Text(
//             'Submit',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
