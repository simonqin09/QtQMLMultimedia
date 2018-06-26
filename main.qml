import QtQuick 2.7
import QtQuick.Window 2.2
import QtMultimedia 5.0


Window {
    visible: true
    id: root
    width: 1024
    height: 768
    title: qsTr("videotest")
    color: "transparent"

    /* property to control camera mode page load */
    property bool camera_mode_visible: false

    /* loader to load video mode page Component*/
    Loader{
        id: mainloader
        anchors.fill: parent
        z: 1
    }

    /* function load the page when mail qml is loaded */
    function loadpage(){
        mainloader.sourceComponent = maincomponent;
    }

    /* show the page when the qml file is loaded */
    Component.onCompleted: loadpage()

    /* Component for video mode page */
    Component {
        id: maincomponent
        Rectangle{
            visible: true
            id: rectangle_maincomponent
            width: 1024
            height: 768
            color: "#ffffff"

            /* CameraMode qml instance */
            CameraMode {
                id: cameramode1
                anchors.fill: parent
                z: 1
            }

            /* loader for load CameraMode.qml page */
            Loader{
                id: cameramodeloader
                anchors.fill: parent
                z: 1
            }

            /* media player box */
            Rectangle {
                id: rectangle
                x: 25
                y: 25
                width: 640
                height: 480
                color: "#000000"
                radius: 0

                MediaPlayer {
                    id: player
                    source: mysource
                }

                VideoOutput {
                    anchors.fill: parent
                    source: player
                }

                Component.onCompleted: {
                    //console.log("yoursource is " + mysource);
                }

            }

            /* title bar for "Video Player" */
            Rectangle {
                id: rectangle_videooutput
                x: 666
                y: 25
                width: 358
                height: 30
                color: "#000000"
                radius: 2
                border.width: 0

                Text {
                    id: text_videooutput
                    anchors.centerIn: parent
                    text: qsTr("Videoplayer")
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 16
                }
            }

            /* "File Path" text box */
            Rectangle {
                id: rectangle_filepath
                x: 671
                y: 65
                width: 60
                height: 30
                color: "#000000"
                radius: 2
                border.width: 1

                Text {
                    id: text_filepath
                    anchors.centerIn: parent
                    text: qsTr("File Path")
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }
            }

            /* video file path box */
            Rectangle {
                id: rectangle_fileurl
                x: 671
                y: 100
                width: 341
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_fileurl
                    text: mysource
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }

            }

            /* Play button */
            Rectangle {
                id: rectangle_play
                x: 671
                y: 162
                width: 60
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_play
                    anchors.centerIn: parent
                    text: qsTr("Play")
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }

                /*
                player.playbackState   0 mains stop status;
                player.playbackState   1 mains playing status;
                player.playbackState   2 mains pause status;
                */
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (player.playbackState != 1){
                            player.play();
                            parent.color = "yellow";
                            rectangle_pause.color = "#ffffff"
                            rectangle_stop.color = "#ffffff"
                        }
                    }
                }
            }

            /* Pause button */
            Rectangle {
                id: rectangle_pause
                x: 751
                y: 162
                width: 60
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_pause
                    anchors.centerIn: parent
                    text: qsTr("Pause")
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (player.playbackState == 1){
                            player.pause();
                            parent.color = "yellow";
                            rectangle_play.color = "#ffffff"
                        }
                    }
                }
            }

            /* stop button */
            Rectangle {
                id: rectangle_stop
                x: 831
                y: 162
                width: 60
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_stop
                    anchors.centerIn: parent
                    text: qsTr("Stop")
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (player.playbackState != 0){
                            player.stop();
                            parent.color = "yellow";
                            rectangle_play.color = "#ffffff"
                            rectangle_pause.color = "#ffffff"
                        }
                    }
                }
            }

            /* "Volume" text bar */
            Rectangle {
                id: rectangle_volume
                x: 671
                y: 212
                width: 60
                height: 30
                color: "#000000"
                radius: 2
                border.width: 1

                Text {
                    id: text_volume
                    anchors.centerIn: parent
                    text: qsTr("Volume")
                    font.bold: true
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }
            }

            /* show current volume box */
            Rectangle {
                id: rectangle_currentvolume
                x: 791
                y: 212
                width: 80
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_currentvolume
                    anchors.centerIn: parent
                    text: player.volume
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }
            }
            /* add volume button */
            Rectangle {
                id: rectangle_add
                x: 751
                y: 212
                width: 30
                height: 30
                color: "#ffffff"
                radius: 1
                border.width: 1

                Text {
                    id: text_add
                    anchors.centerIn: parent
                    text: qsTr("+")
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                            parent.color = "yellow";
                            if(player.volume < 1){
                                player.volume += 0.1;
                            }
                    }
                    onReleased: {
                            parent.color = "#ffffff"
                    }
                }
            }

            /* volume minus button */
            Rectangle {
                id: rectangle_minus
                x: 881
                y: 212
                width: 30
                height: 30
                color: "#ffffff"
                radius: 1
                border.width: 1

                Text {
                    id: text_minus
                    anchors.centerIn: parent
                    text: qsTr("-")
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        parent.color = "yellow";
                        if(player.volume > 0){
                            player.volume -= 0.1;
                        }
                    }
                    onReleased: {
                        parent.color = "#ffffff"
                    }
                }
            }

            Connections {
                target: player

                onStopped: {
                    // player status is MediaPlayer.EndOfMedia (6)
                    if(player.status === MediaPlayer.EndOfMedia)
                    {
                        rectangle_play.color = "#ffffff"
                    }
                }
            }

            /* button to switch to camera mode page */
            Rectangle {
                id: rectangle_switchtocamera
                x: 671
                y: 310
                width: 240
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_switchtocamera
                    text: qsTr("Switch to Camera Mode")
                    anchors.centerIn: parent
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                    z: 1
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        parent.color = "yellow";

                    }
                    onReleased: {
                        parent.color = "#ffffff";
                        camera_mode_visible = true;
                        if (player.playbackState == 1){
                            player.pause();
                            rectangle_pause.color = "yellow";
                            rectangle_play.color = "#ffffff"
                        }

                        cameramodeloader.source = "CameraMode.qml"
                    }
                }
            }

            /* button to quit application */
            Rectangle {
                id: rectangle_quit
                x: 923
                y: 310
                width: 89
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_quit
                    text: qsTr("Quit")
                    anchors.centerIn: parent
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                    z: 1
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        parent.color = "yellow";
                    }
                    onReleased: {
                        parent.color = "#ffffff";
                        Qt.quit();
                    }
                }

            }

        }
    }
}
