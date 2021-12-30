import 'package:flutter/material.dart';
import 'package:my_storage/local_storage_repository.dart';
import 'package:my_storage/shared_preferences_repository.dart';
import 'package:storage_counter/services/counter_service.dart';

class CounterPage extends StatefulWidget {
  CounterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _sharedPreferencesCounter;
  int _localStorageCounter;

  CounterService _sharedPreferencesCounterService;
  CounterService _localStorageCounterService;

  @override
  void initState() {
    super.initState();

    _localStorageCounter = 0;
    _sharedPreferencesCounter = 0;

    _sharedPreferencesCounterService = CounterService(
      localStorageRepository: SharedPreferencesRepository(),
    );
    _localStorageCounterService = CounterService(
      localStorageRepository: LocalStorageRepository("counter.json"),
    );
  }

  Future<void> _incrementCounter(bool useSharedPrefs) async {
    final int _newCount = useSharedPrefs
        ? await _sharedPreferencesCounterService
            .incrementAndSave(_sharedPreferencesCounter)
        : await _localStorageCounterService
            .incrementAndSave(_localStorageCounter);

    _updateCount(useSharedPrefs, _newCount);
  }

  Future<void> _decrementCounter(bool useSharedPrefs) async {
    final int _newCount = useSharedPrefs
        ? await _sharedPreferencesCounterService
            .decrementAndSave(_sharedPreferencesCounter)
        : await _localStorageCounterService
            .decrementAndSave(_localStorageCounter);

    _updateCount(useSharedPrefs, _newCount);
  }

  void _updateCount(bool useSharedPrefs, int count) {
    setState(() {
      useSharedPrefs
          ? _sharedPreferencesCounter = count
          : _localStorageCounter = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            _buildSharedPreferencesCounter(),
            _buildLocalStorageCounter()
          ],
        ),
      ),
    );
  }

  FutureBuilder<int> _buildSharedPreferencesCounter() {
    return FutureBuilder<int>(
      future: _sharedPreferencesCounterService.getCount(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          _sharedPreferencesCounter = snapshot.data;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => _decrementCounter(true),
              ),
              Text(
                '$_sharedPreferencesCounter',
                style: Theme.of(context).textTheme.headline4,
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _incrementCounter(true),
              ),
            ],
          );
        }

        return CircularProgressIndicator();
      },
    );
  }

  FutureBuilder<int> _buildLocalStorageCounter() {
    return FutureBuilder<int>(
      future: _localStorageCounterService.getCount(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          _localStorageCounter = snapshot.data;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => _decrementCounter(false),
              ),
              Text(
                '$_localStorageCounter',
                style: Theme.of(context).textTheme.headline4,
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _incrementCounter(false),
              ),
            ],
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
