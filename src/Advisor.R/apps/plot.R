app <- function(env)
{
  data = rnorm(n=1000,mean=0,sd=10)
  png(file = "/var/www/html/plot.png", bg = "transparent")
  hist(data,col='red')
  dev.off()
}