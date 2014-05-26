app <- function(env)
{
  req <- Rook::Request$new(env)
  res <- Rook::Response$new()
  
  data = rnorm(n=1000,mean=0,sd=10)
  png(file = "/var/www/html/plot.png", bg = "transparent")
  hist(data,col='red')
  dev.off()
  res$write(paste('Plot computed on ',Sys.time()))
  res$finish()
}