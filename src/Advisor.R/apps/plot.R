app <- function(env)
{
  # initialize veriable
  t1 = Sys.time()
  cached = T
  reqId = trunc(runif(1, 1000000, 9999999))
  logReqId = paste("(id:",reqId,")",sep='')
  
  #start processing request
  loginfo(paste(logReqId," app plot has been requested" ,sep=""))
  req <- Rook::Request$new(env)
  res <- Rook::Response$new()
  resJSONOK = '{ "data" : { "url": "%s", "performace": "%.2f", "requestID":"%d", "cached":"%s" }}'
  resJSONErr = '{ "error" : "%s" }'
  
  tryCatch(error = function(err) { logerror(paste(logReqId,err)); res$write(sprintf(resJSONErr,err)) },
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
        png(file=fullPlotPath,width=x,height=y)
        chartSeries(data, TA = 'addVo();addBBands();addMACD()',theme='white',name=symbolName)
        dev.off()
      }
      
      responseTime = round(Sys.time()-t1,2)
      logMessage = paste(logReqId , "request for plot application was handled in",as.character(responseTime),"s") 
      if (cached)
      {
        logMessage = paste(logMessage,'(from cache)')
      }

      res$write(sprintf(resJSONOK,fullPlotPath,responseTime,reqId,cached))
      loginfo(logMessage)      
    })

  res$finish()
}