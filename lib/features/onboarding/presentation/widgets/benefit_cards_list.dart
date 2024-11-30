import 'package:flutter/material.dart';

import '../../domain/entities/onboarding_entity.dart';
import 'benefit_card.dart';

class BenefitCardsList extends StatefulWidget {
  final List<Benefit> benefits;

  const BenefitCardsList({super.key, required this.benefits});

  @override
  State<BenefitCardsList> createState() => _BenefitCardsListState();
}

class _BenefitCardsListState extends State<BenefitCardsList> {
  @override
  Widget build(BuildContext context) {
    final benefits = widget.benefits;

    debugPrint("benefitsLength: ${benefits.length}");
    // <orderEntry type="jdk" jdkName="Android API 34, extension level 7 Platform" jdkType="Android SDK" />

    return ListView.builder(
      // controller: ScrollController().,
      // shrinkWrap: true,
      itemBuilder: (context, index) {
       return BenefitCard(benefit: benefits[index]);

        // return _getBenefitCards(benefits)[index];
      },
      itemCount: benefits.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

}
