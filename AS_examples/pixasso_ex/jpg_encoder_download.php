<?php
if (isset($GLOBALS["HTTP_RAW_POST_DATA"]))
{
	// get bytearray
	$jpg = $GLOBALS["HTTP_RAW_POST_DATA"];

	// add headers for download dialog-box
	//header('Content-Type: image/jpeg');
	//header("Content-Disposition: attachment; filename=".$_GET['name']);
	
	
	$myFile 		= $_GET['name'];
	$fileHandler 	= fopen($myFile, 'w') or die("can't open file");
	fwrite($fileHandler, $jpg);
	fclose($fileHandler);
	
	echo 
	"<img src='$myFile'/>";
}
?>