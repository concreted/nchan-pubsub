# nchan-pubsub

## dev

```
./build.sh
```

```
./start_server.sh
```

## Checklist
- [ ] Pubsub working
    - [x] Server config - pubsub by id
    - [x] Client subscribe by id
    - [x] Client publish by id
    - [x] Client receive queue msgs on connect
        - [ ] Limit to X number
    - [ ] Keep track of message ID for received msgs
- [ ] Authentication
    - [ ] Auth revocation
- [x] Groups
    - [x] Sub to group
    - [x] Unsub from group
- [ ] Uses Redis
- [ ] Clusterable
