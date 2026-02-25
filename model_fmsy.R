# model_fmsy.R - DESC
# Fsquared_tests/model_fmsy.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(mse)
library(msemodules)
library(FLBRP)

source('utilities_fsquared.R')

# LOAD Fsquared run
load('model/fsquared.rda')

pys <- seq(args(tune)$fy-5, args(tune)$fy)

# -- COMPUTE BRPs

rps <- brp(FLBRP(stock(om), sr=sr(om)))

# SAVE
save(rps, file="test/rps.rda")


# -- TUN arule with Btrigger = 0 (?)

arule <- control(tune)

# SET trigger=0

args(arule$hcr)$trigger <- 0

# FIND Ftarget that gives mean P(B < Blim) = 5%
tune0 <- tunebisect(om, control=arule, args=args(tune),
  tune=list(target=0.3 * c(0.5, 1.5)),
  statistic=icestats["PBlim"], prob=0.05, tol=0.005, years=pys)

# SAVE
save(tune0, file="test/tune_Btrigger_0.rda")


# -- TUNE fixedC to P(SB<Blim) = 0.05

control <- mpCtrl(

  # (est)imation method: shortcut.sa + SSB deviances
  est = mseCtrl(method=perfect.sa),

  # hcr: hockeystick (fbar ~ ssb | lim, trigger, target, min)
  hcr = mseCtrl(method=fixedC.hcr,
    args=list(ctrg=10000))
)

tuneC <- tunebisect(om, control=control, args=args(tune),
  tune=list(ctrg=10000 * c(0.8, 1.2)),
  statistic=icestats["PBlim"], prob=0.05, tol=0.005, years=pys)

# SAVE & LOAD
save(tuneC, file='test/tuneC.rda', compress='xz')


# -- RUN fixedF

control <- mpCtrl(

  # (est)imation method: shortcut.sa + SSB deviances
  est = mseCtrl(method=perfect.sa),

  # hcr: hockeystick (fbar ~ ssb | lim, trigger, target, min)
  hcr = mseCtrl(method=fixedF.hcr,
    args=list(ftrg=0.23)),

  # (i)mplementation (sys)tem: tac.is (C ~ F)
  isys = mseCtrl(method=tac.is, args=list(recyrs=-2,
    Fdevs=args(control(tune)$isys)$Fdevs))
)

tuneF <- tunebisect(om, control=control, args=args(tune),
  tune=list(ftrg=0.22 * c(0.5, 1.5)),
  statistic=icestats["PBlim"], prob=0.05, tol=0.005, years=pys)

# SAVE & LOAD
save(tuneF, file='test/tuneF.rda', compress='xz')
