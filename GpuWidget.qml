import QtQuick
import Quickshell
import Quickshell.Io

import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property real gpuPercent: 0.0
    property bool showLabel: pluginData.showLabel !== false
    property string labelText: pluginData.labelText || "GPU"

    function usageColor(percent) {
        if (percent > 90) return Theme.error
        if (percent > 75) return "#ffa500"
        return Theme.primary
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: gpuProcess.running = true
    }

    Process {
        id: gpuProcess
        command: ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const v = parseFloat(text.trim())
                if (isNaN(v)) return
                root.gpuPercent = v
            }
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingS

            DankIcon {
                name: "speed"
                size: Theme.fontSizeLarge
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                visible: root.showLabel
                text: root.labelText
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 44
                height: 6
                radius: 3
                color: Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.25)
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: parent.width * Math.min(root.gpuPercent, 100) / 100
                    height: parent.height
                    radius: parent.radius
                    color: root.usageColor(root.gpuPercent)
                    Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation { duration: 400 } }
                }
            }

            StyledText {
                text: `${root.gpuPercent.toFixed(0)}%`
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

}
