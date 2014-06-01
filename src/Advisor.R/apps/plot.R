app <- function(env)
{
  # initialize veriable
  t1 = Sys.time()
  cached = T
  reqId = trunc(runif(1, 1000000, 9999999))
  
  #start processing request
  loginfo(paste("* request for plot made (id:",reqId,")",sep=""))
  req <- Rook::Request$new(env)
  res <- Rook::Response$new()
  
  result = tryCatch(
    {
      query = Utils$parse_query(req$query_string())
      symbolName = query$name
      symbol = query$id
      x = as.numeric(query$x)
      y = as.numeric(query$y)
      pstart = as.Date(query$pstart)
      pstop = as.Date(query$pstop)
      data = GetAdvisorData(symbol,pstart,pstop)
      
      catName = '/var/www/html'
      fileName = paste('plot_id',symbol
                       ,'_name',symbolName
                       ,'_x',as.character(x)
                       ,'_y',as.character(y)
                       ,'_pstart',as.character(pstart)
                       ,'_pstop',as.character(pstop)
                       ,'.png',sep='')
      fullPlotPath = paste(catName,fileName,sep='/')
      if (!file.exists(fullPlotPath))
      {
        cached = F
        png(file='fullPlotPath',width=x,height=y)
        chartSeries(data, TA = 'addVo();addBBands();addMACD()',theme='white',name=symbolName)
        dev.off()
      }
    }
    , warning = function(war)
    {
      logwarn(paste(reqId,as.character(war)))
      res$write(war)
    }
    , error = function(err)
    {
      logerror(paste(reqId,as.character(err)))
      res$write(err)
    })
  logMessage = paste("request for plot ended in with id:",reqId,"ended in ",as.character(Sys.time()-t1)) 
  if (cached)
  {
    paste(logMessage,'(from cache)')
  }
  loginfo(logMessage)
  res$write()
  res$finish()
}