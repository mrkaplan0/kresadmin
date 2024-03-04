import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/models/events.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime firstDay = DateTime(2023, 12, 31);
  DateTime lastDay = DateTime(2033, 12, 31);
  late TextEditingController dateController;

  final _formKeyEvent = GlobalKey<FormState>();

  late LinkedHashMap<DateTime, List<Event>> events = LinkedHashMap();
  @override
  void initState() {
    super.initState();
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _getAllEvents(userModel);
    dateController = TextEditingController();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future _getAllEvents(UserModel userModel) async {
    await userModel
        .fetchEvents(
      userModel.users!.kresCode!,
      userModel.users!.kresAdi!,
    )
        .then((eventsList) {
      events = LinkedHashMap(
        equals: isSameDay,
        hashCode: getHashCode,
      )..addAll(eventsList);

      setState(() {});
      return events;
    });
    _selectedEvents.value = _getEventsForDay(_focusedDay);
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day.toLocal()] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Calendar'),
        actions: [
          IconButton(
              onPressed: (() {
                _addEventDialog(context);
              }),
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            rangeSelectionMode: RangeSelectionMode.disabled,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
                markerDecoration:
                    BoxDecoration(color: Colors.amber, shape: BoxShape.circle)),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(value[index].title),
                        subtitle: Text(value[index].eventInfo),
                        onLongPress: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("Etkinligi sil?"),
                            showCloseIcon: true,
                            action: SnackBarAction(
                                label: "Sil",
                                textColor: Colors.red,
                                onPressed: () async {
                                  final UserModel userModel =
                                      Provider.of<UserModel>(context,
                                          listen: false);

                                  await userModel
                                      .deleteEvent(
                                          userModel.users!.kresCode!,
                                          userModel.users!.kresAdi!,
                                          value[index])
                                      .then(
                                          (value) => _getAllEvents(userModel));
                                }),
                          ));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addEventDialog(BuildContext context) {
    String? eventTitle, eventInfo;
    DateTime? pickedDate;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Etkinlik Ekle"),
            content: Form(
              key: _formKeyEvent,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        labelText: 'Etkinlik Adi',
                        suffixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Icon(Icons.title),
                        )),
                    onSaved: (newValue) {
                      eventTitle = newValue;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        labelText: 'Etkinlik Info',
                        suffixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Icon(Icons.text_snippet_outlined),
                        )),
                    onSaved: (newValue) {
                      eventInfo = newValue;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: "Enter Date"),
                      readOnly: true,
                      onTap: () async {
                        pickedDate = await showDatePicker(
                            context: context,
                            firstDate: firstDay,
                            lastDate: lastDay);
                        if (pickedDate != null) {
                          dateController.text =
                              DateFormat.yMd().format(pickedDate!);
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      btnText: "Kaydet",
                      btnColor: Theme.of(context).primaryColor,
                      onPressed: () async {
                        final UserModel userModel =
                            Provider.of<UserModel>(context, listen: false);
                        if (_formKeyEvent.currentState!.validate() &&
                            dateController.text.isNotEmpty) {
                          _formKeyEvent.currentState!.save();

                          await userModel
                              .addNewEvents(
                                  userModel.users!.kresCode!,
                                  userModel.users!.kresAdi!,
                                  Event(
                                      eventsID: const Uuid().v4(),
                                      title: eventTitle!,
                                      eventDate: pickedDate!,
                                      eventInfo: eventInfo!))
                              .then((value) {
                            _getAllEvents(userModel);
                            Navigator.pop(context);
                          });
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }
}
