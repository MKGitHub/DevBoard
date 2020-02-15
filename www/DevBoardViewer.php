<?php
    /*
        Dev Board 1.0.1
        Copyright © 2019-2020 Mohsan Khan. All rights reserved.

        • This is the viewer page.
        • It displays the received info by reading it from the log file.
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
    $mRefreshTime = $_REQUEST["refreshTime"];
    $mTheme = $_REQUEST["theme"];

    // open log file
    if (!$mHandle = fopen($mLogFile, "r"))
    {
        writeResponse(false, "Cannot open file: $mLogFile");
        exit;
    }

    // read log file
    //$mLogFileContents = fread($mHandle, filesize($mLogFile));
    $mLogFileContents = file_get_contents($mLogFile);
    if ($mLogFileContents === false)
    {
        writeResponse(false, "Cannot read file: $mLogFile");
        exit;
    }

    fclose($mHandle);
?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <!-- https://developer.apple.com/library/archive/documentation/AppleApplications/Reference/SafariHTMLRef/Articles/MetaTags.html -->
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black" />
        <meta name="format-detection" content="telephone=no">
        <!-- https://webkit.org/blog/7929/designing-websites-for-iphone-x/ -->
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no, viewport-fit=cover">
        <link rel="stylesheet" type="text/css" href="/themes/<?php echo $mTheme; ?>.css">
        <meta http-equiv="refresh" content="<?php echo $mRefreshTime; ?>">
        <title>Dev Board 1.0.0</title>
    </head>
    <body>
        Refresh:<select id="refreshTimeSelector" onchange="reloadPage();">
            <option value="1">1 second</option>
            <option value="2">2 seconds</option>
            <option value="3">3 seconds</option>
            <option value="5">5 seconds</option>
            <option value="10">10 seconds</option>
            <option value="30">30 seconds</option>
            <option value="60">1 minute</option>
            <option value="180">3 minutes</option>
            <option value="600">5 minutes</option>
        </select>

        Theme:<select id="themeSelector" onchange="reloadPage();">
            <option value="dark">Dark</option>
            <option value="light">Light</option>
        </select>

        <br>

        <script>
            let devBoard = JSON.parse('<?php echo json_encode(json_decode($mLogFileContents, true)); ?>');

            console.log(devBoard);

            // set the chosen options
            document.getElementById("refreshTimeSelector").value = "<?php echo $mRefreshTime; ?>";
            document.getElementById("themeSelector").value = "<?php echo $mTheme; ?>";

            function reloadPage()
            {
                let time = document.getElementById("refreshTimeSelector").value;
                let theme = document.getElementById("themeSelector").value;
                location.assign("?refreshTime=" + time + "&theme=" + theme);
            }

            /*
                Actions:
                1 = Apply blinking animation to key-value.
            */

            function makeSpanElement(keyClass, keyStyle, key, value, valueClass, valueStyle)
            {
                /*var str = "<span class='$keyClass' style='$keyStyle'>" + key + ":</span>" +
                          "<span class='$valueClass' style='$valueStyle'>" + value + "</span><br>";
                str = str.replace("$keyClass", keyClass);
                str = str.replace("$keyStyle", keyStyle);
                str = str.replace("$valueClass", valueClass);
                str = str.replace("$valueStyle", valueStyle);*/

                let keySpan = document.createElement("span")
                keySpan.innerHTML = key + ":";
                if (keyClass) { keySpan.className = keyClass; }
                if (keyStyle) { keySpan.style = keyStyle; }

                let valueSpan = document.createElement("span")
                valueSpan.innerHTML = value;
                if (valueClass) { valueSpan.className = valueClass; }
                if (valueStyle) { valueSpan.style = valueStyle; }

                return keySpan.outerHTML + valueSpan.outerHTML + "<br>"
            }

            function makeRowTypeNormal(key, value, color)
            {
                let col = color ? ("color:" + color) : ""

                return makeSpanElement("paramName", col,
                                       key, value,
                                       "", col);
            }

            function makeRowTypeBlinking(key, value, color)
            {
                let col = color ? ("color:" + color) : ""

                return makeSpanElement("paramName blinkAnimation", col,
                                       key, value,
                                       "blinkAnimation", col);
            }

            // Render html. //

            var html = "";

            for (let i in devBoard.parameters)
            {
                let po = devBoard.parameters[i];

                if (po.actions.includes(1)) {
                    html += makeRowTypeBlinking(po.key, po.value, po.color);
                }
                else {
                    html += makeRowTypeNormal(po.key, po.value, po.color);
                }

                /*if (po.actions.includes(1))
                {
                    let audio = new Audio("/sounds/beep1.mp3");
                    setTimeout(function(){ audio.play(); }, 1000);
                }*/
            }
            
            document.write(html);
        </script>
    </body>
</html>

