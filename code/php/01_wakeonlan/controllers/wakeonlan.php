<?php

// if the request is POST ...
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // send the magick packet
    $command_output = shell_exec('lib/wakeonlan_windows_tower.sh');
    $view_name = 'magick_packet_sent';
}
else {
    $view_name = 'landing';
}

require "views/$view_name.php";
