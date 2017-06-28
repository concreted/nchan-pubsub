const WebSocket = require('ws');

const PUBSUB_HOST = 'localhost:8089';

let connections = {}

function buildConnectionString(type, id) {
  let connectionString = 'ws://' + PUBSUB_HOST + '/' + type + '/' + id;
  console.log(connectionString)
  return connectionString
}

function connect(type, id) {

  let connectionString = buildConnectionString(type, id);
  if (!(connectionString in connections)) {
    let ws = new WebSocket(connectionString);
    ws.on('error', function error(e) {
      console.log('error:')
      console.log(e)
    })
    ws.on('open', function open() {
      console.log('connection open');
      ws.send('something');
    });

    ws.on('message', function incoming(data) {
      console.log(data);

      // message receipt logic
      if (data.indexOf('join_group:') >= 0) {
        let group_id = data.split(':')[1]
        connect('thing_groups', group_id)
      } else if (data.indexOf('leave_group:') >= 0) {
        let group_id = data.split(':')[1]
        let cs = buildConnectionString('thing_groups', group_id)
        if (cs in connections) {
          connections[cs].close(3000, 'LEAVE_NOW')
          delete connections[cs]
        } else {
          console.log('no existing connection')
        }
      }
    });

    ws.on('close', function close(code, reason) {
      console.log('disconnected');
      delete connections[connectionString]
      // Try to reconnect if not sent a message to close
      console.log(code, reason)
      if (reason !== 'LEAVE_NOW') {
        setTimeout(function() {connect(type, id)}, 1000 * 5);
      }
    });

    // add to connections list
    connections[connectionString] = ws
  } else {
    console.log('already connected');
  }
}

connect('things', 'one');
