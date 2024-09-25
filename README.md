Socket management application
---

If called it will open a socket, optionally bind the socket, and
either try to connect to a remote address, or listen and accept
incoming connections.

It will monitor the sockets and recreate it if possible.

After a link is established it will notify a higher layer (the initial
calling user).

Will reuse the socket if the local address has already been bound or
if a link has already been established.


```mermaid
sequenceDiagram
    title Sequence diagram: Initiating Sockets

    participant a_user as User A<br />(i.e. diam);
    participant a_app as sock application;
    participant a_client as sock client<br />(1.1.1.1:3456);
    participant a_client_busy as sock client spwn<br />(2.2.2.2:5555);

    autonumber

    a_user->>a_app: call initiate conn;
    a_app->>a_client: spawn;
    note right of a_client: bind local addr;
    a_client->>a_client_busy: connect rem addr;
    a_client_busy-xb_server_busy: connect;
    a_client_busy-xb_server_busy: retry;
    a_client_busy-xb_server_busy: retry;

    participant b_server_busy as sock server spwn<br />(2.2.2.2:5555);
    participant b_server as sock server<br />(2.2.2.2:5555);
    participant b_app as sock application;
    participant b_user as User B<br />(i.e. diam);

    b_user->>b_app: call initiate sock;
    b_app->>b_server: spawn;
    note left of b_server: bind local addr;
    b_server->>+b_server_busy: listen;
    a_client_busy->>b_server_busy: retry;
    b_server_busy-->>a_client_busy: ;
    b_server_busy->>b_server: accept;
    a_client_busy-->>a_client: ;
    a_client->>a_user: notify
    b_server->>b_user: notify;

    deactivate b_server_busy
```

Options
---
```erlang

```


Examples
---
```erlang
1> application:ensure_all_started(sock).
{ok, [sock]}.
2> sock:start_client(#{remote_addr => #{port => 3565, addr => {127,0,0,1}, family => inet}}).
{ok, _}
3> sock:start_server(#{local_addr => #{port => 3565}}).
{ok, _}
4> sock:connect(#{port => 3565, addr => {127,0,0,1}, family => inet}).

```
