# Pinhole Exposure Calculator

An exposure time calculator for (pinhole) cameras written in [nim](https://nim-lang.org/) using the declarative adwaita UI framework [owlkettle](https://can-lehmann.github.io/owlkettle/README.html).

![PinholeExposureCalculator Bildschirmfoto vom 2024-05-31 15-14-30](https://github.com/nylki/Pinhole-Exposure-Calculator/assets/1710598/933d8f92-73fc-48fc-a010-d1153a10010f)


## Installation

First you need `nim`, its package manager `nimble` as well as the `gtk` and `adwaita` dependencies:

```.sh
dnf install nim nimble gtk4-devel libadwaita-devel
```

or:

```.sh
apt install nim nimble libgtk-4-dev libadwaita-1-dev
```

-------------------------

Then install `owlkettle` via nimble ([more details in the owlkettle repo](https://can-lehmann.github.io/owlkettle/docs/installation.html)):

```.sh
nimble install owlkettle@#head
```

-------------------------

Once that is done, you build the app by running `build.sh`. You'll find the binary in the build directory.
