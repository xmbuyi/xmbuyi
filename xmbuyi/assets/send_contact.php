<?php

	$fl_name = $_REQUEST['fl_name'];
	$fl_email = $_REQUEST['fl_email'];
	$fl_msg = $_REQUEST['fl_msg'];
	
	$mail_text = "";
	
	if($fl_email) {
		
		$headers = "MIME-Version: 1.0\n";
	
		$headers .= "Content-type: text/html; charset=UTF-8\n";
		
		$headers .= "X-Mailer: PHP/".phpversion()."\n";
		
		$headers .= "From:$fl_email\n";
		
		$mail_text = "<html><body>
<h2>Contact Request From Website</h2>
<br><b>Name:</b> $fl_name
<br><b>E-mail:</b> $fl_email
<br><br><b>Message:</b><br>$fl_msg<br><br>


</body></html>";
		
		mail("your@email.com", "Contact Request from Your website", $mail_text, $headers);
		
		echo "result=ok";
	}

?>