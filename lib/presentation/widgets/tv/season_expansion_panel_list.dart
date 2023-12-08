import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/episode.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/domain/entities/season.dart';

// stores ExpansionPanel state information
class Item {
  Season itemData;
  bool isExpanded;

  Item({
    required this.itemData,
    this.isExpanded = false,
  });
}

List<Item> generateItems(List<Season> items) {
  return List<Item>.generate(items.length, (int index) {
    return Item(
      itemData: items[index],
    );
  });
}

class SeasonExpansionPanelList extends StatefulWidget {
  final List<Season> seasons;

  const SeasonExpansionPanelList({super.key, required this.seasons});

  @override
  State<SeasonExpansionPanelList> createState() => _SeasonExpansionPanelListState();
}

class _SeasonExpansionPanelListState extends State<SeasonExpansionPanelList> {
  List<Item> data = [];

  @override
  void initState() {
    super.initState();
    data = generateItems(widget.seasons);

    if (data[0].itemData.seasonNumber == 0) {
      data.add(data[0]);
      data.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          data[index].isExpanded = isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((Item item) {
        Season season = item.itemData;

        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text((season.episodeCount != 0) ? '${season.name} (${season.episodeCount} episodios)' : season.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: (season.seasonNumber != 0 && season.airDate != null)
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text('${season.airDate!.day.toString().padLeft(2, '0')}/${season.airDate!.month.toString().padLeft(2, '0')}/${season.airDate!.year.toString().padLeft(4, '0')}'),
                      ],
                    )
                  : const Text(
                      'Fecha de estreno por confirmar',
                      style: TextStyle(color: Colors.red),
                    ),
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    item.itemData.posterPath,
                    height: double.infinity,
                  )),
            );
          },
          body: (season.episodes.isNotEmpty)
              ? SizedBox(
                  height: 220,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: season.episodes.length,
                      itemBuilder: (context, index) {
                        final Episode item = season.episodes[index];

                        return Container(
                            padding: const EdgeInsets.all(8.0),
                            width: 220,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              //Caputra del capítulo
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.stillPath,
                                  width: 220,
                                  height: 124,
                                  // width: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(height: 5),

                              //Name
                              Text(
                                '${item.episodeNumber}-${item.name}',
                                maxLines: 2,
                                style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                              ),

                              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                if (item.airDate != null) ...[
                                  const Icon(Icons.calendar_month_outlined, size: 20),
                                  const SizedBox(width: 2),
                                  Text('${item.airDate!.day.toString().padLeft(2, '0')}/${season.airDate!.month.toString().padLeft(2, '0')}/${season.airDate!.year.toString().padLeft(4, '0')}',
                                      style: textStyle.bodySmall),
                                  const SizedBox(width: 15.0),
                                ],

                                //* Rating
                                if (item.voteCount > 0) ...[
                                  Icon(Icons.star_half_rounded, color: Colors.yellow.shade800, size: 20),
                                  const SizedBox(width: 2),
                                  Text(
                                    HumanFormats.number(item.voteAverage, 2),
                                    style: textStyle.bodySmall!.copyWith(color: Colors.yellow.shade800),
                                  )
                                ],
                              ]),
                            ]));
                      }),
                )
              : Container(),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
