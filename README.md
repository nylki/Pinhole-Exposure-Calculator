# Pinhole Calculator

An exposure time calculator for (pinhole) cameras written in [nim](https://nim-lang.org/) using the declarative adwaita UI framework [owlkettle](https://can-lehmann.github.io/owlkettle/README.html).

![PinholeCalculator  Bildschirmfoto vom 2024-05-31 14-29-53](https://github.com/nylki/PinholeCalculator/assets/1710598/f5c38225-875c-47d3-9a56-cbaeeabce49e)


## Installation

First install `nim` and its package manager `nimble`:

```.sh
dnf install nim nimble
```

or:

```.sh
apt install nim nimble
```

-------------------------

Then install `owlkettle` via nimble:

```.sh
nimble install owlkettle
```

-------------------------

Once that is done, you build the app by running `build.sh`. You'll find the binary in the build directory.
