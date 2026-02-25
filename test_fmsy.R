# test_fmsy.R - DESC
# /home/mosqu003/Active/template_fsquared/Fsquared_tests/test_fmsy.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

library(msemodules)
library(FLBRP)

# LOAD om
load('model/om.rda')

# COMPUTE FMSY
rps <- brp(FLBRP(stock(om), sr=sr(om)))

refpts(rps)['msy', 'harvest',]


# -- RUN fixedC

load("model/arule.rda")

control <- mpCtrl(

  # (est)imation method: shortcut.sa + SSB deviances
  est = mseCtrl(method=perfect.sa),

  # hcr: hockeystick (fbar ~ ssb | lim, trigger, target, min)
  hcr = mseCtrl(method=fixedC.hcr,
    args=list(ctrg=10000))
)

tuneC <- tunebisect(om, control=control, args=mseargs,
  tune=list(ctrg=10000 * c(0.8, 1.2)),
  statistic=icestats["PBlim"], prob=0.05, tol=0.005, years=pys)

# SAVE & LOAD
save(tuneC, file='test/tuneC.rda', compress='xz')

load('test/tuneC.rda')

# CHECK catch
args(control(tuneC, "hcr"))$ctrg

# SHOW PBlim & F in final years
performance(tuneC, statistics=icestats["PBlim"])[year %in% seq(iy, fy, by=5),
  .(PBlim=mean(data)), by=year]

performance(tuneC, statistics=icestats["F"])[year %in% seq(iy, fy, by=5),
  .(F=mean(data)), by=year]

# SHOW final P(B<Blim)
performance(tuneC, statistics=icestats["PBlim"])[year %in% pys,
  .(PBlim=mean(data))]

# SHOW Fbar
yearMeans(fbar(tuneC)[, ac(pys)])

# COMPARE to fwd(C=tuneC$ctrg)

c005 <- fwd(om, control=fwdControl(year=seq(mseargs$iy + 1, mseargs$fy),
  quant='catch', value=args(control(tuneC, "hcr"))$ctrg))

performance(c005, statistics=icestats["PBlim"])[year %in% pys,
  .(PBlim=mean(data))]


# -- RUN with Btrigger = 0 (?)

args(arule$hcr)$trigger <- 0

# FIND Ftarget that gives mean P(B < Blim) = 5%
tune0trig <- tunebisect(om, control=arule, args=mseargs,
  tune=list(target=0.3 * c(0.5, 1.5)),
  statistic=icestats["PBlim"], prob=0.05, tol=0.005, years=pys)

# CHECK Ftarget value
args(control(tune0, "hcr"))$target

fbar(tune0)
