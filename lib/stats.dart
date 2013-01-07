/**
 * stats.dart
 *
 * Ported from https://github.com/mrdoob/stats.js from JavaScript to Dart
 * thanks to MrDoob (http://mrdoob.com) for his great stuff, we needed a
 * Dart version of this.
 */

library stats;

import 'dart:html';
import 'dart:math';

class Stats {

  Stopwatch _timer = new Stopwatch();

  int _ms = 0;
  int _msMin = 0;
  int _msMax = 0;
  int _fps = 0;
  int _fpsMin = 0;
  int _fpsMax = 0;
  int _frames = 0;
  int _mode = 0;

  bool _running = false;

  DivElement _container;
  DivElement _fpsDiv;
  DivElement _fpsText;
  DivElement _fpsGraph;
  DivElement _msDiv;
  DivElement _msText;
  DivElement _msGraph;


  void _containerMouseDown(MouseEvent e) {
    e.preventDefault();
    mode = ++mode % 2;
  }

  void _createUi() {
    SpanElement bar;

    _container = new DivElement()
      ..id = 'stats'
      ..on.mouseDown.add(_containerMouseDown, false)
      ..style.cssText = '''
        width:80px;opacity:0.9;cursor:pointer
      ''';

    _fpsDiv = new DivElement()
      ..id = 'fps'
      ..style.cssText = '''
        padding:0 0 3px 3px;text-align:left;background-color:#002
      ''';
    _container.append(_fpsDiv);

    _fpsText = new DivElement()
      ..id = 'fpsText'
      ..style.cssText = '''
        color:#0ff;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px
      '''
      ..text = 'FPS';
    _fpsDiv.append(_fpsText);

    _fpsGraph = new DivElement()
      ..id = 'fpsGraph'
      ..style.cssText = '''
        position:relative;width:74px;height:30px;background-color:#0ff
      ''';
    _fpsDiv.append(_fpsGraph);

    while (_fpsGraph.children.length < 74) {
      bar = new SpanElement()
        ..style.cssText = 'width:1px;height:30px;float:left;background-color:#113';
      _fpsGraph.append(bar);
    }

    _msDiv = new DivElement()
      ..id = 'msDiv'
      ..style.cssText = '''
        padding:0 0 3px 3px;text-align:left;background-color:#020;display:none
      ''';
    _container.append(_msDiv);

    _msText = new DivElement()
      ..id = 'msText'
      ..style.cssText = '''
        color:#0f0;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px
      '''
      ..text = 'MS';
    _msDiv.append(_msText);

    _msGraph = new DivElement()
      ..id = 'msGraph'
      ..style.cssText = '''
        position:relative;width:74px;height:30px;background-color:#0f0
      ''';
    _msDiv.append(_msGraph);

    while (_msGraph.children.length < 74) {
      bar = new SpanElement()
        ..style.cssText = 'width:1px;height:30px;float:left;background-color:#131';
      _msGraph.append(bar);
    }
  }

  void set mode(int value) {
    if (_mode != value) {
      _mode = value;

      switch (_mode) {
        case 0:
          _fpsDiv.style.display = 'block';
          _msDiv.style.display = 'none';
          break;
        case 1:
          _fpsDiv.style.display = 'none';
          _msDiv.style.display = 'block';
          break;
      }
    }
  }

  int get mode => _mode;

  _updateGraph(Element dom, num value) {
    Element child = dom.children[0];
    child.style.height = '${value}px';
    dom.append(child);
  }

  Element domElement() => _container;

  void begin() {
    if (_running == false) {
    _timer.start();
    _running = true;
    }
  }

  int end() {
    int time = _timer.elapsedMicroseconds;
    _ms = (time / 1000.0).toInt();
    _msMin = min(_msMin, _ms);
    _msMax = max(_msMax, _ms);

    _msText.text = '${_ms} MS (${_msMin}-${_msMax})';
    _updateGraph(_msGraph, min(30, 30 - (_ms / 200) * 30));
    _frames++;

    if (time > 1000) {
      _fps = ((_frames * 1000) ~/ _ms).toInt();
      _fpsMin = min(_fpsMin, _fps);
      _fpsMax = max(_fpsMax, _fps);
      _fpsText.text = '${_fps} FPS (${_fpsMin}-${_fpsMax})';

      _updateGraph(_fpsGraph, min(30, 30 - (_fps / 100 ) * 30));

      _timer.reset();
      _frames = 0;
    }
    return time;
  }

  void update() {
    end();
  }

  Stats() {
    _createUi();
  }
}
