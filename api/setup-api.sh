wget https://github.com/ayuina/fusion-dev-sample/releases/download/app-v1/linux-x64.tar.gz
tar -zxvf ./linux-x64.tar.gz -C /tmp 
cd /tmp/linux-x64 
chmod 744 ./FusionDev.Samples.TodoApi 
sudo setcap CAP_NET_BIND_SERVICE=+eip ./FusionDev.Samples.TodoApi 
export ASPNETCORE_URLS=http://*:80
export ASPNETCORE_ENVIRONMENT=Development
