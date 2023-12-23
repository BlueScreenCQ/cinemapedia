import 'package:cinemapedia/presentation/delegates/search_delegate.dart';
import 'package:cinemapedia/presentation/providers/search/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomChoiceChip extends ConsumerStatefulWidget {
  final List<String> items;

  const CustomChoiceChip({super.key, required this.items});

  @override
  ConsumerState<CustomChoiceChip> createState() => _CustomChoiceChipState();
}

class _CustomChoiceChipState extends ConsumerState<CustomChoiceChip> {
  @override
  Widget build(BuildContext context) {
    int? value = ref.watch(searchProvider.notifier).state;

    return Wrap(
      spacing: 5.0,
      children: List<Widget>.generate(
        widget.items.length,
        (int i) {
          return ChoiceChip(
            label: Text(widget.items[i]),
            selected: value == i,
            onSelected: (bool isSelected) {
              ref.watch(searchProvider.notifier).state = i;
              setState(() {
                if (isSelected && i != value) {
                  value = i;

                  context.pop();

                  final searchQuery = ref.read(searchQueryProvider.notifier).state;

                  showSearch(context: context, query: searchQuery, delegate: CustomSearchDelegate(ref: ref)).then((item) {
                    if (item != null) {
                      if (item.isPeli) context.push('/home/0/movie/${item.sId}');
                      if (item.isTV) context.push('/home/0/tv/${item.sId}');
                      if (item.isActor) context.push('/home/0/actor/${item.sId}');
                    }
                  });
                }
              });
            },
          );
        },
      ).toList(),
    );
  }
}
