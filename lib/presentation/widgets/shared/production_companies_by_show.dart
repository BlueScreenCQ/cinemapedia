import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/snack_bar.dart';
import 'package:flutter/material.dart';

class ProductionCompaniesByShow extends StatelessWidget {
  final List<WatchProvider> companies;
  const ProductionCompaniesByShow({super.key, required this.companies});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 3, bottom: 5),
        child: Text('Producida por', style: textStyle.titleLarge),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            ...companies.map((provider) {
              if (provider.logoPath == 'no-logo') return const SizedBox();

              return Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => showProviderNameToast(context, provider.providerName),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        provider.logoPath,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ));
            })
          ],
        ),
      ),
    ]);
  }
}
