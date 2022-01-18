import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QMLDatabase 1.0


Window {
    id: window
    visible: true
    width: 640
    height: 480
    property alias rectangleX: headingRectangle.x
    title: qsTr("Hello World")
    Database{
        id: mysql
    }

    Rectangle {
        id: mainContainerRectangle
        color: "#ff867a"
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ff867a"
            }

            GradientStop {
                position: 0.21
                color: "#ff8c7f"
            }

            GradientStop {
                position: 0.52
                color: "#f99185"
            }

            GradientStop {
                position: 0.78
                color: "#cf556c"
            }

            GradientStop {
                position: 1
                color: "#b12a5b"
            }
        }
        anchors.fill: parent

        Column {
            id: column
            anchors.fill: parent

            Rectangle {
                id: headingRectangle
                x: column.x
                width: column.width
                height: 68
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "#209cff"
                    }

                    GradientStop {
                        position: 1
                        color: "#68e0cf"
                    }
                }
                anchors.top: parent.top
                anchors.topMargin: 0

                Text {
                    id: element
                    x: 82
                    y: 27
                    width: 172
                    height: 14
                    color: "#ffffff"
                    text: qsTr("FOOD CALORIES CALCULATOR")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 20
                }
            }

        }

        Rectangle {
            id: inputRectangle
            y: headingRectangle.height
            width: column.width
            height: 350
            color: "#ffffff"

            Column {
                id: row
                anchors.leftMargin: 15
                anchors.topMargin: 15
                anchors.bottomMargin: 17
                anchors.rightMargin: 287
                anchors.fill: parent

                TextInput {
                    id: foodTextInput
                    width: 132
                    height: 47
                    text: qsTr("")
                    layer.smooth: true
                    font.pixelSize: 20
                    property string placeholderText: "FOOD NAME"

                    Text {
                        x: 0
                        y: 0
                        width: 82
                        height: 27
                        font.pixelSize: 20
                        color: "#aaa"
                        text: foodTextInput.placeholderText
                        anchors.top: parent.top
                        visible: !foodTextInput.text
                    }
                }

                TextInput {
                    id: fatTextInput
                    width: 132
                    height: 47
                    text: qsTr("")
                    layer.smooth: true
                    font.pixelSize: 20
                    validator : RegExpValidator { regExp : /[0-9]+\.[0-9]+/ }
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    property string placeholderText: "FAT"

                    Text {
                        x: 0
                        y: 0
                        width: 82
                        height: 27
                        font.pixelSize: 20
                        color: "#aaa"
                        text: fatTextInput.placeholderText
                        anchors.top: parent.top
                        visible: !fatTextInput.text
                    }
                }

                TextInput {
                    id: proteinTextInput
                    width: 132
                    height: 47
                    text: qsTr("")
                    layer.smooth: true
                    font.pixelSize: 20
                    validator : RegExpValidator { regExp : /[0-9]+\.[0-9]+/ }
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    property string placeholderText: "PROTEIN"

                    Text {
                        x: 0
                        y: 0
                        width: 82
                        height: 27
                        font.pixelSize: 20
                        color: "#aaa"
                        text: proteinTextInput.placeholderText
                        anchors.top: parent.top
                        visible: !proteinTextInput.text
                    }
                }

                TextInput {
                    id: carbohydratesTextInput
                    width: 132
                    height: 47
                    layer.smooth: true
                    font.pixelSize: 20
                    validator : RegExpValidator { regExp : /[0-9]+\.[0-9]+/ }
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    property string placeholderText: "CARBOHYDRATES"

                    Text {
                        x: 0
                        y: 0
                        width: 82
                        height: 27
                        font.pixelSize: 20
                        color: "#aaa"
                        text: carbohydratesTextInput.placeholderText
                        anchors.top: parent.top
                        visible: !carbohydratesTextInput.text
                    }
                }

                Button {
                    id: calculateButton
                    text: qsTr("CALCULATE")
                    onClicked: {
                        var m_calories = mysql.calculateCalories(fatTextInput.text, carbohydratesTextInput.text, proteinTextInput.text)
                        mysql.setCalories(m_calories)
                        messageDialog.open()
                    }

                    MessageDialog {
                        id: messageDialog
                        visible: false
                        title: "Calculation Results"
                        text: qsTr("Total Calories in "+foodTextInput.text+" is "+mysql.calories+". Click Ok to save")
//                        ButtonGroup: MessageDialog.Ok | MessageDialog.Cancel
                        onAccepted: {
                            messageDialog.close()
                            var inserted = mysql.insertData(foodTextInput.text, fatTextInput.text,
                                                            carbohydratesTextInput.text, proteinTextInput.text)

                            if (inserted) {
                                statusMessageDialog.message = "Save Sucessiful"
                            } else {
                                statusMessageDialog.message = "Save Failed"
                            }

                            statusMessageDialog.open()
                        }
                        Component.onCompleted:{
                            messageDialog.standardButton(MessageDialog.Ok).text = qsTrId("Save")
                        }
                    }

                }

                MessageDialog {
                    id: statusMessageDialog
                    visible: false
                    title: "Calculation Results"
                    text: qsTr(message)
                    property string message: ""
                    onAccepted: {
                        messageDialog.close()
                        var inserted = mysql.insertData(foodTextInput.text, fatTextInput.text,
                                                        carbohydratesTextInput.text, proteinTextInput.text)

                        if (inserted) {

                        }
                    }
                    Component.onCompleted:{
                        messageDialog.standardButton(MessageDialog.Ok).text = qsTrId("Save")
                    }
                }
            }
        }
    }
}



/*##^##
Designer {
    D{i:9;anchors_y:0}D{i:8;anchors_height:400;anchors_width:200;anchors_x:26;anchors_y:209}
D{i:15;anchors_height:400;anchors_width:200}D{i:1;anchors_height:200;anchors_width:200;anchors_x:88;anchors_y:133}
}
##^##*/
