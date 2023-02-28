import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:airplaine/delayed_animation.dart';
import 'package:airplaine/main.dart';

import 'liste_aeroport.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
            //  vertical: 60,
              horizontal: 30,
            ),
            child: Column(
              children: [
                DelayedAnimation(
                  delay: 1500,
                  child: SizedBox(
                    height: 100,
                    child: Text('SKYTRACK',
                        style: GoogleFonts.montserrat(fontSize: 25)),
                  ),
                ),
                DelayedAnimation(
                  delay: 2500,
                  child: SizedBox(
                    height: 500,
                    child: Image.asset('images/men.png'),
                  ),
                ),
                DelayedAnimation(
                  delay: 3500,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 20,
                    ),
                    child: Text(
                      "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                DelayedAnimation(
                  delay: 4500,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: d_red,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.all(13)),
                      child: const Text('Commencer'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AirportList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
