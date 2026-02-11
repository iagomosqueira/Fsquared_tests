# output_fsquared.R - generates tables and other outputs
# Fsquared/output_fsquared.R

#===============================================================================
# Fsquared - estimation of F reference points for the ICES advice rule
# Authors: participants of workshop on the validation of new tool for refpts
#   Iago Mosqueira (WMR) <iago.mosqueira@wur.nl>
#	  Ernesto Jardim (IPMA) <ernesto.jardim@ipma.pt>
#	  John Trochta (IMR) <john.tyler.trochta@hi.no>
#	  Arni Magnusson (SPC) <arnim@spc.int>
#	  Max Cardinale (SLU) <massimiliano.cardinale@slu.se>
#	  Dorleta Garcia (ICES) <dorleta.garcia@ices.dk>
#	  Colin Millar (ICES) <colin.millar@ices.dk>
#
# Distributed under the terms of the EUPL 1.2
#===============================================================================


library(mse)
library(msemodules)

# model_fsquared.R {{{ ----

load("model/fsquared.rda")

# INSPECT decisions

# START
inspect(tracking(tune)[year < 2028])

# decisions (step >= hcr)
inspect(tracking(tune)[year < 2028], 'decisions')

# SB-related metrics
inspect(tracking(tune)[year < 2028], 'SB')

# TRACK single iteration
inspect(tracking(tune)[iter == 15,])

# }}}
