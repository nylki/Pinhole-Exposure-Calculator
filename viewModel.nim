import std/math
import std/strformat
import photomath

const sqrt2: float32 = sqrt(float32(2))
const isoValues: seq[float] = @[100, 200, 400, 800, 1600]

# 1. By not marking iso, sceneLux, fstop with a *, we make these fields private
type ViewModel* = ref object
    iso: float = 100
    sceneLux: float = 1
    fstop: float = sqrt2 # ~1.4


proc newViewModel*(): ViewModel = ViewModel()

# Setters

# 2. However the setters and getters are exposed with a *
# That way the dataflow can be controlled (all changes have to go through the setters)
proc setISO*(model: ViewModel, iso: float) =
  model.iso = iso

proc setSceneLux*(model: ViewModel, sceneLux: float) =
  model.sceneLux = sceneLux

proc setFstop*(model: ViewModel, fstop: float) =
  model.fstop = fstop



# Getters
proc iso*(model: ViewModel): float =
  model.iso

proc sceneLux*(model: ViewModel): float =
  model.sceneLux

proc fstop*(model: ViewModel): float =
  model.fstop

proc exposureTime*(model: ViewModel): float =
  ## exposure time in seconds. calculation is based on iso, sceneLux and f-stop.
  exposureTime(model.fstop, model.sceneLux, model.iso)

proc exposureTimeHumanReadable*(model: ViewModel): string =
  let seconds = exposureTime(model.fstop, model.sceneLux, model.iso)
  case seconds:
    of 0..60: fmt"{seconds: .2f} seconds"
    of 60..60*60: fmt"{seconds / 60: .1f} minutes"
    of 60*60..24*60*60: fmt"{seconds / 60 / 60: .1f} hours"
    else: fmt"{seconds / 60 / 60 / 24: .1f} days"
