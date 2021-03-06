port = 9001
interface = '0.0.0.0'

library(logging)
addHandler(writeToFile, file = '/var/www/html/RServer.log')
setLevel(loglevels)
loginfo('==================================================')

packages <- scan('packages.cfg',what='character')
success <- T

tryCatch(error = function(err) { logerror(paste('!',err));},
{
  loginfo('Initialization started')
  
  #load packages
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
  
  #if packages has been loaded
  if(success)
  {
    #load functions
    funs = list.files(path='functions/')
    loginfo('-> loading functions (%d functions to load)',length(funs))
    for(fun in funs)
    {
      source(paste('functions',fun,sep='/'))
      loginfo('---> function %s loaded', fun)
    }
    
    #create listener
    loginfo('-> creating listener on port %d',port)
    .Call(tools:::startHTTPD, interface, port)
    unlockBinding("httpdPort", environment(tools:::startDynamicHelp))
    assign("httpdPort", port, environment(tools:::startDynamicHelp))
    s <- Rhttpd$new() 
    s$listenAddr <- interface
    s$listenPort <- port
  
    #read and add applications
    apps = list.files(path='apps/')
    loginfo('-> loading applications (%d application to load)',length(apps))
    for(app in apps)
    {
      s$add(name = unlist(strsplit(app,'[.]'))[1], app = paste('apps',app,sep='/'))
      loginfo('---> application %s loaded', app)
    }
    
    s$print()
    
    loginfo('Initialization of rook server on port %d has ended. Server is working...',port)

  }
})
