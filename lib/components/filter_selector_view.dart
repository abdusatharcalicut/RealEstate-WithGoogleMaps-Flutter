import 'package:flutter/material.dart';

class FilterSelectorView<T> extends StatefulWidget {
  FilterSelectorView({Key? key, required this.items, required this.getTitle, required this.selectedItems})
      : super(key: key);

  final List<T> items;
  final String Function(dynamic item) getTitle;
  List<T> selectedItems;

  @override
  State<FilterSelectorView> createState() => _FilterSelectorViewState();
}

class _FilterSelectorViewState extends State<FilterSelectorView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        final item = widget.items[index];

        final isSelected = widget.selectedItems.contains(item);

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              if (widget.selectedItems.contains(item)) {
                widget.selectedItems.remove(item);
              } else {
                widget.selectedItems.add(item);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                constraints: const BoxConstraints(minWidth: 60),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                  color: isSelected ? Colors.green : Colors.transparent,
                ),
                child: Text(
                  widget.getTitle(item),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.green,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: widget.items.length,
    );
  }
}
