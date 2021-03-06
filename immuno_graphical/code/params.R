library(here)
library(stringr)
save.results.to <- here("figs")

labels.assays <- c("Binding Antibody to Spike", "Binding Antibody to RBD",
                   "PsV Neutralization 50% Titer",
                   # "WT LV Neutralization 50% Titer",
                   "PsV Neutralization 80% Titer")
names(labels.assays) <- c("bindSpike", "bindRBD", "pseudoneutid50",
                          #"liveneutmn50",
                          "pseudoneutid80")
# color palatte throughout the report
study.name <- "mock"



# defining labels of the subgroups
times <- c("B", "Day29", "Day57", "Delta29overB", "Delta57overB")
assays <- c("bindSpike", "bindRBD", "pseudoneutid50", "pseudoneutid80")



# for now exclude the liveneut results
labels.assays <- labels.assays[assays]
labels.assays.long <- labels.assays.long[, assays]
labels.assays.short <- labels.assays.short[, assays]
labels.axis <- labels.axis[, assays]
labels.title <- labels.title[, assays]

labels.title2 <- apply(labels.title, c(1, 2), function(st) {
  str_replace(st, ":", "\n")
})

trt.labels <- c("Placebo", "Vaccine")
bstatus.labels <- c("Baseline Neg", "Baseline Pos")
bstatus.labels.2 <- c("BaselineNeg", "BaselinePos")

