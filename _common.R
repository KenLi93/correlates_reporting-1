library(methods)
library(dplyr)
library(kyotil)
set.seed(98109)

###############################################################################
# reading in data set
###############################################################################
# NOTE: `data_in_file` must exist in the top-level data_raw subdirectory
data_in_file <- "COVID_VEtrial_practicedata_primarystage1.csv"
data_name <- "practice_data.csv"
study_name <- "mock"
###############################################################################
# figure labels and titles for markers
###############################################################################

# define useful constants
assays <- c(
  "bindSpike", "bindRBD", "pseudoneutid50", "pseudoneutid80"
  # NOTE: the live neutralization marker will eventually be available
  #"liveneutmn50"
)
times <- c("B", "Day29", "Day57")
markers <- c(outer(times, assays, "%.%"))

# re-define times variable here as needed here
times <- c(
  "B", "Day29", "Day57", "Delta29overB", "Delta57overB",
  "Delta57over29"
)

# race labeling
labels.race <- c(
  "White", "Black or African American",
  "Asian", "American Indian or Alaska Native",
  "Native Hawaiian or Other Pacific Islander", "Multiracial",
  "Other", "Not reported and unknown"
)

# ethnicity labeling
labels.ethnicity <- c(
  "Hispanic or Latino", "Not Hispanic or Latino",
  "Not reported and unknown"
)

# axis labeling
labels.axis <- outer(
  c("", "", "", "", "", ""),
  c(
    "Spike IgG (IU/ml)", "RBD IgG (IU/ml)", "PsV-nAb ID50",
    #"WT LV-nAb MN50",
    "PsV-nAb ID80"#,
    #"WT LV-nAb MN80"
  ),
  "%.%"
)
labels.axis <- as.data.frame(labels.axis)
rownames(labels.axis) <- times
# NOTE: hacky solution to deal with changes in the number of markers
colnames(labels.axis)[seq_along(assays)] <- assays

# title labeling
labels.title <- outer(
  c(
    "Binding Antibody to Spike", "Binding Antibody to RBD",
    "PsV Neutralization 50% Titer",
    #"WT LV Neutralization 50% Titer",
    "PsV Neutralization 80% Titer" #,
    #"WT LV Neutralization 80% Titer"
  ),
  ": " %.%
    c(
      "Day 1", "Day 29", "Day 57", "D29 fold-rise over D1",
      "D57 fold-rise over D1", "D57 fold-rise over D29"
    ),
  paste0
)
labels.title <- as.data.frame(labels.title)
colnames(labels.title) <- times
# NOTE: hacky solution to deal with changes in the number of markers
rownames(labels.title)[seq_along(assays)] <- assays
labels.title <- as.data.frame(t(labels.title))

# creating short and long labels
labels.assays.short <- labels.axis[1, ]
labels.assays.long <- labels.title

# baseline stratum labeling
Bstratum.labels <- c(
  "Age >= 65",
  "Age < 65, At risk",
  "Age < 65, Not at risk"
)

llods <- c(
  bindSpike = 20,
  bindRBD = 20,
  pseudoneutid50 = 10,
  pseudoneutid80 = 10
)
# live neut to be added
#, liveneutmn50=62)

###############################################################################
# theme options
###############################################################################

# fixed knitr chunk options
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  #cache = TRUE,
  out.width = "80%",
  fig.align = "center",
  fig.width = 6,
  fig.asp = 0.618,
  fig.retina = 0.8,
  fig.show = "hold",
  dpi = 300,
  echo = FALSE,
  message = FALSE,
  warning = FALSE,
  fig.pos = "ht",
  out.extra = ""
)

# global options
options(
  digits = 6,
  #scipen = 999,
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  crayon.enabled = FALSE,
  bookdown.clean_book = TRUE,
  knitr.kable.NA = "NA",
  repos = structure(c(CRAN = "https://cran.rstudio.com/"))
)

# no complaints from installation warnings
Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS="true")

# overwrite options by output type
if (knitr:::is_html_output()) {
  #options(width = 80)

  # automatically create a bib database for R packages
  knitr::write_bib(c(
    .packages(), "bookdown", "knitr", "rmarkdown"
  ), "packages.bib")
}
if (knitr:::is_latex_output()) {
  #knitr::opts_chunk$set(width = 67)
  #options(width = 67)
  options(cli.unicode = TRUE)

  # automatically create a bib database for R packages
  knitr::write_bib(c(
    .packages(), "bookdown", "knitr", "rmarkdown"
  ), "packages.bib")
}

# create and set global ggplot theme
# borrowed from https://github.com/tidymodels/TMwR/blob/master/_common.R
theme_transparent <- function(...) {
  # use black-white theme as base
  ret <- ggplot2::theme_bw(...)

  # modify with transparencies
  trans_rect <- ggplot2::element_rect(fill = "transparent", colour = NA)
  ret$panel.background  <- trans_rect
  ret$plot.background   <- trans_rect
  ret$legend.background <- trans_rect
  ret$legend.key        <- trans_rect

  # always have legend below
  ret$legend.position <- "bottom"
  return(ret)
}

library(ggplot2)
theme_set(theme_transparent())
theme_update(
  text = element_text(size = 25),
  axis.text.x = element_text(colour = "black", size = 30),
  axis.text.y = element_text(colour = "black", size = 30)
)

# custom ggsave function with updated defaults
ggsave_custom <- function(filename = default_name(plot),
                          height= 15, width = 21, ...) {
  ggsave(filename = filename, height = height, width = width, ...)
}

