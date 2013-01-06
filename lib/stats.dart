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

  int _startTime;
  int _prevTime;
  int _ms;
  double _msMin;
  double _msMax;
  int _fps;
  double _fpsMin;
  double _fpsMax;
  double _frames;
  int _mode;

  DivElement _container;
  DivElement _fpsDiv;
  DivElement _fpsText;
  DivElement _fpsGraph;
  DivElement _msDiv;
  DivElement _msText;
  DivElement _msGraph;

  void _initialize() {
    _startTime = new Date.now().millisecondsSinceEpoch;
    _prevTime = _startTime;
    _ms = 0;
    _msMin = 0.0;
    _msMax = 0.0;
    _fps = 0;
    _fpsMin = 0.0;
    _fpsMax = 0.0;
    _frames = 0.0;
    _mode = 0;
  }

  void _containerMouseDown(MouseEvent e) {
    e.preventDefault();

    mode = ++mode % 2;
    print('oops');
  }

  void _createUi() {
    SpanElement bar;

    _container = new DivElement();
    _container.id = 'stats';
    _container.on.mouseDown.add(_containerMouseDown);
    _container.style.cssText = '''
      width:80px;opacity:0.9;cursor:pointer
    ''';

    _fpsDiv = new DivElement();
    _fpsDiv.id = 'fps';
    _fpsDiv.style.cssText = '''
      padding:0 0 3px 3px;text-align:left;background-color:#002
    ''';
    _container.append(_fpsDiv);

    _fpsText = new DivElement();
    _fpsText.id = 'fpsText';
    _fpsText.style.cssText = '''
      color:#0ff;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px
    ''';
    _fpsText.text = 'FPS';
    _fpsDiv.append(_fpsText);

    _fpsGraph = new DivElement();
    _fpsGraph.id = 'fpsGraph';
    _fpsGraph.style.cssText = '''
      position:relative;width:74px;height:30px;background-color:#0ff
    ''';
    _fpsDiv.append(_fpsGraph);

    while (_fpsGraph.children.length < 74) {
      bar = new SpanElement();
      bar.style.cssText = 'width:1px;height:30px;float:left;background-color:#113';
      _fpsGraph.append(bar);
    }

    _msDiv = new DivElement();
    _msDiv.id = 'msDiv';
    _msDiv.style.cssText = '''
      padding:0 0 3px 3px;text-align:left;background-color:#020;display:none
    ''';
    _container.append(_msDiv);

    _msText = new DivElement();
    _msText.id = 'msText';
    _msText.style.cssText = '''
      color:#0f0;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px
    ''';
    _msText.text = 'MS';
    _msDiv.append(_msText);

    _msGraph = new DivElement();
    _msGraph.id = 'msGraph';
    _msGraph.style.cssText = '''
      position:relative;width:74px;height:30px;background-color:#0f0
    ''';
    _msDiv.append(_msGraph);

    while (_msGraph.children.length < 74) {
      bar = new SpanElement();
      bar.style.cssText = 'width:1px;height:30px;float:left;background-color:#131';
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
    child.style.height = '${value.toString()}px';
    dom.append(child);
  }

  Element domElement() => _container;

  void begin() {
    _startTime = new Date.now().millisecondsSinceEpoch;
  }

  int end() {
    int time = new Date.now().millisecondsSinceEpoch;
    _ms = time - _startTime;
    _msMin = min(_msMin, _ms).toDouble();
    _msMax = max(_msMax, _ms).toDouble();

    _msText.text = '${_ms} MS (${_msMin}-${_msMax})';
    _updateGraph(_msGraph, min(30, 30 - (_ms / 200) * 30));
    _frames++;

    if (time > _prevTime + 1000) {
      _fps = ((_frames * 1000) / (time - _prevTime)).toInt();

      _fpsMin = min(_fpsMin, _fps).toDouble();
      _fpsMax = max(_fpsMax, _fps).toDouble();

      _fpsText.text = '${_fps} FPS (${_fpsMin}-${_fpsMax})';
      _updateGraph(_fpsGraph, min(30, 30 - (_fps / 100 ) * 30));
      _prevTime = time;
      _frames = 0.0;
    }
    return time;
  }

  void update() {
    _startTime = end();
  }

  Stats() {
    _initialize();
    _createUi();
  }
}
