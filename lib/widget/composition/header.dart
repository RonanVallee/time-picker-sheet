import 'package:flutter/material.dart';
import 'package:time_picker_sheet/widget/provider/time_picker.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({super.key, required this.showCloseIcon});

  final bool showCloseIcon;

  @override
  Widget build(BuildContext context) {
    final provider = TimePickerProvider.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            showCloseIcon ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          if (showCloseIcon)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    provider.sheetCloseIcon,
                    color: provider.sheetCloseIconColor,
                  )),
            ),
          Text(provider.sheetTitle, style: provider.sheetTitleStyle),
        ],
      ),
    );
  }
}
