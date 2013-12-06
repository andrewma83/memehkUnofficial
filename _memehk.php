<?php
header ("content-Type: text/xml");
$prog_id = 11;
$db_host = 'localhost';
$db_user = 'root';
$db_pwd = 'XXXXXXX';    
$database = 'memehk';
$prog_id = $_GET["prog_id"];
$stmt_str = "SELECT episode, title, part, mp3_url  from program where id = $prog_id ORDER BY episode DESC, PART";

if (!mysql_connect($db_host, $db_user, $db_pwd)) {
    die("Can't connect to database");
}

if (!mysql_select_db($database)) {
    die("Can't select database");
}

mysql_query("SET character_set_results=utf8");
// sending query
$result = mysql_query($stmt_str);
if (!$result) {
    die("Query to show fields from table failed");
}

echo "<program>\n";

while ($row = mysql_fetch_row($result)) {
    echo "  <episode>$row[0]</episode>\n";
    echo "  <title>$row[1]</title>\n";
    echo "  <part>$row[2]</part>\n";
    echo "  <url>$row[3]</url>\n";
}

echo "</program>\n";
?>
