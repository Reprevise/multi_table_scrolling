import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

const double _kHeaderHeight = 32;
const double _kRowHeight = 48;
const int _kRowCount = 100;

class _TableWidget extends StatelessWidget {
  const _TableWidget({required this.hScrollController});

  final ScrollController hScrollController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32 + (48.0 * _kRowCount),
      child: TableView.builder(
        pinnedRowCount: 1,
        horizontalDetails: ScrollableDetails.horizontal(
          controller: hScrollController,
        ),
        primary: false,
        columnCount: 12,
        rowCount: _kRowCount + 1, // +1 for header
        columnBuilder: (idx) => const TableSpan(
          extent: FixedTableSpanExtent(72),
        ),
        rowBuilder: (idx) {
          if (idx == 0) {
            return const TableSpan(
              extent: FixedTableSpanExtent(_kHeaderHeight),
            );
          }

          return const TableSpan(extent: FixedTableSpanExtent(_kRowHeight));
        },
        cellBuilder: (context, vicinity) {
          final TableVicinity(:row, :column) = vicinity;

          Widget result = Text("($row, $column)");

          if (row == 0) {
            result = ColoredBox(
              color: Colors.redAccent.shade100,
              child: result,
            );
          }

          return result;
        },
      ),
    );
  }
}

class TableThing extends StatefulWidget {
  const TableThing({super.key});

  @override
  State<TableThing> createState() => _TableThingState();
}

class _TableThingState extends State<TableThing> {
  late final ScrollController _a, _b;

  @override
  void initState() {
    super.initState();
    final group = LinkedScrollControllerGroup();
    _a = group.addAndGet();
    _b = group.addAndGet();
  }

  @override
  void dispose() {
    _a.dispose();
    _b.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _TableWidget(hScrollController: _a),
        _TableWidget(hScrollController: _b),
      ],
    );
  }
}
