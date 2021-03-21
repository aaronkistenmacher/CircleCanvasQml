import QtQuick 2.0
import QtQuick.Dialogs 1.3

import 'CircleCanvas.js' as MainScript

Item {
    MouseArea {
        anchors.fill: parent

        onClicked: {
            MainScript.clearSelections();
            circleModel.append({
                radius: 50,
                centerX: mouse.x,
                centerY: mouse.y,
                color: MainScript.lastSelectedColor,
                selected: false,
                mostRecentlySelected: false,
            });
            MainScript.toggleSelection(circleModel.count - 1);
        }
    }

    Repeater {
        model: ListModel {
            id: circleModel
        }

        delegate: Circle {
            id: circle

            centerX: model.centerX
            centerY: model.centerY
            radius: model.radius

            color: model.color

            selected: model.selected

            showControls: model.mostRecentlySelected

            onClicked: MainScript.handleCircleClicked(model.index, modifiers)
            onDoDelete: MainScript.deleteSelected()
            onDoEditColor: {
                colorDialog.color = color;
                colorDialog.open();
            }
            onDoUpdateRadius: MainScript.updateRadiusForSelected(value)

            onDoUpdatePosition: MainScript.updatePositionsForSelected(dx, dy)
        }
    }

    ColorDialog {
        id: colorDialog

        title: "Please choose a color"

        onCurrentColorChanged: MainScript.updateColorsForSelected(currentColor)

        onAccepted: {
            MainScript.updateColorsForSelected(color);
            colorDialog.close();
        }

        onRejected: {
            MainScript.updateColorsForSelected(color);
            colorDialog.close();
        }
    }

    Text {
        id: instructions

        text: 'Hold the shift key to select multiple items'

        opacity: 0
        visible: opacity > 0

        onOpacityChanged: {
            if (opacity === 1) {
                timeToDisplay.restart();
            }
        }

        Behavior on opacity { NumberAnimation { duration: 1000 } }

        anchors { bottom: parent.bottom; bottomMargin: 10; horizontalCenter: parent.horizontalCenter }

        Timer { id: timeToDisplay; interval: 2000; onTriggered: instructions.opacity = 0 }
    }
}
