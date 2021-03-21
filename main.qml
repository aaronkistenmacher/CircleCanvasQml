import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 1280
    height: 1024
    title: qsTr("Circle Canvas")

    color: 'lightGray'

    CircleCanvas {
        anchors.fill: parent
    }
}
