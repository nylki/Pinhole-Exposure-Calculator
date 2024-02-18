import std/math

# see: https://www.analog.cafe/app/exposure-values-stops-lux-seconds-calculators-definitions#how-to-convert-lux-to-ev
# Also see wikipedia (2024-01-13): https://en.wikipedia.org/wiki/Exposure_value#Relationship_of_EV_to_lighting_conditions
# EV = log2(LS / C)
proc exposureValue*(scene_lux: float, iso: float): float {.noSideEffect.} =
  # incident light meter calibration constant
  let c: float = 250
  return log2(scene_lux * iso / c)

proc sceneLux*(ev: float, iso: float): float {.noSideEffect.} =
  let c: float = 250
  return (pow(2,ev) * c) / iso

proc exposureTimeFromEV*(ev: float, fstop: float, iso: float): float {.noSideEffect.} =
  return pow(fstop, 2) /  pow(2, ev) / (iso / 100)

proc exposureTimeFromLux*(measured_scene_lux: float, fstop: float, iso: float): float {.noSideEffect.}  =
  ## returns: the ideal exposure time in seconds (s)
  let ev = exposureValue(measured_scene_lux, iso)
  return exposureTimeFromEV(ev, fstop, iso)



proc exposureValueDescriptionOutdoor*(ev: float): string =
  # according to: https://en.wikipedia.org/wiki/Exposure_value#cite_note-5
  # TODO: read and check values: ANSI PH2.7-1986. American National Standard for Photography — Photographic Exposure Guide. New York: American National Standards Institute.
  return case ev:
    of -99 .. -9: "dark night sky / no moon light"
    of -9 .. -7: "night / some moon light "
    of -7 .. -5: "night / quarter moon light"
    of -5 .. -3: "night / gibbous moon light"
    of -3 .. -2: "night  / full moon light"
    of -2 .. 3: "night / Distant views of lighted buildings"
    of 3 .. 5: "night / Floodlit buildings, monuments, and fountains"
    of 5 .. 6: "night / vehicle traffic"
    of 6 .. 7: "night / street scenes, windows lights, fairs and amusement parks"
    of 7 .. 8: "night / bright street scenes"
    of 8 .. 9: "night:  sports, fires and buildings burning"
    of 9 .. 10: "night: neon signs, early sunset"
    of 10 .. 12: "around sunset"
    of 12 .. 13: "Areas in open shade, clear sunlight / Typical scene, heavy overcast"
    of 13 .. 14: "Typical scene, cloudy bright (no shadows)"
    of 14 .. 15: "Typical scene in hazy sunlight (soft shadows)"
    of 15 .. 16: "Typical scene in full or slightly hazy sunlight (distinct shadows)"
    of 16 .. 17: "Light sand or snow in full or slightly hazy sunlight (distinct shadows)"
    else: "sun explosion?"


