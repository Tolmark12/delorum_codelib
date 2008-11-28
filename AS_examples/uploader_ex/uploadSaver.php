<?php
// Add security here
move_uploaded_file($_FILES['Filedata']['tmp_name'], "./files/".$_FILES['Filedata']['name']);
chmod("./files/".$_FILES['Filedata']['name'], 0777);
echo "http://codelib.dev/AS_examples/uploader_ex/files/".$_FILES['Filedata']['name'];
?>