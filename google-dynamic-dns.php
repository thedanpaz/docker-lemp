<?php

$ip = exec('curl icanhazip.com');

$curl = curl_init();

$dynamicDnsUsername = 'REPLACE-ME-WITH-USERNAME';
$dynamicDnsPassword = 'REPLACE-ME-WITH-PASSWORD';
$dynamicDnsDomain = 'REPLACE-ME-WITH-DOMAIN'; // eg. something.example.com

curl_setopt_array($curl, array(
    CURLOPT_URL => "https://" . $dynamicDnsUsername . ":" . $dynamicDnsPassword . "@domains.google.com/nic/update?hostname=" . $dynamicDnsDomain ."&myip=" . $ip,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => "",
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 30,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => "GET",
    CURLOPT_HTTPHEADER => array(
        "Cache-Control: no-cache",
        "Postman-Token: 21d94574-5fa2-474b-8e6b-3ccaf42062eb",
        "User-Agent: dpaz-php-updater"
    ),
));

$response = curl_exec($curl);
$err = curl_error($curl);

curl_close($curl);

if ($err) {
    echo "cURL Error #:" . $err;
} else {
    echo $response;
}