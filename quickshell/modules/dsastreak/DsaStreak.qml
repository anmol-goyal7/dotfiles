import "root:/modules/common/"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// DSA practice streak, drawn on the wallpaper (bottom-right corner).
// Data comes from `dsa streak` -> "<days> <yes|no>"; refreshed every minute.
Scope {
    PanelWindow {
        id: root

        property int streak: 0
        property bool doneToday: false
        property int focusMin: 0

        WlrLayershell.namespace: "quickshell:dsastreak"
        WlrLayershell.layer: WlrLayer.Bottom
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"

        anchors {
            right: true
            bottom: true
        }
        margins {
            right: 44
            bottom: 44
        }

        implicitWidth: card.implicitWidth
        implicitHeight: card.implicitHeight

        // Empty input region: clicks pass straight through to the desktop
        mask: Region {}

        Process {
            id: streakProc
            command: ["/home/anmol/repos/dotfiles/bin/dsa", "streak"]
            running: true
            stdout: SplitParser {
                onRead: data => {
                    const parts = data.trim().split(/\s+/);
                    root.streak = parseInt(parts[0]) || 0;
                    root.doneToday = parts[1] === "yes";
                    root.focusMin = parseInt(parts[2]) || 0;
                }
            }
        }

        Timer {
            interval: 60 * 1000
            running: true
            repeat: true
            onTriggered: streakProc.running = true
        }

        Rectangle {
            id: card
            radius: Appearance?.rounding?.normal ?? 18
            color: "#B3161217"
            border.width: 1
            border.color: Appearance?.m3colors.m3borderSecondary ?? "#4C444D"
            implicitWidth: content.implicitWidth + 44
            implicitHeight: content.implicitHeight + 28

            ColumnLayout {
                id: content
                anchors.centerIn: parent
                spacing: 2

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8

                    Text {
                        id: fireGlyph
                        text: "󰈸"
                        font.family: Appearance?.font.family.codeFont ?? "JetBrains Mono NF"
                        font.pixelSize: 30
                        color: "#fab387"
                    }

                    Text {
                        text: root.streak
                        font.family: Appearance?.font.family.uiFont ?? "Open Sans"
                        font.pixelSize: 32
                        font.weight: Font.Bold
                        color: Appearance?.m3colors.m3primaryText ?? "#EAE0E7"
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "day streak · DSA"
                    font.family: Appearance?.font.family.uiFont ?? "Open Sans"
                    font.pixelSize: 13
                    color: Appearance?.m3colors.m3secondaryText ?? "#CFC3CD"
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: root.doneToday ? "today ✓" : "today · not yet"
                    font.family: Appearance?.font.family.uiFont ?? "Open Sans"
                    font.pixelSize: 12
                    color: root.doneToday ? "#a6e3a1" : (Appearance?.m3colors.m3secondaryText ?? "#CFC3CD")
                    opacity: root.doneToday ? 1 : 0.55
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    visible: root.focusMin > 0
                    text: root.focusMin + " min focus"
                    font.family: Appearance?.font.family.uiFont ?? "Open Sans"
                    font.pixelSize: 12
                    color: "#fab387"
                    opacity: 0.9
                }
            }
        }
    }
}
