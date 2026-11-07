import 'package:web/web.dart' as web;

/// Web implementation using modern package:web (compatible with JS and Wasm)
void openUrl(String url) {
  web.window.open(url, '_blank');
}

void downloadFile(String url, String fileName) {
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.target = '_blank';
  anchor.download = fileName;
  anchor.click();
}
