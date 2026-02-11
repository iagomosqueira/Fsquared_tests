
# Installation


```r
install.packages(c("FLCore", "mse", "msemodules", "mseviz", "FLSRTMB",
  "ggplotFL", "FLasher", "TAF"),
  repos=c(FLR="https://flr.r-universe.dev", CRAN="https://cloud.r-project.org")) 
```


```r
handlers(global=TRUE)
```



- Run first with it = cores, so that the call to mps() runs in parallel


```r
draft.software(c('FLCore', 'FLasher', 'mse', 'FLSRTMB', 'msemodules'), file=TRUE)
```
