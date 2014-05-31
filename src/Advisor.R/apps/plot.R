app <- function(env)
{
  t1 = Sys.time()
  
  req <- Rook::Request$new(env)
  res <- Rook::Response$new()
  
  query = Utils$parse_query(req$query_string())
  symbol = query$id
  x = as.numeric(query$x)
  y = as.numeric(query$y)
  pstart = as.Date(query$pstart)
  pstop = as.Date(query$pstop)
  data = GetAdvisorData(symbol,pstart,pstop)
  
  png(file='test.png',width=x,height=y)
  chartSeries(data, TA = 'addVo();addBBands();addCCI();addSMI()')
  dev.off()
  
  res$write(Sys.time()-t1)
  res$finish()
}