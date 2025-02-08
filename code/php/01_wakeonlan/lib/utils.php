<?php

/**
 * @param mixed $mixed
 * @return void
 */
function var_dump_pre($mixed): void {
    echo "<pre>\n";
    var_dump($mixed);
    echo "</pre>\n";
}

/**
 * Generates the html of the header of each page of the site
 * @return string
 */
function generate_html_header_string(): string {
    return "<!DOCTYPE html>\n"
        ."<html lang=\"en\">\n\n"
        ."<head>\n"
        ."    <title>Allumage du fixe de Laurence</title>\n"
        ."    <meta charset=\"utf-8\">\n"
        ."    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
        ."</head>\n";
}
