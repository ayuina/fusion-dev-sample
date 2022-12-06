param greeting string = 'Hello'
param name string = 'User'
param numberToFormat int = 8175133
param fmt string = '{0}, {1}. Formatted number: {2:N0}'

param apppackUrl string = 'https://github.com/ayuina/fusion-dev-sample/releases/download/app-v1/linux-x64.tar.gz'

var arr = [greeting, name, numberToFormat]


var scriptLines = [
  'wget ${apppackUrl}'
  ' && tar -zxvf ./linux-x64.tar.gz -C /tmp'
  ' && cd /tmp/linux-x64'
  ' && chmod 744 ./FusionDev.Samples.TodoApi'
  ' && sudo setcap CAP_NET_BIND_SERVICE=+eip ./FusionDev.Samples.TodoApi'
  ' && export ASPNETCORE_URLS=http://*:80'
  ' && export ASPNETCORE_ENVIRONMENT=Development'
  ' && export ApplicationInsights__ConnectionString={0}'
  ' && nohup ./FusionDev.Samples.TodoApi &'
]


output formatTest string = format(fmt, greeting, name, numberToFormat)
output reduceTest string = reduce(scriptLines,'', (a, b) => '${a} ${format(b, 'constr')}')