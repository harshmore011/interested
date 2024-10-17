
import 'package:flutter/material.dart';
import 'package:interested/features/onboarding/domain/entities/onboarding_entity.dart';

class BenefitCard extends StatefulWidget {
  final Benefit benefit;

  const BenefitCard({super.key, required this.benefit});

  @override
  State<BenefitCard> createState() => _BenefitCardState();
}

class _BenefitCardState extends State<BenefitCard> {
  @override
  Widget build(BuildContext context) {

    final benefit = widget.benefit;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white,
      elevation: 4,
      child: Container(
        width: 275,
        height: 400,
        // constraints: BoxConstraints(maxHeight: ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(benefit.benefit, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            const SizedBox(height: 12,),
            benefit.supportingImage,
            const SizedBox(height: 12,),
            Text(benefit.description, softWrap: true,textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            const SizedBox(height: 12,),
          ],
        ),
      ),
    );;
  }
}
