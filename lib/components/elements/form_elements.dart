import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/components/elements/text_element.dart';
import 'package:sample/components/elements/number_element.dart';
import 'package:sample/components/elements/time_element.dart';
import 'package:sample/components/elements/readonly_element.dart';
import 'package:sample/components/elements/select_element.dart';
import 'package:sample/components/elements/picklist_element.dart';
import 'package:sample/components/elements/camera_element.dart';
import 'package:sample/components/elements/attachment_element.dart';
import 'package:sample/components/elements/signature_element.dart';
import 'package:sample/components/elements/location_element.dart';
import 'package:sample/components/elements/date_element.dart';
import 'package:sample/components/elements/datetime_element.dart';
import 'package:sample/components/elements/unsupported_element.dart';
import 'package:sample/providers/elements_provider.dart';
import 'package:sample/models/element_model.dart';

class FormElements extends StatelessWidget {
  const FormElements({super.key});

  Widget getElement(ElementModel element) {
    switch (element.data_type) {
      case 1:
        return TextElement(element: element);
      case 2:
        return NumberElement(element: element);
      case 3:
        return DateElement(element: element);
      case 4:
        return TimeElement(element: element);
      case 5:
        return DateTimeElement(element: element);
      case 7:
        return SelectElement(element: element);
      case 8:
        return PicklistElement(element: element);
      case 11:
        return CameraElement(element: element);
      case 12:
        return SignatureElement(element: element);
      case 32:
        return AttachmentElement(element: element);
      case 33:
        return ReadOnlyElement(element: element);
      case 37:
        return LocationElement(element: element);

      default:
        return UnsupportedElement(element: element);
    }
  }

  Widget elementContainer(Widget element) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: element);
  }

  @override
  Widget build(BuildContext context) {
    final elementsProvider =
        Provider.of<ElementsProvider>(context, listen: false);
    var elements = elementsProvider.elements;
    return Column(
      children: [for (var ele in elements) elementContainer(getElement(ele))],
    );
  }
}
