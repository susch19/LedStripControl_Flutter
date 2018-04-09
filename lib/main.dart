import 'dart:async';
import 'package:flutter/material.dart';
import 'package:led_control/helper_methods.dart';
import 'package:quick_actions/quick_actions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LED Strip Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'LED Strip Control'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class RGBW {
  int r = 0;
  int g = 0;
  int b = 0;
  int w = 0;

  double get dr => r.toDouble();
  double get dg => g.toDouble();
  double get db => b.toDouble();
  double get dw => w.toDouble();
  String get hr => _toRadixBase16(r);
  String get hg => _toRadixBase16(g);
  String get hb => _toRadixBase16(b);
  String get hw => _toRadixBase16(w);

  set dr(double val) {
    r = val.toInt();
  }

  set dg(double val) {
    g = val.toInt();
  }

  set db(double val) {
    b = val.toInt();
  }

  set dw(double val) {
    w = val.toInt();
  }

  String _toRadixBase16(int val) {
    String ret = val.toRadixString(16);
    if (ret.length == 1) ret = "0" + ret;
    return ret;
  }

  RGBW() {}

  RGBW.rgb(int red, int green, int blue) {
    r = red;
    g = green;
    b = blue;
  }

  RGBW.rgbw(int red, int green, int blue, int white) {
    RGBW.rgb(red, green, blue);
    w = white;
  }

  RGBW.color(Color c) {
    RGBW.rgb(c.red, c.green, c.blue);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  double brightness = 255.0;
  double delay = 30.0;
  static const int colordelay = 50;
  DateTime dateTime = DateTime.now();
  RGBW rgbw = new RGBW();
  String debug = "";

  int get idelay => delay.toInt();
  int get ibrightness => brightness.toInt();

  @override
  void initState() {
    super.initState();
    final QuickActions quickActions = const QuickActions();
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'Off')
        turnLedOff();
      else if (shortcutType == 'RGB Cycle')
        toggleRGBCycle();
      else if (shortcutType == 'RGB Wander')
        toggleWanderRGB();
      else if (shortcutType == 'White') toggleWhiteColor();
    });
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'Off', localizedTitle: 'Off', icon: 'AppIcon'),
      const ShortcutItem(type: 'RGB Cycle', localizedTitle: 'RGB Cycle', icon: 'AppIcon'),
      const ShortcutItem(type: 'RGB Wander', localizedTitle: 'RGB Wander', icon: 'AppIcon'),
      const ShortcutItem(type: 'White', localizedTitle: 'White', icon: 'AppIcon')
    ]);
  }

  Future turnLedOff() async {
    return HelperMethods.get("Off", context);
  }

  Future fastRGB() async {
    return HelperMethods.get("RGB", context);
  }

  Future strobo() async {
    return HelperMethods.get("STROBO", context);
  }

  Future toggleRGBCycle() async {
    return HelperMethods.get("rgbcycle", context);
  }

  Future toggleWander() async {
    return HelperMethods.get("wander", context);
  }

  Future toggleWanderRGB() async {
    return HelperMethods.get("RGBWander", context);
  }

  Future toggleSingleColor() async {
    HelperMethods.get("options?color=x${rgbw.hw+rgbw.hb+rgbw.hg+rgbw.hr}", context);
    return HelperMethods.get("single", context);
  }

  Future toggleWhiteColor() async {
    HelperMethods.get("options?color=xFF000000", context);
    return HelperMethods.get("single", context);
  }

  Future toggleReverse() async {
    return HelperMethods.get("reverse", context);
  }

  Future changeDelay(int delay) async {
    return HelperMethods.get("options?delay=$delay", context);
  }

  Future changeColor() async {
    return HelperMethods.get("options?color=x${rgbw.hw+rgbw.hb+rgbw.hg+rgbw.hr}", context);
  }

  Future changeMaxBrightness(int brightness) async {
    return HelperMethods.get("options?brightness=x${brightness.toRadixString(16)}", context);
  }

  Future resetConnection() async {
    return HelperMethods.get("resetConnection/", context);
  }

  Future sendIt() async {
    changeMaxBrightness(brightness.toInt());
    changeDelay(delay.toInt());
  }

  void sliderChange(Function f, int dateTimeMilliseconds, [int val]) {
    if (DateTime.now().isAfter(dateTime.add(new Duration(milliseconds: dateTimeMilliseconds)))) {
      Function.apply(f, val == null ? [] : [val]);
      dateTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          new ListTile(
            title: new MaterialButton(
              child: const Text(
                'Off',
              ),
              onPressed: turnLedOff,
            ),
          ),
          new ListTile(
            title: new MaterialButton(
              child: const Text(
                'Fast RGB',
              ),
              onPressed: fastRGB,
            ),
          ),
          new ListTile(
            title: new MaterialButton(
              child: const Text(
                'Strobo',
              ),
              onPressed: strobo,
            ),
          ),
          new ListTile(
            title: new MaterialButton(
              child: const Text(
                'RGBCycle',
              ),
              onPressed: toggleRGBCycle,
            ),
          ),
          new ListTile(
            title: new MaterialButton(
              child: const Text(
                'Wander',
              ),
              onPressed: toggleWander,
            ),
          ),
          new ListTile(
            title: new MaterialButton(
              child: const Text(
                'Wander RGB',
              ),
              onPressed: toggleWanderRGB,
            ),
          ),
          new ListTile(
            title: new MaterialButton(
              child: const Text(
                'White',
              ),
              onPressed: toggleWhiteColor,
            ),
          ),
          new ListTile(
            title: new MaterialButton(
              child: const Text(
                'Reverse',
              ),
              onPressed: toggleReverse,
            ),
          ),
          new ExpansionTile(
            title: const Text(
              'SingleColor',
            ),
            children: <Widget>[
              new ListTile(
                subtitle: new Text("Red: ${rgbw.hr} | ${rgbw.r}"),
                title: new Slider(
                  value: rgbw.dr,
                  onChanged: (d) {
                    setState(() => rgbw.dr = d);
                    sliderChange(changeColor, colordelay);
                  },
                  min: 0.0,
                  max: 255.0,
                  label: 'R',
                ),
              ),
              new ListTile(
                subtitle: new Text("Green: ${rgbw.hg} | ${rgbw.g}"),
                title: new Slider(
                  value: rgbw.dg,
                  onChanged: (d) {
                    setState(() => rgbw.dg = d);
                    sliderChange(changeColor, colordelay);
                  },
                  min: 0.0,
                  max: 255.0,
                  label: 'G',
                ),
              ),
              new ListTile(
                subtitle: new Text("Blue: ${rgbw.hb} | ${rgbw.b}"),
                title: new Slider(
                  value: rgbw.db,
                  onChanged: (d) {
                    setState(() => rgbw.db = d);
                    sliderChange(changeColor, colordelay);
                  },
                  min: 0.0,
                  max: 255.0,
                  label: 'B',
                ),
              ),
              new ListTile(
                subtitle: new Text("White: ${rgbw.hw} | ${rgbw.w}"),
                title: new Slider(
                  value: rgbw.dw,
                  onChanged: (d) {
                    setState(() => rgbw.dw = d);
                    sliderChange(changeColor, colordelay);
                  },
                  min: 0.0,
                  max: 255.0,
                  label: 'W',
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'Color: ${rgbw.hw+rgbw.hb+rgbw.hg+rgbw.hr}',
                  ),
                  new MaterialButton(
                    child: new Text(
                      'SingleColor',
                    ),
                    onPressed: toggleSingleColor,
                  ),
                ],
              )
            ],
          ),

          new ListTile(
            subtitle: new Text("Delay ${idelay.toString()}ms"),
            title: new GestureDetector(
              child: new Slider(
                value: delay,
                onChanged: (d) {
                  setState(() => delay = d);
                  sliderChange(changeDelay, idelay, idelay);
                },
                min: 0.0,
                max: 1000.0,
                label: '${delay.round()}',
              ),
              onTapCancel: () => changeDelay(idelay),
            ),
          ),
          new ListTile(
            subtitle: new Text("Brightness ${brightness.toInt().toString()}"),
            title: new GestureDetector(
              child: new Slider(
                value: brightness,
                onChanged: (d) {
                  setState(() => brightness = d);
                  sliderChange(changeMaxBrightness, 100, ibrightness);
                },
                min: 0.0,
                max: 255.0,
                label: '${brightness.round()}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
