#!/usr/bin/env Rscript
# === SIMDISPAT minimal run (snesim) — smoke test (no source modifications) ===
# - Uses your functions exactly as they are in ./R
# - Skips internal plotting by setting nmult = 0
# - Writes a simple output CSV into ./outputs

message("=== SIMDISPAT minimal run (snesim) — smoke test ===")

fail <- function(...) { message(sprintf(...)); quit(status = 1, save = "no") }
ok   <- function(...) { message(sprintf(...)) }

# 1) Load repo functions
if (!dir.exists("R")) fail("[ERR] Please run from the repository root (./R not found).")
r_files <- list.files("R", pattern = "\\.[Rr]$", full.names = TRUE)
if (!length(r_files)) fail("[ERR] No .R files found in ./R.")
for (f in r_files) source(f, chdir = TRUE)
ok("[OK] Loaded %d R files from ./R", length(r_files))

# 2) Basic parameters (your defaults 101x101)
typedata <- 0
typedist <- 0
nsim     <- 1
seed     <- 689558
set.seed(seed)

nx <- 101; ny <- 101; nz <- 1
xmn <- 0; ymn <- 0; zmn <- 0
xsiz <- 1; ysiz <- 1; zsiz <- 1
nxyz <- nx * ny * nz

# 3) Template 19x19x1 centered (uses your coordTemplate/coordTeamplate if present)
coord_fn <- if (exists("coordTemplate")) "coordTemplate" else if (exists("coordTeamplate")) "coordTeamplate" else NA
if (is.na(coord_fn)) fail("[ERR] Neither coordTemplate() nor coordTeamplate() found in ./R.")
nxT <- 19; nyT <- 19; nzT <- 1
inxT <- 9;  inyT <- 9;  inzT <- 1
tres <- do.call(coord_fn, list(nxT, nyT, nzT, inxT, inyT, inzT))
templatefl <- tres$coord
innerPatch <- tres$InnerPatch

# 4) Data and training image. If sampled data is missing, run with nd=0
if (file.exists("./Datos_muestreados/categoric.dat")) {
  data <- as.matrix(read.table("./Datos_muestreados/categoric.dat",
                               comment.char = "%", sep = ",", header = TRUE))
  ok("[OK] Sample data loaded: %d rows", nrow(data))
} else {
  data <- matrix(numeric(0), ncol = 4)
  ok("[WARN] ./Datos_muestreados/categoric.dat not found; running with nd=0.")
}

if (!file.exists("./Images/categorical.dat"))
  fail("[ERR] Missing ./Images/categorical.dat (training image).")
trainfl <- as.matrix(read.table("./Images/categorical.dat", comment.char = "%"))
nxtr <- 101; nytr <- 101; nztr <- 1
nxytr <- nxtr * nytr; nxyztr <- nxytr * nztr
ivrltr <- trainfl

# 5) Search/anisotropy (soft values) — same style as your code
radius <- 10
angles <- c(0, 0, 0)
sanis  <- c(1, 1)  # change if you use another ratio in your script

w1 <- 0.7; w2 <- 0.2; w3 <- 0.1
dbtol <- 1e6
patpercent <- 0.999

# 6) Key for the smoke test: nmult = 0 → avoids SimulationPath internal plotting
nmult <- 0

ok("[INFO] Running snesim() with nmult = 0 (smoke test)…")
res <- snesim(
  data, nx, xmn, xsiz, ny, ymn, ysiz, nz, zmn, zsiz,
  nxyz, trainfl, nxtr, nytr, nztr, ivrltr, nxytr, nxyztr,
  templatefl, innerPatch, nmult, radius, angles, sanis,
  nsim, seed, nxT, nyT, nzT, w1, w2, w3, typedata, typedist, dbtol, patpercent
)
ok("[OK] snesim() finished successfully.")

# 7) Save a minimal output (for reproducibility proof)
dir.create("outputs", showWarnings = FALSE)
ts <- format(Sys.time(), "%Y%m%d_%H%M%S")
outfile <- file.path("outputs", paste0("snesim_smoketest_realizations_", ts, ".csv"))
write.csv(res, outfile, row.names = FALSE)
ok("[DONE] Smoke test finished. File: %s", outfile)
