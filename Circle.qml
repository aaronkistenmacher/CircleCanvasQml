import QtQuick 2.0
import QtQuick.Controls 2.10

Rectangle {
    id: circle

    property real centerX
    property real centerY

    property bool selected
    property bool showControls

    signal clicked(int modifiers)
    signal doDelete()
    signal doEditColor()
    signal doUpdateRadius(real value)

    signal doUpdatePosition(real dx, real dy)

    width: 2*radius
    height: 2*radius

    x: centerX - radius
    y: centerY - radius
    z: showControls ? 1 : 0

    border {
        width: selected ? 2 : 0
        // Make selected indicator stand out against circle color
        color: circle.color.hslLightness > 0.5 ? 'black' : 'white'
    }

    MouseArea {
        anchors.fill: parent

        // Used to calculate deltas on drag events
        property real prevX: 0
        property real prevY: 0

        // State to block call to deselect if a drag event occurs
        property bool inClick: false

        onPressed: {
            prevX = mouse.x;
            prevY = mouse.y;

            inClick = true;
        }

        onPositionChanged: {
            if (selected) {
                let x = circle.centerX
                var deltaX = mouse.x - prevX;
                x += deltaX;

                let y = circle.centerY
                var deltaY = mouse.y - prevY
                y += deltaY;

                doUpdatePosition(deltaX, deltaY);

                prevX = mouse.x - deltaX;
                prevY = mouse.y - deltaY;

                inClick = false;
            }
        }

        onReleased: {
            if (inClick) {
                circle.clicked(mouse.modifiers);
                inClick = false;
            }
        }

        onCanceled: inClick = false
    }

    Rectangle {
        id: deleteIndicator

        visible: showControls

        anchors { bottom: parent.verticalCenter; left: parent.horizontalCenter; margins: 40 }

        width: 30
        height: width
        radius: width/2

        color: 'white'

        border { color: 'black'; width: 2 }

        Text {
            anchors.centerIn: parent
            text: 'X'
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent

            onClicked: circle.doDelete()
        }
    }

    Rectangle {
        id: editPropsButton

        visible: showControls

        anchors { centerIn: parent; verticalCenterOffset: 70 }

        width: 150
        height: 32
        radius: 10

        color: 'white'
        border { color: 'black'; width: 2 }

        Text {
            anchors.centerIn: parent
            text: 'Edit Color'
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: doEditColor()
        }
    }

    Slider {
        id: sizeSlider

        visible: showControls
        onVisibleChanged: value = circle.radius

        height: 100

        from: 10
        to: 100

        onValueChanged: doUpdateRadius(value)

        orientation: Qt.Vertical

        anchors { centerIn: parent; horizontalCenterOffset: -70 }
    }
}
