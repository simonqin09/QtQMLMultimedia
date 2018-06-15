import QtQuick 2.0
import QtMultimedia 5.5

/*
Camera.ActiveStatus defines as 8;
Camera.StartingStatus defines as 7;
Camera.StoppingStatus defines as 6;
Camera.StandbyStatus defines as 5;
Camera.LoadedStatus defines as 4;
Camera.LoadingStatus defines as 2;
Camera.UnloadingStatus defines as 3;
Camera.UnloadedStatus defines as 1;
Camera.UnavailableStatus  defines as 0;
*/


Item {
    id: item_camera_window
    visible: true
    width: 1024
    height: 768


    /* loader to load camere mode page Component*/
    Loader {
        id: myloader
        anchors.fill: parent
        z: 1
    }

    /* show the page when the qml file is loaded */
    Component.onCompleted: show()

    /* function to destroy the page, meantime clear the cameramodeloader in mail qml */
    function pagedestroy() {
        myloader.sourceComponent = undefined;
        cameramodeloader.sourceComponent = undefined;
    }

    /* function to show the page when camera_mode_visible is true */
    function show() {
        if(camera_mode_visible == true){
            myloader.sourceComponent = rectangle_camera_component
            myloader.item.parent = item_camera_window
            myloader.item.anchors.fill = item_camera_window
        }
    }



    /* component for page */
    Component {
        id: rectangle_camera_component

        Rectangle{
            id: rectangle_camera
            visible: true
            width: 1024
            height: 768
            color: "#ffffff"

            function cameraStatusCheck(){
                switch (camera.cameraStatus)
                {
                case Camera.ActiveStatus:
                    console.log("ActiveStatus");
                    break;
                case Camera.StartingStatus:
                    console.log("StartingStatus");
                    break;
                case Camera.StopingStatus:
                    console.log("StopingStatus");
                    break;
                case Camera.StandbyStatus:
                    console.log("StandbyStatus");
                    break;
                case Camera.LoadedStatus:
                    console.log("LoadedStatus");
                    break;
                case Camera.LoadingStatus:
                    console.log("LoadingStatus");
                    break;
                case Camera.UnloadingStatus:
                    console.log("UnloadingStatus");
                    break;
                case Camera.UnloadedStatus:
                    console.log("UnloadedStatus");
                    break;
                case Camera.UnavailableStatus:
                    console.log("UnavailableStatus");
                    break;
                default:
                    console.log("no maching status");
                }
            }

            function cameraStateCheck(){
                switch (camera.cameraState)
                {
                case Camera.UnloadedState:
                    console.log("Unloaded state");
                    break;
                case Camera.LoadedState:
                    console.log("Loaded state");
                    break;
                case Camera.ActiveState:
                    console.log("Active state");
                    break;
                default:
                    console.log("no maching state");
                }
            }

            /* mouse aera to disable main windows mouse action */
            MouseArea {
                anchors.fill: parent
            }

            /* camera capture box */
            Rectangle {
                id: rectangle_camera_capture
                x: 25
                y: 25
                width: 640
                height: 480
                color: "#000000"
                radius: 0

                Camera{
                    id: camera

                    imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

                    exposure {
                        exposureCompensation: -1.0
                        exposureMode: Camera.ExposurePortrait
                    }

                    flash.mode: Camera.FlashRedEyeReduction

                    imageCapture {
                        onImageCaptured: {
                            photopreview.source = preview
                            //var imgPath = camera.imageCapture.capturedImagePath  // if you want know image save path
                        }
                    }

                    onAvailabilityChanged: {
                        if(camera.availability !== Camera.Available)
                        {
                            console.log("Camera not available");
                        }
                    }
                    onCameraStateChanged: {
                        if(camera.cameraState === Camera.UnloadedState){
                            console.log("Camera disconnect unloaded");
                        }
                    }

                    onCameraStatusChanged: {
                        if(camera.cameraStatus !== Camera.ActiveStatus){
                            console.log("Camera inactive");
                        }


                        if (camera.cameraStatus === Camera.ActiveStatus) {

                            console.log("Camra in active status");
                        }
                    }

                    onError: {
                        camera.unlock();
                        console.error("error: " + camera.errorString);
                    }

                }

                VideoOutput {
                    anchors.fill: parent
                    source: camera
                }

            }

            Image {
                id: photopreview
                x: 25
                y: 525
                width: 320
                height: 240
            }

            /* title bar for "Camera Capture" */
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
                    text: qsTr("Camera Capture")
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 16
                }
            }

            /* "Camera ID" text box */
            Rectangle {
                id: rectangle_cameraidbox
                x: 671
                y: 65
                width: 60
                height: 30
                color: "#000000"
                radius: 2
                border.width: 1

                Text {
                    id: text_cameraidbox
                    anchors.centerIn: parent
                    text: qsTr("Camera ID")
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }
            }

            /* camera id lists */
            Rectangle {
                id: rectangle_cameraid
                x: 671
                y: 100
                width: 320
                height: 100
                color: "#ffffff"
                radius: 2
                border.width: 1

                ListView{
                    id: cameraIdList
                    model: QtMultimedia.availableCameras
                    width: 320
                    height: 100
                    snapMode: ListView.SnapOneItem
                    highlightRangeMode: ListView.ApplyRange
                    highlight: Rectangle { id: highlightID ; color: "yellow"; radius: 5 }

                    delegate: Item {
                        width: 320
                        height: 30
                        Text {
                            text: modelData.displayName + "   :   " + modelData.deviceId
                            anchors.fill: parent
                            anchors.margins: 5
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            style: Text.Raised
                            styleColor: "black"
                            z: 1
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (cameraIdList.currentIndex !== index) {
                                    camera.stop();
                                    cameraIdList.currentIndex = index
                                    camera.deviceId = modelData.deviceId
                                    camera.stop();
                                    rectangle_camerastop.color = "yellow"
                                    rectangle_camerastart.color = "#ffffff"
                                }
                            }
                        }

                        Component.onCompleted: {
                            if (modelData.displayName === camera.displayName){
                                cameraIdList.currentIndex = index;
                                camera.stop();
                                camera.deviceId = modelData.deviceId
                                camera.stop();
                                rectangle_camerastop.color = "yellow"
                            }
                        }
                    }
                }

            }

            /* "Capture" text bar */
            Rectangle {
                id: rectangle_cameracapture
                x: 671
                y: 222
                width: 110
                height: 30
                color: "#000000"
                radius: 2
                border.width: 1

                Text {
                    id: text_cameracapture
                    anchors.centerIn: parent
                    text: qsTr("Capture")
                    font.bold: true
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }
            }

            /* camera capture start button */
            Rectangle {
                id: rectangle_camerastart
                x: 801
                y: 222
                width: 60
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_camerastart
                    anchors.centerIn: parent
                    text: qsTr("Start")
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        camera.start();
                        parent.color = "yellow"
                        rectangle_camerastop.color = "#ffffff"
                    }
                }
            }

            /* camera capture stop button */
            Rectangle {
                id: rectangle_camerastop
                x: 881
                y: 222
                width: 60
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_camerastop
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
                        camera.stop();
                        parent.color = "yellow"
                        rectangle_camerastart.color = "#ffffff"
                    }
                }
            }

            /* "Save As Image" text bar */
            Rectangle {
                id: rectangle_saveasimage
                x: 671
                y: 282
                width: 110
                height: 30
                color: "#000000"
                radius: 2
                border.width: 1

                Text {
                    id: text_saveasimage
                    anchors.centerIn: parent
                    text: qsTr("Take photo")
                    font.bold: true
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    z: 1
                    font.pixelSize: 12
                }
            }

            /* Image save button */
            Rectangle {
                id: rectangle_saveimage
                x: 801
                y: 282
                width: 60
                height: 30
                color: "#ffffff"
                radius: 1
                border.width: 1

                Text {
                    id: text_saveimage
                    anchors.centerIn: parent
                    text: qsTr("Start")
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

                    }
                    onReleased: {
                        if(camera.cameraStatus === Camera.ActiveStatus)
                        {
                            camera.imageCapture.capture();
                        }else {
                            console.log("Please start Camera capture to take image");
                        }
                        parent.color = "#ffffff"
                    }
                }
            }

            /* button to switch to vedio mode */
            Rectangle {
                id: rectangle_switchtovideo
                x: 671
                y: 370
                width: 240
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_siwtchtovideo
                    text: qsTr("Switch to Video Mode")
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
                        item_camera_window.pagedestroy();
                    }
                }

            }

            /* button to quit application */
            Rectangle {
                id: rectangle_quit2
                x: 923
                y: 370
                width: 89
                height: 30
                color: "#ffffff"
                radius: 2
                border.width: 1

                Text {
                    id: text_quit2
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
