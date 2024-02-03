import std/math
import std/strformat
import photoMath

const sqrt2: float32 = sqrt(float32(2))
const isoValues: seq[float] = @[100, 200, 400, 800, 1600]

# 1. By not marking iso, sceneLux, fstop with a *, we make these fields private
type ViewModel* = ref object
    iso: float = 100
    ev: float = 1
    fstop: float = sqrt2 # ~1.4


proc newViewModel*(): ViewModel = ViewModel()

# Setters

# 2. However the setters and getters are exposed with a *
# That way the dataflow can be controlled (all changes have to go through the setters)
proc setISO*(model: ViewModel, iso: float) =
  model.iso = iso

proc setEv*(model: ViewModel, ev: float) =
  model.ev = ev

proc setFstop*(model: ViewModel, fstop: float) =
  model.fstop = fstop



# Getters
proc iso*(model: ViewModel): float =
  model.iso

proc ev*(model: ViewModel): float =
  model.ev

proc fstop*(model: ViewModel): float =
  model.fstop

proc exposureTime*(model: ViewModel): float =
  ## exposure time in seconds. calculation is based on iso, EV and f-stop.
  exposureTimeFromEV(model.ev, model.fstop, model.iso)

proc exposureTimeHumanReadable*(model: ViewModel): string =
  let seconds = exposureTimeFromEV(model.ev, model.fstop, model.iso)
  if seconds < 0.01:
    return fmt"{seconds: .4f} seconds"
  if seconds < 0.1:
    return fmt"{seconds: .3f} seconds"
  return case seconds:
    of 0..1: fmt"{seconds: .2f} seconds"
    of 0..60: fmt"{seconds: .1f} seconds"
    of 60..60*60: fmt"{seconds / 60: .1f} minutes"
    of 60*60..24*60*60: fmt"{seconds / 60 / 60: .1f} hours"
    else: fmt"{seconds / 60 / 60 / 24: .1f} days"
