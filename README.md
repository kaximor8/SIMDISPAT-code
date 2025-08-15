# SIMDISPAT (R) — Multiple-Point Simulation 

Geostatistical simulation code accompanying a submission to *Computers & Geosciences*.

This repository provides an **R implementation** of a Multiple-Point Simulation (MPS) approach focused on **pattern similarity** and **distance**.  
Although the main function retains the name `snesim`, it has been **heavily modified** compared to classical implementations. The name was kept for historical reasons, but its internal logic reflects the innovations introduced in SIMDISPAT.

One of the key innovations in SIMDISPAT is the introduction of the **`patpercent`** argument, which allows selecting a percentage of patterns from the training image (TI) via simple random sampling without replacement. For example, in a two-dimensional 5×5 template and `patpercent = 33%`, if the TI contains 49 total patterns, only 16 will be randomly selected for simulation.

> Core functions (R): `snesim`, `PatterBase`, `scanTemplate`, `AssignData`, `getDataEvent`, `AssignWeight`, `similarPattern`, `disDistance`, `pastePattern`, `coordTemplate`, `RelocateData`, `getindx`, `SortTemplate`, `setRotMat`, `InitializeSearch`, `updateTree`, `SimulationPath`.

## Why this repository?
To comply with the journal’s “Computer Code Availability” requirements:
1. **Public repository** (GitHub or Bitbucket).
2. A clear **README** with why/how to use the code.
3. A **quick-test** to verify the environment.
4. **Simple instructions** to launch the test.

## Repository layout
```
.
├─ R/                         # Your .R source files (place them here)
├─ quick_test/
│  ├─ data/
│  │  └─ categorical_11x11.dat   # Tiny 11×11 example training image
│  └─ quick_test.R               # Loads R files and checks the tiny dataset
└─ README.md
```

## Requirements
- R ≥ 4.1
- Suggested: `ggplot2` (for optional plotting in `SimulationPath.R`)
- OS: Windows, macOS, or Linux

Install suggested packages (once):
```r
install.packages("ggplot2") Everything else (file reading, matrix handling, calculations, loops) is implemented using R base functions (read.table, matrix, for, ifelse, etc.), without relying on external libraries for the core logic.
```

---

# Quick test (recommended first run)
Verifies that the R files load and the tiny dataset reads correctly.

**Option A — RStudio**
1. Open the project at the repository root.
2. In the Console:
   ```r
   source("quick_test/quick_test.R")
   ```

**Option B — Terminal**
```bash
Rscript quick_test/quick_test.R
```

Expected output (example):
```
=== SIMDISPAT quick test (R) ===
[OK] Loaded N R files.
[OK] Tiny dataset: 11 x 11
 - snesim FOUND 
 - PatterBase FOUND 
 - ...
[OK] Quick test finished.
```

---

# Run your own simulation (minimal, using `snesim`)
Below is a minimal sketch to generate one realization after sourcing all R files.
Adjust dimensions and file paths to your data.

```r
# After sourcing all R files (as done in quick_test.R)
set.seed(689558)

# Types and controls
typedata <- 0     # 0=categorical, 1=continuous
typedist <- 0     # 0=Manhattan, 1=Euclidean, 2=Cosine
nsim     <- 1

# Simulation grid (target)
nx <- ny <- 101; nz <- 1
xmn <- ymn <- 0; zmn <- 0
xsiz <- ysiz <- 1; zsiz <- 1
nxyz <- nx * ny * nz

# Training image (example uses tiny data to illustrate paths)
trainfl <- as.matrix(read.table("quick_test/data/categorical_11x11.dat"))
nxtr <- nytr <- 11; nztr <- 1
nxytr <- nxtr * nytr; nxyztr <- nxytr * nztr
ivrltr <- trainfl

# Template (example 19x19x1 with inner 9x9x1; must be odd sizes)
source("R/coordTemplate.R")
res <- coordTemplate(19,19,1, 9,9,1)
templatefl <- res$coord
innerPatch <- res$InnerPatch

# Weights & search
w1 <- 0.5; w2 <- 0.3; w3 <- 0.2   # adjust to your validation
dbtol <- 1000
patpercent <- 0.5
nmult <- 2

# --- Call snesim() ---
# NOTE: Some legacy internals expect a 'trainim' symbol; if needed:
trainim <- trainfl

rea <- snesim(
  data = NULL,                 # conditioning data if available; otherwise NULL
  nx = nx, xmn = xmn, xsiz = xsiz,
  ny = ny, ymn = ymn, ysiz = ysiz,
  nz = nz, zmn = zmn, zsiz = zsiz,
  nxyz = nxyz,
  trainfl = trainfl, nxtr = nxtr, nytr = nytr, nztr = nztr,
  ivrltr = ivrltr, nxytr = nxytr, nxyztr = nxyztr,
  templatefl = templatefl, innerPatch = innerPatch, nmult = nmult,
  nsim = nsim, seed = 689558,
  nxT = 19, nyT = 19, nzT = 1,
  w1 = w1, w2 = w2, w3 = w3,
  typedata = typedata, typedist = typedist,
  dbtol = dbtol, patpercent = patpercent
)

# Save result
write.csv(rea, file = "sim_result.csv", row.names = FALSE)
```

> **Notes**
> - Keep template sizes **odd** (e.g., 19×19×1; inner 9×9×1) to ensure a center node.
> - For **continuous** variables set `typedata <- 1` and choose an appropriate `typedist` (e.g., 1 Euclidean).
> - Replace the tiny `categorical_11x11.dat` with your real training image and update `nxtr, nytr, nztr` accordingly.
> - If your `snesim()` signature differs slightly (older branches), keep or adapt a `simdispat()` wrapper that maps names and filters unused args.

---

# Conditioning data (optional)
If you have hard data (e.g., wells, sample points), pass it in `data=` using the structure expected by your `snesim()` version (coordinates + values). Keep coordinate indices consistent with the grid origin and cell size.

---

# Reproducibility
- Use `set.seed(...)` before each run.
- Document template sizes (`nxT,nyT,nzT`) and weights (`w1,w2,w3`).
- Include the TI path and dimensions in your notes.

---

# Common pitfalls
- **Template not odd** → no center node. Use odd sizes.
- **Mismatched dimensions** between TI matrix and `nxtr,nytr,nztr` → index errors.
- **Different parameter names** across code versions → keep the wrapper or adapt names.
- **Windows paths**: prefer forward slashes `/` in R.

---

## License
This repository uses the **MIT License** (see `LICENSE`).

## How to cite
If you use this code, please cite the associated manuscript and this repository:
```
SIMDISPAT (R implementation via snesim). 
GitHub repository: https://github.com/kaximor8/SIMDISPAT-code
```
