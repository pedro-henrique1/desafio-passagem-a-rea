import 'package:flutter/material.dart';

class RadioTypeTicket extends StatefulWidget {
  const RadioTypeTicket({super.key});

  @override
  State<RadioTypeTicket> createState() => _RadioTypeTicketState();
}

enum SingingCharacter { Ida, IdaEVolta }

class _RadioTypeTicketState extends State<RadioTypeTicket> {
  SingingCharacter? _character = SingingCharacter.Ida;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 15,
        children: <Widget>[
          _buildRadioOption('Ida', SingingCharacter.Ida),
          _buildRadioOption('Ida e Volta', SingingCharacter.IdaEVolta),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String text, SingingCharacter value) {
    return InkWell(
      onTap: () {
        setState(() {
          _character = value;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<SingingCharacter>(
              value: value,
              groupValue: _character,
              activeColor: Colors.black,
              onChanged: (SingingCharacter? newValue) {
                setState(() {
                  _character = newValue;
                });
              },
            ),
            SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
