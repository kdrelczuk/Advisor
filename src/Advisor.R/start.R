# basic config, set local to true when working on localhost
local <- T
port = 9001
interface = '0.0.0.'

library(logging)
addHandler(writeToFile, file = 'RServer.log')
loginfo('==================================================')

packages <- scan('packages.cfg',what='character')
success <- T

loginfo('Initialization started')
loginfo('-> loading packages (%d packages to load)',length(packages))
for(package in packages)
{
  if(package %in% rownames(installed.packages()))
  {
    do.call('library', list(package))
    loginfo('---> package %s loaded', package)
  }
  else 
  {
    success = F
    logwarn('---> package %s not found. Terminating!',package)
  }
} 

if(success)
{
  loginfo('-> creating listener on port %d',port)

  s <- Rhttpd$new() 
  s$start()
  unlockBinding("httpdPort", environment(tools:::startDynamicHelp))
  assign("httpdPort", port, environment(tools:::startDynamicHelp))
  s$listenAddr <- interface
  s$listenPort <- port

  apps = list.files(path='apps/')
  loginfo('-> loading applications (%d application to load)',length(apps))
  for(app in apps)
  {
    s$add(name = unlist(strsplit(app,'[.]'))[1], app = paste('apps',app,sep='/'))
    loginfo('---> application %s loaded', app)
  }
  loginfo('Initialization of rook server on port %d has ended. Server is working...',port)
}
