import QtQuick
import QtQuick.Particles
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
  id: root

  property var shell: null
  readonly property string home: Quickshell.env("HOME")
  readonly property string backgroundLink: home + "/.local/state/omarchy/current/background"
  readonly property string themeNameFile: home + "/.local/state/omarchy/current/theme.name"
  property string currentBackground: ""
  property string currentTheme: ""

  readonly property string backgroundName: {
    var parts = currentBackground.split("/")
    return parts.length > 0 ? parts[parts.length - 1].toLowerCase() : ""
  }

  readonly property bool active: currentTheme === "flower-fruit-mountain"
    || currentBackground.indexOf("flower-fruit-mountain") !== -1

  readonly property string sceneKey: {
    if (backgroundName.indexOf("2-dawn-ridges") !== -1) return "dawn-ridges"
    if (backgroundName.indexOf("3-peach-grove") !== -1) return "peach-grove"
    if (backgroundName.indexOf("4-golden-staff") !== -1) return "golden-staff"
    if (backgroundName.indexOf("5-golden-circlet") !== -1) return "golden-circlet"
    if (backgroundName.indexOf("1-flower-fruit-mountain") !== -1
        || backgroundName.indexOf("flower-fruit-mountain") !== -1) return "mountain"
    return "ambient"
  }

  // Per-background visual and particle profiles in the 1600x900 wallpaper space.
  readonly property bool waterfallVisible: sceneKey === "mountain"
  readonly property bool glowVisible: sceneKey !== "ambient"
  readonly property bool staffCrownVisible: sceneKey === "golden-staff"

  readonly property real glowX: sceneKey === "dawn-ridges" ? 1135
    : sceneKey === "peach-grove" ? 1150
    : sceneKey === "golden-staff" ? 1110
    : 800
  readonly property real glowY: sceneKey === "dawn-ridges" ? 450
    : sceneKey === "peach-grove" ? 315
    : sceneKey === "golden-staff" ? 390
    : sceneKey === "golden-circlet" ? 290
    : 450
  readonly property real glowRotation: sceneKey === "golden-circlet" ? 11 : 0

  readonly property real glowOuterW: sceneKey === "dawn-ridges" ? 460
    : sceneKey === "peach-grove" ? 520
    : sceneKey === "golden-staff" ? 420
    : sceneKey === "golden-circlet" ? 440
    : 440
  readonly property real glowOuterH: sceneKey === "dawn-ridges" ? 380
    : sceneKey === "peach-grove" ? 240
    : sceneKey === "golden-staff" ? 320
    : sceneKey === "golden-circlet" ? 210
    : 320
  readonly property real glowMidW: sceneKey === "dawn-ridges" ? 300
    : sceneKey === "peach-grove" ? 340
    : sceneKey === "golden-staff" ? 270
    : sceneKey === "golden-circlet" ? 290
    : 280
  readonly property real glowMidH: sceneKey === "dawn-ridges" ? 250
    : sceneKey === "peach-grove" ? 160
    : sceneKey === "golden-staff" ? 210
    : sceneKey === "golden-circlet" ? 135
    : 200
  readonly property real glowInnerW: sceneKey === "dawn-ridges" ? 160
    : sceneKey === "peach-grove" ? 170
    : sceneKey === "golden-staff" ? 130
    : sceneKey === "golden-circlet" ? 160
    : 130
  readonly property real glowInnerH: sceneKey === "dawn-ridges" ? 140
    : sceneKey === "peach-grove" ? 85
    : sceneKey === "golden-staff" ? 105
    : sceneKey === "golden-circlet" ? 75
    : 94

  readonly property color glowOuterColor: sceneKey === "golden-staff" ? "#22e07a5f"
    : sceneKey === "dawn-ridges" ? "#22f5a524"
    : sceneKey === "peach-grove" ? "#20f5a524"
    : sceneKey === "golden-circlet" ? "#1ef5a524"
    : "#28f5a524"
  readonly property color glowMidColor: sceneKey === "golden-staff" ? "#34f5a524"
    : sceneKey === "dawn-ridges" ? "#34f8d28a"
    : sceneKey === "peach-grove" ? "#32f8d28a"
    : sceneKey === "golden-circlet" ? "#30f8d28a"
    : "#40f8d28a"
  readonly property color glowInnerColor: sceneKey === "dawn-ridges" ? "#44ffe2a8"
    : sceneKey === "peach-grove" ? "#42ffe2a8"
    : sceneKey === "golden-staff" ? "#44f8d28a"
    : sceneKey === "golden-circlet" ? "#3effe2a8"
    : "#58f8d28a"

  readonly property int glowHalfPeriodMs: sceneKey === "golden-circlet" ? 3500
    : sceneKey === "peach-grove" ? 3250
    : sceneKey === "dawn-ridges" ? 3000
    : sceneKey === "golden-staff" ? 2800
    : 2500

  readonly property real petalAlpha: sceneKey === "dawn-ridges" ? 0.90
    : sceneKey === "peach-grove" ? 0.86
    : sceneKey === "golden-staff" ? 0.85
    : sceneKey === "golden-circlet" ? 0.76
    : sceneKey === "ambient" ? 0.84
    : 0.88
  readonly property color petalColor: sceneKey === "dawn-ridges" ? "#fff0e6"
    : sceneKey === "peach-grove" ? "#ffd8c4"
    : sceneKey === "golden-staff" ? "#ffe0c8"
    : sceneKey === "golden-circlet" ? "#ffe8d0"
    : "#ffffff"
  readonly property real petalGravity: sceneKey === "golden-circlet" ? 4
    : sceneKey === "peach-grove" ? 8
    : sceneKey === "mountain" ? 10
    : 9
  readonly property real windScale: sceneKey === "golden-circlet" ? 0.55
    : sceneKey === "peach-grove" ? 0.80
    : sceneKey === "ambient" ? 0.90
    : sceneKey === "dawn-ridges" ? 1.05
    : sceneKey === "golden-staff" ? 1.15
    : 1.0

  readonly property real topEmitBase: sceneKey === "peach-grove" ? 1.2
    : sceneKey === "golden-circlet" ? 2.0
    : sceneKey === "golden-staff" ? 2.6
    : sceneKey === "ambient" ? 2.8
    : sceneKey === "dawn-ridges" ? 3.0
    : 3.2
  readonly property int topLifeSpan: sceneKey === "golden-circlet" ? 22000 : 17000
  readonly property real topPetalSize: sceneKey === "golden-circlet" ? 14 : 16

  // Shared breeze across screens. Heading is Qt particle degrees (0 = right, 90 = down).
  property real windHeading: 18
  property real windSpeed: 16
  property real windGust: 0
  readonly property real windForce: (windSpeed + windGust * 64) * windScale
  readonly property real windSwirl: (70 + windGust * 140) * windScale

  function wrapHeading(value) {
    var h = value
    while (h < -30) h += 360
    while (h > 330) h -= 360
    if (h > 50 && h < 130)
      h = Math.random() < 0.5 ? 20 : 160
    return h
  }

  function rollWind() {
    var flip = Math.random() < 0.22
    var fromLeft = windHeading > 90
    var nextHeading
    if (flip)
      nextHeading = fromLeft ? (Math.random() * 48 - 8) : (150 + Math.random() * 48)
    else
      nextHeading = wrapHeading(windHeading + (Math.random() * 56 - 28))

    headingAnim.stop()
    headingAnim.to = nextHeading
    headingAnim.duration = 1600 + Math.floor(Math.random() * 2400)
    headingAnim.start()

    speedAnim.stop()
    speedAnim.to = 7 + Math.random() * 24
    speedAnim.duration = 1400 + Math.floor(Math.random() * 1800)
    speedAnim.start()

    if (Math.random() < 0.48) {
      gustAnim.stop()
      gustPeak.to = 0.45 + Math.random() * 0.55
      gustPeak.duration = 260 + Math.floor(Math.random() * 420)
      gustHold.duration = 400 + Math.floor(Math.random() * 1600)
      gustFade.duration = 900 + Math.floor(Math.random() * 1500)
      gustAnim.start()
    }

    windTimer.interval = 2400 + Math.floor(Math.random() * 7800)
  }

  NumberAnimation {
    id: headingAnim
    target: root
    property: "windHeading"
    easing.type: Easing.InOutSine
  }

  NumberAnimation {
    id: speedAnim
    target: root
    property: "windSpeed"
    easing.type: Easing.InOutSine
  }

  SequentialAnimation {
    id: gustAnim
    NumberAnimation {
      id: gustPeak
      target: root
      property: "windGust"
      easing.type: Easing.OutQuad
    }
    PauseAnimation { id: gustHold }
    NumberAnimation {
      id: gustFade
      target: root
      property: "windGust"
      to: 0
      easing.type: Easing.InOutSine
    }
  }

  Timer {
    id: windTimer
    interval: 3500
    running: root.active
    repeat: true
    onTriggered: root.rollWind()
  }

  function refreshBackground() {
    if (!readlinkProc.running)
      readlinkProc.running = true
  }

  Process {
    id: readlinkProc
    command: [
      "sh",
      "-c",
      "printf '%s\\n%s\\n' \"$(readlink -f \"$1\" 2>/dev/null)\" \"$(cat \"$2\" 2>/dev/null)\"",
      "_",
      root.backgroundLink,
      root.themeNameFile
    ]
    stdout: StdioCollector {
      onStreamFinished: {
        var lines = String(text || "").split("\n")
        root.currentBackground = String(lines[0] || "").trim()
        root.currentTheme = String(lines[1] || "").trim().toLowerCase()
      }
    }
  }

  Timer {
    interval: 900
    running: true
    repeat: true
    onTriggered: root.refreshBackground()
  }

  Component.onCompleted: {
    root.refreshBackground()
    root.rollWind()
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData

      screen: modelData
      visible: root.active
      color: "transparent"
      anchors { top: true; bottom: true; left: true; right: true }
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "flower-fruit-mountain-live"
      WlrLayershell.layer: WlrLayer.Bottom
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      mask: Region {}
      updatesEnabled: true

      // Map the 1600x900 viewBox through the same PreserveAspectCrop the wallpaper uses.
      Item {
        id: scene
        readonly property real viewW: 1600
        readonly property real viewH: 900
        readonly property real s: Math.max(panel.width / viewW, panel.height / viewH)
        width: viewW
        height: viewH
        x: (panel.width - viewW * s) / 2
        y: (panel.height - viewH * s) / 2
        transform: Scale { xScale: scene.s; yScale: scene.s }
        visible: root.active

        // --- Primary scene-matched ambient glow (summit / dawn sun / ridge gap / circlet) ---
        Item {
          id: sceneGlow
          visible: root.glowVisible
          x: root.glowX
          y: root.glowY
          width: 1
          height: 1
          rotation: root.glowRotation
          scale: 0.92
          opacity: 0.7

          Repeater {
            model: 3
            Item {
              required property int index
              readonly property real rw: index === 0 ? root.glowOuterW : index === 1 ? root.glowMidW : root.glowInnerW
              readonly property real rh: index === 0 ? root.glowOuterH : index === 1 ? root.glowMidH : root.glowInnerH
              width: rw
              height: rh
              anchors.centerIn: parent

              Rectangle {
                width: parent.rw
                height: parent.rw
                radius: parent.rw / 2
                anchors.centerIn: parent
                color: index === 0 ? root.glowOuterColor : index === 1 ? root.glowMidColor : root.glowInnerColor
                transform: Scale {
                  origin.x: parent.rw / 2
                  origin.y: parent.rw / 2
                  yScale: parent.rh / parent.rw
                }
              }
            }
          }

          SequentialAnimation on opacity {
            running: root.active && root.glowVisible
            loops: Animation.Infinite
            NumberAnimation { to: 1.0; duration: root.glowHalfPeriodMs; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.55; duration: root.glowHalfPeriodMs; easing.type: Easing.InOutSine }
          }
          SequentialAnimation on scale {
            running: root.active && root.glowVisible
            loops: Animation.Infinite
            NumberAnimation { to: 1.08; duration: root.glowHalfPeriodMs; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.92; duration: root.glowHalfPeriodMs; easing.type: Easing.InOutSine }
          }
        }

        // --- Secondary subtle shimmer at the Golden Staff crown (background 4) ---
        Item {
          id: staffCrownGlow
          visible: root.staffCrownVisible
          x: 800
          y: 165
          width: 1
          height: 1
          scale: 0.94
          opacity: 0.6

          Repeater {
            model: 2
            Item {
              required property int index
              readonly property real rw: index === 0 ? 220 : 130
              readonly property real rh: index === 0 ? 120 : 72
              width: rw
              height: rh
              anchors.centerIn: parent

              Rectangle {
                width: parent.rw
                height: parent.rw
                radius: parent.rw / 2
                anchors.centerIn: parent
                color: index === 0 ? "#1af5a524" : "#2cf8d28a"
                transform: Scale {
                  origin.x: parent.rw / 2
                  origin.y: parent.rw / 2
                  yScale: parent.rh / parent.rw
                }
              }
            }
          }

          SequentialAnimation on opacity {
            running: root.active && root.staffCrownVisible
            loops: Animation.Infinite
            NumberAnimation { to: 0.95; duration: 3200; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.45; duration: 3200; easing.type: Easing.InOutSine }
          }
          SequentialAnimation on scale {
            running: root.active && root.staffCrownVisible
            loops: Animation.Infinite
            NumberAnimation { to: 1.06; duration: 3200; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.94; duration: 3200; easing.type: Easing.InOutSine }
          }
        }

        // Waterfall sits in a cleft on the dark right face of background 1 and
        // dies in the cloud sea — never shown on other wallpapers.
        Item {
          id: fall
          visible: root.waterfallVisible
          z: 2
          anchors.fill: parent

          Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
              strokeWidth: -1
              fillGradient: LinearGradient {
                x1: 990; y1: 572
                x2: 1020; y2: 742
                GradientStop { position: 0.00; color: "#6ae8e3d8" }
                GradientStop { position: 0.08; color: "#48e8e3d8" }
                GradientStop { position: 0.38; color: "#2ce8e3d8" }
                GradientStop { position: 0.70; color: "#16e8e3d8" }
                GradientStop { position: 1.00; color: "#00e8e3d8" }
              }
              startX: 976; startY: 576
              PathCubic { x: 1006; y: 578; control1X: 984; control1Y: 572; control2X: 996; control2Y: 573 }
              PathCubic { x: 1036; y: 738; control1X: 1020; control1Y: 640; control2X: 1032; control2Y: 700 }
              PathCubic { x: 988; y: 736; control1X: 1020; control1Y: 750; control2X: 1002; control2Y: 750 }
              PathCubic { x: 976; y: 576; control1X: 980; control1Y: 690; control2X: 978; control2Y: 630 }
            }
          }

          Repeater {
            model: 5
            Rectangle {
              required property int index
              width: 1.2 + (index % 2) * 0.5
              height: 28 + index * 5
              radius: 1
              color: "#e8e3d8"
              opacity: 0
              x: 982 + index * 5.0
              y: 584
              SequentialAnimation on y {
                running: root.active && root.waterfallVisible
                loops: Animation.Infinite
                PauseAnimation { duration: index * 240 }
                NumberAnimation { from: 584; to: 718; duration: 1300 + index * 80; easing.type: Easing.InQuad }
              }
              SequentialAnimation on opacity {
                running: root.active && root.waterfallVisible
                loops: Animation.Infinite
                PauseAnimation { duration: index * 240 }
                NumberAnimation { from: 0; to: 0.22; duration: 240 }
                NumberAnimation { to: 0.08; duration: 640 }
                NumberAnimation { to: 0; duration: 500 + index * 80 }
              }
            }
          }
        }

        ParticleSystem {
          id: particles
          z: 3
          running: root.active
          paused: !root.active
        }

        ImageParticle {
          system: particles
          source: Qt.resolvedUrl("petal.png")
          color: root.petalColor
          alpha: root.petalAlpha
          autoRotation: true
          colorVariation: 0.18
          rotationVelocity: (36 + root.windGust * 90) * root.windScale
          rotationVelocityVariation: (28 + root.windGust * 40) * root.windScale
          entryEffect: ImageParticle.Fade
        }

        Wander {
          system: particles
          xVariance: root.windSwirl
          yVariance: (28 + root.windGust * 50) * root.windScale
          pace: (55 + root.windGust * 85) * root.windScale
          affectedParameter: Wander.Position
        }

        Gravity {
          system: particles
          magnitude: root.petalGravity
          angle: 90
        }

        Gravity {
          system: particles
          angle: root.windHeading
          magnitude: root.windForce
        }

        // --- Top sky emitter (all scenes, rate/size/lifespan tuned per scene) ---
        Emitter {
          system: particles
          enabled: root.active
          x: -40
          y: -30
          width: 1680
          height: 50
          emitRate: root.topEmitBase * (1 + root.windGust * 0.9)
          lifeSpan: root.topLifeSpan
          lifeSpanVariation: 4000
          size: root.topPetalSize
          sizeVariation: 8
          endSize: 10
          velocity: AngleDirection {
            angle: 90 * 0.62 + root.windHeading * 0.38
            angleVariation: 16 + root.windGust * 14
            magnitude: (32 + root.windForce * 0.22) * (root.sceneKey === "golden-circlet" ? 0.65 : 1.0)
            magnitudeVariation: 14
          }
        }

        // --- Scene 1 (Flower-Fruit Mountain): lower cloud-sea slope emitters ---
        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "mountain"
          x: 540
          y: 690
          width: 180
          height: 30
          emitRate: 0.65 * (1 + root.windGust)
          lifeSpan: 12000
          lifeSpanVariation: 2500
          size: 14
          sizeVariation: 6
          velocity: AngleDirection {
            angle: root.windHeading + (root.windHeading > 90 ? 18 : -18)
            angleVariation: 26
            magnitude: 36 + root.windForce * 0.35
            magnitudeVariation: 16
          }
        }

        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "mountain"
          x: 880
          y: 670
          width: 220
          height: 30
          emitRate: 0.65 * (1 + root.windGust)
          lifeSpan: 12000
          lifeSpanVariation: 2500
          size: 14
          sizeVariation: 6
          velocity: AngleDirection {
            angle: root.windHeading + (root.windHeading > 90 ? 12 : -12)
            angleVariation: 22
            magnitude: 34 + root.windForce * 0.35
            magnitudeVariation: 14
          }
        }

        // --- Scene 2 (Dawn Ridges): upper-right sky stream + foreground blossom branches ---
        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "dawn-ridges"
          x: 1100
          y: 20
          width: 520
          height: 180
          emitRate: 1.0 * (1 + root.windGust * 0.8)
          lifeSpan: 16000
          lifeSpanVariation: 3500
          size: 15
          sizeVariation: 7
          endSize: 11
          velocity: AngleDirection {
            angle: 148 + (root.windHeading > 90 ? 10 : -14)
            angleVariation: 20
            magnitude: 36 + root.windForce * 0.28
            magnitudeVariation: 14
          }
        }

        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "dawn-ridges"
          x: 280
          y: 790
          width: 340
          height: 60
          emitRate: 0.45 * (1 + root.windGust)
          lifeSpan: 9500
          lifeSpanVariation: 2500
          size: 18
          sizeVariation: 7
          velocity: AngleDirection {
            angle: root.windHeading > 90 ? 215 : 325
            angleVariation: 28
            magnitude: 30 + root.windForce * 0.3
            magnitudeVariation: 12
          }
        }

        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "dawn-ridges"
          x: 1080
          y: 780
          width: 320
          height: 60
          emitRate: 0.45 * (1 + root.windGust)
          lifeSpan: 9500
          lifeSpanVariation: 2500
          size: 18
          sizeVariation: 7
          velocity: AngleDirection {
            angle: root.windHeading > 90 ? 210 : 320
            angleVariation: 28
            magnitude: 30 + root.windForce * 0.3
            magnitudeVariation: 12
          }
        }

        // --- Scene 3 (Peach Blossom Grove): three painted peach-tree canopies ---
        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "peach-grove"
          x: 90
          y: 150
          width: 340
          height: 210
          emitRate: 1.1 * (1 + root.windGust * 0.9)
          lifeSpan: 15000
          lifeSpanVariation: 3500
          size: 15
          sizeVariation: 6
          endSize: 12
          velocity: AngleDirection {
            angle: 90 * 0.65 + root.windHeading * 0.35
            angleVariation: 24
            magnitude: 26 + root.windForce * 0.25
            magnitudeVariation: 12
          }
        }

        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "peach-grove"
          x: 470
          y: 260
          width: 320
          height: 160
          emitRate: 0.9 * (1 + root.windGust * 0.9)
          lifeSpan: 14000
          lifeSpanVariation: 3000
          size: 13
          sizeVariation: 5
          endSize: 10
          velocity: AngleDirection {
            angle: 90 * 0.60 + root.windHeading * 0.40
            angleVariation: 24
            magnitude: 24 + root.windForce * 0.25
            magnitudeVariation: 10
          }
        }

        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "peach-grove"
          x: 1180
          y: 230
          width: 380
          height: 280
          emitRate: 1.1 * (1 + root.windGust * 0.9)
          lifeSpan: 14500
          lifeSpanVariation: 3500
          size: 16
          sizeVariation: 6
          endSize: 12
          velocity: AngleDirection {
            angle: 130 * 0.55 + root.windHeading * 0.45
            angleVariation: 26
            magnitude: 28 + root.windForce * 0.26
            magnitudeVariation: 12
          }
        }

        // --- Scene 4 (The Golden Staff): misty mountain-pass sweeps on either side ---
        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "golden-staff"
          x: 120
          y: 520
          width: 420
          height: 140
          emitRate: 0.75 * (1 + root.windGust)
          lifeSpan: 13000
          lifeSpanVariation: 3000
          size: 15
          sizeVariation: 6
          velocity: AngleDirection {
            angle: root.windHeading + (root.windHeading > 90 ? 10 : -10)
            angleVariation: 22
            magnitude: 38 + root.windForce * 0.35
            magnitudeVariation: 16
          }
        }

        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "golden-staff"
          x: 1020
          y: 500
          width: 440
          height: 150
          emitRate: 0.75 * (1 + root.windGust)
          lifeSpan: 13000
          lifeSpanVariation: 3000
          size: 15
          sizeVariation: 6
          velocity: AngleDirection {
            angle: root.windHeading + (root.windHeading > 90 ? 12 : -12)
            angleVariation: 22
            magnitude: 38 + root.windForce * 0.35
            magnitudeVariation: 16
          }
        }

        // --- Scene 5 (The Circlet): ethereal petals drifting from the golden orbit ---
        Emitter {
          system: particles
          enabled: root.active && root.sceneKey === "golden-circlet"
          x: 640
          y: 245
          width: 320
          height: 95
          emitRate: 0.75 * (1 + root.windGust * 0.6)
          lifeSpan: 20000
          lifeSpanVariation: 4500
          size: 12
          sizeVariation: 5
          endSize: 9
          velocity: AngleDirection {
            angle: root.windHeading * 0.5 + 45
            angleVariation: 40
            magnitude: 18 + root.windForce * 0.22
            magnitudeVariation: 10
          }
        }
      }
    }
  }
}
