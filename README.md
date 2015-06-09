beamer control
===============
This (ruby) script can control beamers via Extron controllers. Send on/off commands, get status etc.


command line
-----------
```
run ./beamer.rb --help for .. help
run ./beamer.rb -l  .. list all beamer types
```


api
----
You need the sinatra gem. Install it by
```
gem install sinatra --no-ri --no-rdoc
```

Start the webserver
```
ruby ./api/run.rb
```
default port is `4567`.

connect to the host

options:

### list beamer types


`curl -XGET localhost:4567/types/`

returns
```
{"beamers":["panasonic","eikiwerkstraat","nec","eiki","casio"]}%
```

### list options of beamer
`curl -XGET localhost:4567/types/panasonic`
returns
```
{"options":["on","off","status"]}
```

### send command
```
curl -XPOST localhost:4567/commnad/[on/off/staus/lamp/etc] -d
'{"host":"ip of extron",
"port":"telnet port",
"beamer":"beamer type",
"extron_port":"extron port number, leave empty if no port"}'
```

example
```
curl -XPOST localhost:4567/command/status -d
 '{"host":"10.100.0.199","port":"23","beamer":"panasonic","extron_port":"1"}'
```
if the beamer is on it will return
```
{"result":"beamer is on"}
```

config of beamers
-----------------

config is done in a yaml file.

```
name: nec
commands:
  "on":
    cmd: "\e0__port__*2*76*1LE"
    returns:
      default:
        regex: !ruby/regexp /./
        message: "on command send"
  "off":
    cmd: "\e0__port__*2*76*3LE"
    returns:
      default:
        regex: !ruby/regexp /./
        message: "off command send"
  lamp:
    cmd: "\e0__port__*2*136LE"
    returns:
      default:
        regex: !ruby/regexp /./
        message: "current status (max = 6000): __return__"
  status:
    cmd: "\e0__port__*2*132LE"
    returns:
      1:
        regex: !ruby/regexp /^1$/
        message: "beamer is on"
      3:
        regex: !ruby/regexp /^3$/
        message: "beamer is off"
      default:
        regex: !ruby/regexp /./
        message: "unknown return: __return__"
```
