import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 120,
    height: 120,
  );
}

Image iconWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.contain,
    color: Colors.white,
  );
}

TextFormField reusableTextField(String text, IconData icon, String type,
    bool isOptional, TextEditingController controller) {
  bool isPasswordType = false;
  bool isEmail = false;
  bool isUsername = false;
  bool isPhone = false;
  if (type == 'password') {
    isPasswordType = true;
  } else if (type == 'email') {
    isEmail = true;
  } else if (type == 'username') {
    isUsername = true;
  } else if (type == 'phone') {
    isPhone = true;
  }
  return TextFormField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.deepOrange,
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: isEmail
          ? ((value) =>
              value != null && value.isEmpty ? 'Enter a valid Email' : null)
          : isPasswordType
              ? ((value) => value != null && value.length < 6
                  ? 'needs to be atleast 6 characters'
                  : null)
              : isUsername
                  ? ((value) => value != null && value.length < 4
                      ? 'needs to be atleast 4 characters'
                      : null)
                  : isPhone
                      ? ((value) => value != null && value.length < 10
                          ? 'Enter a valid Phone Number'
                          : null)
                      : isOptional
                          ? ((value) => null)
                          : (value) => value != null && value.isEmpty
                              ? 'Field can\'t be empty'
                              : null,
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : isEmail
              ? TextInputType.emailAddress
              : isPhone
                  ? TextInputType.number
                  : null);
}

TextFormField reusableTextArea(
    String text, IconData icon, TextEditingController controller) {
  return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      maxLines: null,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.deepOrange,
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) =>
          value != null && value.isEmpty ? 'Field can\'t be empty' : null,
      keyboardType: TextInputType.multiline);
}

Container reusableUIButton(
    BuildContext context, String title, double width, Function onTap) {
  return Container(
    width: width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.deepOrange[300];
            }
            return Colors.deepOrange;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)))),
    ),
  );
}

Container reusableIconButton(BuildContext context, String title, IconData icon,
    double width, Function onTap) {
  return Container(
    width: width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton.icon(
      onPressed: () {
        onTap();
      },
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.deepOrange[300];
            }
            return Colors.deepOrange;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)))),
    ),
  );
}

void loading(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
          ));
}
