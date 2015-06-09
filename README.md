This (ruby) script can control beamers. Send on/off commands, get status etc.

run ./beamer.rb --help for .. help


For the web version

run

ruby ./api/run.rb

connect to the host

options:

list types
curl -XGET localhost:4567/types/
{"beamers":["panasonic","eikiwerkstraat","nec","eiki","casio"]}%

list options of beamer
curl -XGET localhost:4567/types/panasonic
{"options":["on","off","status"]}

send command
curl -XPOST localhost:4567/commnad/[on/off/staus/lamp/etc] -d
'{"host":"ip of extron",
"port":"telnet port",
"beamer":"beamer type",
"extron_port":"extron port number, leave empty if no port"}'

example
curl -XPOST localhost:4567/command/status -d '{"host":"10.100.0.199","port":"23","beamer":"panasonic","extron_port":"1"}'
