import owlkettle
import ../model/view_model
import owlkettle/[adw]
import std/strformat

const APP_NAME = "Pinhole Calculator"

viewable AppHeaderBar:
  model: ViewModel

method view(view: AppHeaderBarState): Widget =
  result = gui:
    HeaderBar:
        WindowTitle {.addTitle.}:
          title = APP_NAME
        # TODO/FIXME: support in owlkettle for primary menuButton
        MenuButton {.addRight.}:
          icon = "open-menu"
          style = [ButtonFlat]
          Popover:
            Box(orient = OrientY, margin = 4, spacing = 3):
              # FIXME: when using a regular button the popover stays after click
              ModelButton:
                style = [ButtonFlat]
                text = "About Pinhole Calculator"
                proc clicked() =
                  discard view.open: gui:
                    AboutDialog:
                      programName = "Pinhole Calculator"
                      logo = "applications-graphics"
                      version = fmt"libadwaita version {AdwVersion}"
                      credits = @{
                        "Code": @[
                          "Tom Brewe"
                        ],
                        "Art": @[
                          "Tom Brewe"
                        ]
                      }

export AppHeaderBar