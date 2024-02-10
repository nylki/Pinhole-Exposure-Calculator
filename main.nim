import std/strformat
import owlkettle
import owlkettle/adw
import owlkettle/dataentries
import std/math
import std/sequtils
import std/sugar
import std/options

import viewModel

let sqrt2: float32 = sqrt(float32(2))
let isoValues: seq[float] = @[100, 200, 400, 800, 1600]

const APP_NAME = "Pinhole Calculator"


# https://en.wikipedia.org/wiki/Exposure_value#Tabulated_exposure_values
const exposureValueMarks: seq[ScaleMark] = @[
  ScaleMark(label: some("EV 0"), value: 0, position: ScaleBottom),
  # EV 15 -> "sunny sixteen" amount of light
  # see: https://en.wikipedia.org/wiki/Exposure_value#Relationship_of_EV_to_lighting_conditions
  ScaleMark(label: some("EV 15"), value: 15, position: ScaleBottom)
]

const luxValueMarks: seq[ScaleMark] = @[
  ScaleMark(label: some(""), value: 0, position: ScaleBottom),
  ScaleMark(label: some("1k lux"), value: 1_000, position: ScaleBottom),
  ScaleMark(label: some("100k lux"), value: 100_000, position: ScaleBottom)
]

viewable App:
  model: ViewModel = newViewModel()

method view(app: AppState): Widget =
  result = gui:
    Window:
      title = APP_NAME
      defaultSize = (300, 250)

      Box(orient = OrientY, margin = 12, spacing = 6):
        Box(style = [BoxCard]){.expand: false.}:
          Box(orient = OrientX, margin = 12, spacing = 12){.expand: false.}:
            Label(text = "F-Stop"){.expand: false.}
            NumberEntry():
              value = app.model.fstop
              proc changed(newValue: float) = app.model.setFstop(newValue)
        
        Box(orient = OrientY, style = [BoxCard], spacing = 6){.expand: false.}:
          Box(orient = OrientX, spacing = 6, margin = 12):
            Label(text = "ISO"){.expand: false.}
            SpinButton:
              value = app.model.iso
              digits = 0
              stepIncrement = 100
              max = 9999999
              proc valueChanged(newValue: float) = app.model.setISO(newValue)


        # NOTE: The base unit of operation is EV
        # When selected Lux we convert lux->EV when changing values into the model
        # and EV->Lux when displaying them (i.e. in the NumberEntry)
        Box(orient = OrientY, style = [BoxCard], spacing = 6){.expand: false.}:
          Box(orient = OrientX, spacing = 6, margin = 12):
            DropDown{.expand: false.}:
              # map the enum values to their associated strings via $
              items = app.model.availableLightUnits.map(unit => $unit)
              selected = app.model.selectedLightUnitIndex
              proc select(itemIndex: int) =
                app.model.setSelectedLightUnitIndex(itemIndex)

            case app.model.selectedLightUnit:
              of ev:
                NumberEntry:
                  value = app.model.ev
                  proc changed(newValue: float) = app.model.setEv(newValue)
              of lux:
                NumberEntry:
                  value = app.model.lux
                  proc changed(newValue: float) = app.model.setLux(newValue)

          Scale(margin = Margin(top:0, left: 0, bottom:12, right: 0)):
            showValue = false
            precision = 0
            min = -12
            max = 19
            stepSize = 1
            pageSize = 4
            showFillLevel = true
            marks = exposureValueMarks
            value = app.model.ev
            proc valueChanged(newValue: float) = app.model.setEv(newValue)


        Label():
          margin = 10
          useMarkup = true
          text = fmt"<span font='18'>{app.model.exposureTimeHumanReadable}</span>"
          tooltip = fmt"{app.model.exposureTime} seconds"
  
              

adw.brew(gui(App()))