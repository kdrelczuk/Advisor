GetAdvisorData = function(ticker, start, stop)
{
  if (.Platform$OS.type == "unix")
  {
    drv <- JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver"
                , "/etc/sqljdbc_2.0/sqljdbc4.jar")
  } else 
  {
    drv <- JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver"
                , "C:/Program Files/Microsoft JDBC Driver 4.0 for SQL Server/sqljdbc_4.0/enu/sqljdbc4.jar")
  }
  
  conn = dbConnect(drv, "jdbc:sqlserver://192.168.0.11","rubuntu","p@ssword!")
  dbSendUpdate(conn,"use Advisor")
  query = paste("select * from vTickerDailyData where TickerID = ",ticker," and Point between '",start,"' and '",stop,"'",sep='')
  sqlResponse = dbGetQuery(conn,query)
  xts(sqlResponse[,4:8],order.by=as.Date(sqlResponse[,3]))
}
