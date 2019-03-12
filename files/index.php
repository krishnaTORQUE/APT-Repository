<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title><?php echo ucwords($_SERVER['HTTP_HOST']); ?> | NMP v1.12</title>
</head>
<body>

<!--
* Projects
-->
<div style="width: 49%; float: left;">

    <h3>Projects</h3>

    <?php
    $shows = [];
    $all_lists = scandir('./');
    foreach ($all_lists as $sdf) {
        if ($sdf === '.' || $sdf === '..') {
            continue;
        }
        if (is_dir($sdf)) {
            $link = '[D] <a href="' . $sdf . '">' . $sdf . '</a><br/><br/>';
            array_unshift($shows, $link);

        } else {
            $link = '[F] <a href="' . $sdf . '">' . $sdf . '</a><br/><br/>';
            array_push($shows, $link);
        }
    }

    foreach ($shows as $s) {
        echo $s;
    }
    ?>

</div>

<!--
* Details
-->
<div style="width: 49%; float: right; text-align: right;">

    <h1><?php echo ucwords($_SERVER['HTTP_HOST']); ?> | NMP v1.12</h1>

    <br/>

    <em>Host:</em>
    <b><?php echo '<em>' . $_SERVER['HTTP_HOST'] . '</em> - ' . $_SERVER['SERVER_NAME'] . ':' . $_SERVER['SERVER_PORT']; ?></b>
    &emsp;

    <em>Nginx:</em>
    <b><?php echo explode('/', $_SERVER['SERVER_SOFTWARE'])[1]; ?></b>
    &emsp;

    <em>PHP:</em>
    <b><?php echo explode('-', PHP_VERSION)[0]; ?></b>
    &emsp;

    <em>MySQL:</em>
    <b>
        <?php
        $mysql = preg_replace('@[^0-9.]@', '', exec('mysql -V'));
        echo substr($mysql, 0, 6);
        ?>
    </b>

    <br/><br/>

    <a href="info.php">
        <b>PHP Info</b>
    </a>

    <?php if (file_exists('phpmyadmin')): ?>

        &emsp; &emsp;

        <a href="phpmyadmin">
            <b>phpMyAdmin</b>
        </a>
    <?php endif; ?>

</div>

</body>
</html>