const WebSocket = require('ws');

let ws = undefined;


function connect(url) {
  ws = new WebSocket('ws://' + url);
  ws.on('error', function error(e) {
    console.log('error:')
    console.log(e)
  })
  ws.on('open', function open() {
    ws.send('something');
  });

  ws.on('message', function incoming(data) {
    console.log(data);
  });

  ws.on('close', function close() {
    console.log('disconnected');
    setTimeout(function() {connect(url)}, 1000 * 5);
  });
}

connect('localhost:8089/things');
