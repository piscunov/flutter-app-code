
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/app/sign_in/validator.dart';
import 'package:flutterapp/custom_widgets/form_submit_button.dart';
import 'package:flutterapp/custom_widgets/platform_exception_alert_dialog.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:provider/provider.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

//getter si setter:

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

@override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();

  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop(); //se intoarce in ruta initiala
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
        
      ).show(context);
    } finally {
      //asigura ca acest cod se intampla si daca are succes si daca nu auth.
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    //nu modifica focusul pana nu e valid form-ul;
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    //seteaza state-ul paiginii in functie de register sau sign in
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    //stergerea input-ului dupa ce da pe register sau log in
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';

    final secundaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnable = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      SizedBox(height: 5.0),
      Image.asset(
        "images/email-sign-in-emoji.png",
        width: 50,
        height: 75,
        color: Colors.amber,
      ),
      SizedBox(
        height: 18.0,
      ),
      Text(
        'Încotro? Spre un TU mai BUN!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22.0, color: Colors.white),
      ),
      SizedBox(height: 20),
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 10.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnable ? _submit : null,
      ),
      SizedBox(
        height: 5.0,
      ),
      FlatButton(
        child: Text(
          secundaryText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: !_isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white, fontSize: 18.0),
        hintStyle: TextStyle(color: Colors.white),
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white, fontSize: 18.0),
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize
              .min, // nu duce pana jos form-ul "how much space is occupaid pe mainaxis" R:as much AS IS NEEDED!
          children: _buildChildren(),
        ),
      ),
    );
  }

  //sa dea reset la pagina daca sunt valid pass si email
  _updateState() {
    setState(() {});
  }
}
