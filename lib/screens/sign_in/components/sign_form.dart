// import 'package:flutter/material.dart';
// import 'package:shop_app/screens/init_screen.dart';
// import '../../../components/custom_surfix_icon.dart';
// import '../../../components/form_error.dart';
// import '../../../constants.dart';
// import '../../../helper/keyboard.dart';
// import '../../forgot_password/forgot_password_screen.dart';
// import '../../login_success/login_success_screen.dart';

// class SignForm extends StatefulWidget {
//   const SignForm({super.key});

//   @override
//   _SignFormState createState() => _SignFormState();
// }

// class _SignFormState extends State<SignForm> {
//   final _formKey = GlobalKey<FormState>();
//   String? email;
//   String? password;
//   bool? remember = false;
//   final List<String?> errors = [];

//   void addError({String? error}) {
//     if (!errors.contains(error)) {
//       setState(() {
//         errors.add(error);
//       });
//     }
//   }

//   void removeError({String? error}) {
//     if (errors.contains(error)) {
//       setState(() {
//         errors.remove(error);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             keyboardType: TextInputType.emailAddress,
//             onSaved: (newValue) => email = newValue,
//             onChanged: (value) {
//               if (value.isNotEmpty) {
//                 removeError(error: kEmailNullError);
//               } else if (emailValidatorRegExp.hasMatch(value)) {
//                 removeError(error: kInvalidEmailError);
//               }
//               return;
//             },
//             validator: (value) {
//               return null;

//               // if (value!.isEmpty) {
//               //   addError(error: kEmailNullError);
//               //   return "";
//               // } else if (!emailValidatorRegExp.hasMatch(value)) {
//               //   addError(error: kInvalidEmailError);
//               //   return "";
//               // }
//               // return null;
//             },
//             // decoration: const InputDecoration(
//             //   labelText: "Email",
//             //   hintText: "Enter your email",
//             //   // If  you are using latest version of flutter then lable text and hint text shown like this
//             //   // if you r using flutter less then 1.20.* then maybe this is not working properly
//             //   floatingLabelBehavior: FloatingLabelBehavior.always,
//             //   suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
//             // ),
//             decoration: const InputDecoration(
//               prefixIcon: Icon(Icons.mail), // Icon bên trong ô nhập
//               border: OutlineInputBorder(), // Thêm viền cho đẹp hơn
//               labelText: "Email",
//               hintText: "Enter your email",
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextFormField(
//             obscureText: true,
//             onSaved: (newValue) => password = newValue,
//             onChanged: (value) {
//               if (value.isNotEmpty) {
//                 removeError(error: kPassNullError);
//               } else if (value.length >= 8) {
//                 removeError(error: kShortPassError);
//               }
//               return;
//             },
//             validator: (value) {
//               return null;

//               // if (value!.isEmpty) {
//               //   addError(error: kPassNullError);
//               //   return "";
//               // } else if (value.length < 8) {
//               //   addError(error: kShortPassError);
//               //   return "";
//               // }
//               // return null;
//             },
//             // decoration: const InputDecoration(
//             //   labelText: "Password",
//             //   hintText: "Enter your password",
//             //   // If  you are using latest version of flutter then lable text and hint text shown like this
//             //   // if you r using flutter less then 1.20.* then maybe this is not working properly
//             //   floatingLabelBehavior: FloatingLabelBehavior.always,
//             //   suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
//             // ),
//             decoration: const InputDecoration(
//               prefixIcon: Icon(Icons.lock), // Icon bên trong ô nhập
//               border: OutlineInputBorder(), // Thêm viền cho đẹp hơn
//               labelText: "Password",
//               hintText: "Enter your password",
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Checkbox(
//                 value: remember,
//                 activeColor: kPrimaryColor,
//                 onChanged: (value) {
//                   setState(() {
//                     remember = value;
//                   });
//                 },
//               ),
//               const Text("Remember me"),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () => Navigator.pushNamed(
//                     context, ForgotPasswordScreen.routeName),
//                 child: const Text(
//                   "Forgot Password",
//                   style: TextStyle(decoration: TextDecoration.underline),
//                 ),
//               )
//             ],
//           ),
//           FormError(errors: errors),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 _formKey.currentState!.save();
//                 // if all are valid then go to success screen
//                 KeyboardUtil.hideKeyboard(context);
//                 Navigator.pushNamed(context, InitScreen.routeName);
//               }
//             },
//             child: const Text("Sign In"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../forgot_password/forgot_password_screen.dart';
import '../../login_success/login_success_screen.dart';
import '../../../services/login_service.dart'; // Import API Login Service

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];
  bool isLoading = false;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });

    String? token = await ApiLoginService.login(email!, password!);

    setState(() {
      isLoading = false;
    });

    if (token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng nhập thành công")),
      );
      Navigator.pushNamed(context, InitScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Đăng nhập thất bại. Kiểm tra lại tài khoản/mật khẩu")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "Vui lòng nhập email";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "Email không hợp lệ";
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.mail),
              border: OutlineInputBorder(),
              labelText: "Email",
              hintText: "Enter your email",
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "Vui lòng nhập mật khẩu";
              } else if (value.length < 5) {
                addError(error: kShortPassError);
                return "Mật khẩu quá ngắn";
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              labelText: "Password",
              hintText: "Enter your password",
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: handleLogin,
                  child: const Text("Sign In"),
                ),
        ],
      ),
    );
  }
}
