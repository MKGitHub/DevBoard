<?php
    /*
        Dev Board 1.0.1
        Copyright © 2019-2020 Mohsan Khan. All rights reserved.

        • This is the receiver page.
        • It does not have any UI.
        • The received info will be saved to disk in the root folder of the PHP server.
    */

    function writeResponse($success, $message)
    {
        $array = array();
        $array["success"] = $success;
        $array["message"] = $message;
        echo json_encode($array);
    }

    // properties
    $mLogFile = "DevBoard_Log.json";

    // get the request
    $mRequest = $_REQUEST["devBoard"];

    // open log file
    if (!$mHandle = fopen($mLogFile, "w"))
    {
        writeResponse(false, "Cannot open file: $mLogFile");
        exit;
    }

    // write log file
    if (fwrite($mHandle, $mRequest) === false)
    {
        writeResponse(false, "Cannot write file: $mLogFile");
        exit;
    }

    // success
    writeResponse(true, "Log file has been updated");

    fclose($mHandle);
?>

