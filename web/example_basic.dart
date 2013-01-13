import 'dart:html';
import 'dart:math';

import '../lib/dart_stats.dart';

Stats stats;
CanvasElement canvas;
CanvasRenderingContext2D context;

void main() {
  stats = new Stats();
  stats.mode = 1;
  document.body.append(stats.domElement());

  canvas = new CanvasElement();
  canvas.width = 512;
  canvas.height = 512;
  document.body.append(canvas);

  context = canvas.getContext('2d');
  context.fillStyle = 'rgba(127, 0, 25, 0.05)';

  loop (num time) {
    window.requestAnimationFrame(loop);

    double t = new Date.now().millisecondsSinceEpoch * 0.001;
    context.clearRect(0, 0, canvas.width, canvas.height);
    stats.begin();

    for (int i = 0; i < 2000; i++) {
      double x = cos(t + i * 0.01) * 196 + 256;
      double y = sin(t + i * 0.01234) * 196 + 256;

      context.beginPath();
      context.arc(x, y, 8, 0, PI * 2, true);
      context.fill();
    }
    stats.end();
  }
  window.requestAnimationFrame(loop);
}