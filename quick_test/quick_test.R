#!/usr/bin/env Rscript
cat("=== SIMDISPAT quick test (R) ===\n")

# --- Detect repository root (works in Rscript and interactive/RStudio) ---
this_script <- tryCatch(
  normalizePath(sys.frames()[[1]]$ofile, mustWork = FALSE),
  error = function(e) NA
)

if (is.na(this_script)) {
  # Interactive mode: assume current working directory is the repo root
  repo_root <- normalizePath(getwd(), mustWork = TRUE)
} else {
  # Script mode: the file lives in quick_test/, so go up one level
  repo_root <- normalizePath(file.path(dirname(this_script), ".."), mustWork = TRUE)
}
setwd(repo_root)
cat(sprintf("[OK] Working dir: %s\n", repo_root))

# --- Load all R source files from ./R (if present) ---
if (!dir.exists("R")) stop("[ERR] Missing ./R directory with source functions.")
r_files <- list.files("R", pattern = "\\.[Rr]$", full.names = TRUE)
if (!length(r_files)) stop("[ERR] No .R files found in ./R")
for (f in r_files) source(f, chdir = TRUE)
cat(sprintf("[OK] Loaded %d R files.\n", length(r_files)))

# --- Load tiny dataset (11x11) for a smoke check ---
dat_path <- file.path("quick_test", "data", "categorical_11x11.dat")
if (!file.exists(dat_path)) {
  stop("[ERR] Missing dataset: quick_test/data/categorical_11x11.dat")
}
grid <- as.matrix(read.table(dat_path))
cat(sprintf("[OK] Tiny dataset size: %d x %d\n", nrow(grid), ncol(grid)))

# --- Sanity check: required functions must exist ---
required_funcs <- c(
  "snesim", "PatterBase", "scanTemplate", "AssignData", "getDataEvent",
  "AssignWeight", "similarPattern", "disDistance", "pastePattern", "SimulationPath"
)
missing <- required_funcs[!vapply(required_funcs, function(fn) exists(fn, mode = "function"), logical(1))]
if (length(missing)) {
  cat("[ERR] Missing functions:\n")
  cat(paste(" -", missing), sep = "\n")
  stop("[ERR] One or more required functions were not found in ./R")
} else {
  cat("[OK] All core functions are available.\n")
}

# --- Optional: run a very small template build to ensure helpers are callable ---
coord_fn <- if (exists("coordTemplate")) "coordTemplate" else if (exists("coordTeamplate")) "coordTeamplate" else NA
if (is.na(coord_fn)) {
  cat("[WARN] coordTemplate()/coordTeamplate() not found. Skipping template check.\n")
} else {
  tr <- do.call(coord_fn, list(3, 3, 1, 1, 1, 1))
  if (!all(c("coord","InnerPatch") %in% names(tr))) {
    stop("[ERR] Template function did not return expected components (coord, InnerPatch).")
  } else {
    cat("[OK] Template function returned expected components.\n")
  }
}

cat("[OK] Quick test completed successfully.\n")

source("quick_test/quick_test.R")
source("run_minimal_example.R")


