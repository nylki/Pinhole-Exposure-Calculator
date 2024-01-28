import std/strformat
import owlkettle
import owlkettle/adw
import owlkettle/dataentries
import std/math
import std/sequtils
import std/sugar
import viewModel

let sqrt2: float32 = sqrt(float32(2))
let isoValues: seq[float] = @[100, 200, 400, 800, 1600]

const APP_NAME = "Pinhole Calculator"

viewable App:
  model: ViewModel = newViewModel()

method view(app: AppState): Widget =
  result = gui:
    Window:
      title = APP_NAME
      defaultSize = (300, 250)

      Box(orient = OrientY):
        Box(orient = OrientX, spacing = 6, margin = 12){.expand: false.}:
          Label(text = "ISO"){.expand: false.}
          SpinButton:
            value = app.model.iso
            digits = 0
            stepIncrement = 100
            max = 9999999
            proc valueChanged(value: float) = app.model.setISO(value)

        Box(orient = OrientX, spacing = 6, margin = 12){.expand: false.}:
          Label(text = "F-Stop"){.expand: false.}
          NumberEntry:
            value = app.model.fstop
            proc changed(value: float) = app.model.setFstop(value)
        
        Box(orient = OrientX, spacing = 6, margin = 12){.expand: false.}:
          Label(text = "Lux (scene illuminance)"){.expand: false.}
          NumberEntry:
            value = app.model.sceneLux
            proc changed(value: float) = app.model.setSceneLux(value)
        
        Label():
          margin = 10
          useMarkup = true
          text = fmt"<span font='18'>{app.model.exposureTimeHumanReadable}</span>"
          tooltip = fmt"{app.model.exposureTime} seconds"
  
              

adw.brew(gui(App()))