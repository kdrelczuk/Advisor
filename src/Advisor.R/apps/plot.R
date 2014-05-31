app <- function(env)
{
  t1 = Sys.time()
  loginfo("plot called")
  req <- Rook::Request$new(env)
  res <- Rook::Response$new()
  
  result = tryCatch(
    {
      query = Utils$parse_query(req$query_string())
      symbol = query$id
      x = as.numeric(query$x)
      y = as.numeric(query$y)
      pstart = as.Date(query$pstart)
      pstop = as.Date(query$pstop)
      data = GetAdvisorData(symbol,pstart,pstop)
      
      png(file='/var/www/html/test.png',width=x,height=y)
      chartSeries(data, TA = 'addVo();addBBands();addCCI();addSMI()')
      dev.off()
    }
    , warning = function(war)
    {
      logwarn(paste('plot application',war))
      res$write(war)
    }
    , error = function(err)
    {
      logerror(paste('plot application',err))
      res$write(err)
    })
  
  res$write(as.character(Sys.time()-t1))
  res$finish()
}