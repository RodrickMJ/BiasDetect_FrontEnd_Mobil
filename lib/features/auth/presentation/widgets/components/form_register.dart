import 'package:bias_detect/features/auth/presentation/provider/register_provider.dart';
import 'package:bias_detect/features/auth/presentation/widgets/atoms/button_primary.dart';
import 'package:bias_detect/features/auth/presentation/widgets/molecules/label_form.dart';
import 'package:flutter/material.dart';

class FormRegister extends StatelessWidget {
  final RegisterProvider auth;

  const FormRegister({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelForm(
          label: "name",
          value: auth.email,
          errorText: auth.emailError,
          onChanged: auth.setEmail,
        ),

        const SizedBox(height: 16),
        LabelForm(
          label: "Correo Electronico",
          value: auth.email,
          errorText: auth.emailError,
          onChanged: auth.setEmail,
        ),

        const SizedBox(height: 16),

        LabelForm(
          label: "contraseña", 
          value: auth.password,
          errorText: auth.passwordError,
          isPassword: true, 
          onChanged: auth.setPassword,
        ),

        const SizedBox(height: 24,),

        ButtonPrimary(
          text: "Registrarse",
          isLoading: auth.isLoading, 
          onPressed: auth.submit,
          color: Colors.orange,
        )
      ],
    );
  }
}