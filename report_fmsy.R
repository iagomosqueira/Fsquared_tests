# test_fmsy_plot.R - DESC
# /home/mosqu003/Active/template_fsquared/Fsquared_tests/test_fmsy_plot.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(mse)
library(msemodules)

pys <- ac(2067:2071)

# -- PLOT fgrid

# LOAD

load('model/fsquared.rda')

# PLOT PBlim  ~ F

dat <- fgrid[statistic == 'PBlim' & year %in% pys, .(data=mean(data)), by=.(run)]

ggplot(dat, aes(x=run, y=data)) +
  geom_point() +
  scale_x_discrete(name="F", labels=seq(0, 1.5, length=50)[c(TRUE, FALSE, FALSE)],
    breaks=function(x) x[c(TRUE, FALSE, FALSE)]) +
    ggtitle("Average probability of SSB falling below Blim over selected years by F level") +
   geom_hline(yintercept = 0.05, linewidth = 0.5, linetype = "dashed", color="gray50")


# -- BRPs: FMSY without F error

load('model/rps.rda')

fmsy(rps)

# -- TUNE w/Btrigger = 0


load("model/tune_Btrigger_0.rda")

# CHECK Ftarget value
args(control(tune0, "hcr"))$target

# CHECK final mean Fbar
yearMeans(fbar(tune0)[, ac(pys)])

# CHECK mean final catch
yearMeans(catch(tune0)[, ac(pys)])

# CHECK differences F(hcr) and F(fwd)
inspect(tracking(tune0))[40:50, .(year, hcr, isys, fwd)]

