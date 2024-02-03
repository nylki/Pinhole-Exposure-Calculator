import std/math

# see: https://www.analog.cafe/app/exposure-values-stops-lux-seconds-calculators-definitions#how-to-convert-lux-to-ev
# Also see wikipedia (2024-01-13): https://en.wikipedia.org/wiki/Exposure_value#Relationship_of_EV_to_lighting_conditions
# EV = log2(LS / C)
proc exposureValue*(scene_lux: float, iso: float): float {.noSideEffect.} =
  # incident light meter calibration constant
  let c: float = 250
  return log2(scene_lux * iso / c)

proc exposureTimeFromEV*(ev: float, fstop: float, iso: float): float {.noSideEffect.} =
  return pow(fstop, 2) /  pow(2, ev) / (iso / 100)

proc exposureTimeFromLux*(measured_scene_lux: float, fstop: float, iso: float): float {.noSideEffect.}  =
  ## returns: the ideal exposure time in seconds (s)
  let ev = exposureValue(measured_scene_lux, iso)
  return exposureTimeFromEV(ev, fstop, iso)