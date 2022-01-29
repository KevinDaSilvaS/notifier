# Notifier
Notifier app using erlang stack(rabbit-mq, couch-db and elixir) to send push notifications through websockets(phoenix channels)

### Sender
Generally other apps(or services) push a message in the ```notifications``` queue with a body ```{"user_id": "user_id", "message": "notification body", "title": "my notification"}``` and when consumed the message will be sent via websockets to the topic ```room:user_id``` where it will be broadcasted to connected sockets and saved on couchdb.

### Client
Client app that connects to the topic ```room:user_id``` and monitors the ```shout``` channel waiting for broadcasted messages.

### Getting previous notifications
The app also has a url to access the previous notifications stored in db in a GET method ```localhost:4000/api/notifications``` that accepts the ```page=integer number``` and/or ```limit=integer number``` to limit and filter notifications.

### Architecture Overview
<img src="https://github.com/KevinDaSilvaS/notifier/blob/main/assets/architecture.png">
