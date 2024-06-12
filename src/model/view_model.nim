import std/math
import std/strformat
import ../photoMath

const sqrt2: float32 = sqrt(float32(2))
const isoValues: seq[float] = @[100, 200, 400, 800, 1600]

type
  LightUnit* = enum
    ev = "EV"
    lux = "Lux"

type ReciprocityCorrectionState* = enum
  disabled
  enabledExpandedRow
  enabledCollapsedRow

proc isEnabled*(state: ReciprocityCorrectionState): bool =
  case state:
    of enabledCollapsedRow, enabledExpandedRow: true
    else: false

proc isExpanded*(state: ReciprocityCorrectionState): bool =
  case state:
    of enabledExpandedRow: true
    of disabled, enabledCollapsedRow: false

# 1. By not marking iso, sceneLux, fstop with a *, we make these fields private
type ViewModel* = ref object
    iso: float = 100
    ev: float = 0
    fstop: float = 256
    selectedLightUnitIndex: int
    reciprocityCorrectionFactor: float = 1
    applyReciprocityCorrection: ReciprocityCorrectionState


proc newViewModel*(): ViewModel = ViewModel()

# Setters
# ------------------------------------------------------

# 2. However the setters and getters are exposed with a *
# That way the dataflow can be controlled (all changes have to go through the setters)
proc setISO*(model: ViewModel, iso: float) =
  model.iso = iso

proc setEv*(model: ViewModel, ev: float) =
  model.ev = ev

proc setLux*(model: ViewModel, lux: float) =
  model.ev = exposureValue(lux, model.iso)

proc setFstop*(model: ViewModel, fstop: float) =
  model.fstop = fstop

proc setSelectedLightUnitIndex*(model: ViewModel, index: int) =
  model.selectedLightUnitIndex = index

proc setReciprocityCorrectionFactor*(model: ViewModel, factor: float) =
  model.reciprocityCorrectionFactor = factor

proc setApplyReciprocityCorrection*(model: ViewModel, value: ReciprocityCorrectionState) =
  model.applyReciprocityCorrection = value


# Getters
# ------------------------------------------------------

proc iso*(model: ViewModel): float =
  model.iso

proc ev*(model: ViewModel): float =
  model.ev

proc lux*(model: ViewModel): float =
  sceneLux(model.ev, model.iso)

proc fstop*(model: ViewModel): float =
  model.fstop

proc availableLightUnits*(model: ViewModel): seq[LightUnit] =
  @[LightUnit.ev, LightUnit.lux]

proc selectedLightUnitIndex*(model: ViewModel): int =
  model.selectedLightUnitIndex

proc selectedLightUnit*(model: ViewModel): LightUnit =
  model.availableLightUnits[model.selectedLightUnitIndex]

proc exposureTime*(model: ViewModel): float =
  ## exposure time in seconds. calculation is based on iso, EV and f-stop.
  exposureTimeFromEV(model.ev, model.fstop, model.iso)

proc exposureTimeHumanReadable*(model: ViewModel): string =
  var seconds = exposureTimeFromEV(model.ev, model.fstop, model.iso)
  if isEnabled(model.applyReciprocityCorrection):
    seconds = pow(seconds, model.reciprocityCorrectionFactor)
    
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

proc exposureValueDescriptionOutdoor*(model: ViewModel): string =
  exposureValueDescriptionOutdoor(model.ev)

proc reciprocityCorrectionFactor*(model: ViewModel): float =
  model.reciprocityCorrectionFactor

proc reciprocityCorrectionState*(model: ViewModel): ReciprocityCorrectionState =
  model.applyReciprocityCorrection

proc isReciprocityCorrectionEnabled*(model: ViewModel): bool =
  isEnabled(model.applyReciprocityCorrection)

proc isReciprocityCorrectionSettingsExpanded*(model: ViewModel): bool =
  isExpanded(model.applyReciprocityCorrection)