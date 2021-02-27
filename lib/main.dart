import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:custom_localization/utils/custom_localizations.dart';

import 'config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  CustomLocalizationsDelegate _localizationsDelegate;

  @override
  void initState() {
    super.initState();
    _localizationsDelegate = new CustomLocalizationsDelegate(null);
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localizationsDelegate = new CustomLocalizationsDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        _localizationsDelegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        ...SUPPORTED_LANGUAGES.map((local) => Locale(local, '')),
      ],
      title: APP_TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(changeLocale: onLocaleChange,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Function(Locale) changeLocale;

  MyHomePage({Key key, this.changeLocale}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CustomLocalizations.of(context).getTranslation("title")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              CustomLocalizations.of(context).getTranslation("greeting"),
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              CustomLocalizations.of(context).getTranslation("cool"),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Text(
              CustomLocalizations.of(context).getTranslation("noTranslation"),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.language,
          color: Colors.white,
        ),
        onPressed: () {
          if (CustomLocalizations.of(context).locale.languageCode == 'en') {
            widget.changeLocale(Locale('de', ''));
          } else {
            widget.changeLocale(Locale('en', ''));
          }
        },
      ),
    );
  }
}
