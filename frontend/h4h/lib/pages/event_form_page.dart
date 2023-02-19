import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:h4h/backend/database.dart';
import 'package:h4h/models/event.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Event Form Page'),
        ),
        body: const EventForm());
  }
}

class EventForm extends StatefulWidget {
  const EventForm({super.key});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final startDateTextController = TextEditingController();
  final startTimeTextController = TextEditingController();
  final endDateTextController = TextEditingController();
  final endTimeTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> entries = {
      'Name': TextFormField(
          controller: nameTextController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }),
      'Description (Optional)': TextFormField(
        controller: descriptionTextController,
      ),
      'Start Time': DateAndTimePickerField(
        dateController: startDateTextController,
        timeController: startTimeTextController,
        dateValidator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a date';
          }
          return null;
        },
        timeValidator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a time';
          }
          return null;
        },
      ),
      'EndTime (Optional)': DateAndTimePickerField(
        dateController: endDateTextController,
        timeController: endTimeTextController,
      ),
      'Location': TextButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LocationPickerPage())),
        child: const Text('Select Location'),
      )
    };

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...createFormEntries(entries),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );

                    DateTime startTime =
                        DateFormat.yMd().parse(startDateTextController.text);

                    DateTime endTime;
                    if (endDateTextController.text != "" &&
                        startTimeTextController.text != "") {
                      endTime =
                          DateFormat.yMd().parse(endDateTextController.text);
                    } else {
                      const defaultDuration = Duration(hours: 1);

                      startTime.add(defaultDuration);
                      endTime = startTime;
                      startTime.subtract(defaultDuration);
                    }

                    DB.instance.saveEvent(Event(
                      startTime: startTime,
                      endTime: endTime,
                      name: nameTextController.text,
                      description: descriptionTextController.text,
                      long: 0,
                      lat: 0,
                    ));
                  }
                },
                child: const Text('Create Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> createFormEntries(Map<String, Widget> entries) {
    List<Widget> formEntries = [];

    entries.forEach((key, value) =>
        formEntries.add(FormEntry(title: key, formWidget: value)));

    return formEntries;
  }
}

class DateAndTimePickerField extends StatelessWidget {
  const DateAndTimePickerField({
    super.key,
    required this.dateController,
    this.dateValidator,
    required this.timeController,
    this.timeValidator,
  });
  final TextEditingController dateController;
  final Function? dateValidator;
  final TextEditingController timeController;
  final Function? timeValidator;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: dateController,
            readOnly: true,
            decoration: const InputDecoration(hintText: 'Date'),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 31)));

              if (pickedDate != null) {
                dateController.text = DateFormat.yMd().format(pickedDate);
              }
            },
            validator: dateValidator != null
                ? (String? text) => dateValidator!(text)
                : null,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: timeController,
            readOnly: true,
            decoration: const InputDecoration(hintText: 'Time'),
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                initialTime: TimeOfDay.now(),
                context: context,
              );

              if (pickedTime != null) {
                DateTime parsedTime = DateFormat.jm()
                    .parse(pickedTime.format(context).toString());

                timeController.text = DateFormat.jm().format(parsedTime);
              }
            },
            validator: timeValidator != null
                ? (String? text) => timeValidator!(text)
                : null,
          ),
        ),
      ],
    );
  }
}

class FormEntry extends StatelessWidget {
  const FormEntry({
    super.key,
    required this.title,
    required this.formWidget,
  });
  final String title;
  final Widget formWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: formWidget,
        )
      ],
    );
  }
}

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late List<String> potentialPlaces;
  final addressTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Events Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                child: TextFormField(
                  //controller: addressTextController,
                  onChanged: (String text) async {},
                ),
              ),
              ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(potentialPlaces[index]),
                  onTap: () {},
                ),
              )
            ],
          ),
        ));
  }
}
