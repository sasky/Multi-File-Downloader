<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
	<title>multi downloader HTML test 1 </title>
	<link  href="css/BareBones.css" type="text/css" rel="stylesheet" />
	<script src="js/swfobject.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/jquery-1.4.4.min.js" ></script> 
	<script type="text/javascript" src="js/jquery.progressbar.min.js" ></script> 
	
	<?php
	include 'includes/testData.php';
	include 'includes/json_encode_function.php';
	//$Json_data = json_encode($test_data) ; this function only works in php 5.2 +
	$Json_data = __json_encode($test_data);
	?>
	<script type="text/javascript" >
	
	var boxsChecked = new Array();
	var tracksAlreadyDownloaded = new Array();
	
	$("#pbSave").hide();
	var flashObject;
	var Json_data = <?php echo($Json_data) ?>;

	// inserting the .swf
	var flashvars = {buttonSprite:"images/buttonSprite.gif" , length :"75" , yInc:"25"};
	var params = {
		menu: "false",
		scale: "noScale",
		allowFullscreen: "false",
		allowScriptAccess: "always",
		bgcolor: "#FFFFFF"
	};
	var attributes = {
		id:"mdFlash"
	};
	swfobject.embedSWF("FlashComponent/bin/mdFlash.swf", "FlashGoesHere", "80", "30", "10.1.0", "expressInstall.swf", flashvars, params, attributes);

	// helper funcions
	
	function allreadyBeenDownloaded(id) 
	{
		
		if(tracksAlreadyDownloaded.length > 0)
		{
			for(var l = 0 ; l < tracksAlreadyDownloaded.length ; l++)
			{
				if(tracksAlreadyDownloaded[l] == id)
				{
					return true;
				}
			}
		}
		
		return false;
	};
	//Jquery begin

	$(document).ready(function()
	{
		// the flash component
		flashObject = $("#mdFlash")[0];
		// first I need to add the progress bars to the html
		// progress bar for each track
		for (var i = 0; i < Json_data.length; i++) 
		{
			$("#pb" + Json_data[i].id).progressBar();
		}
		// saving progress bar at bottem	
		

		
		// handle select all button
		// if the check box is checked and its id (name) is not in the allreadyBeenDownloaded
		// array , then check and uncheck all check boxs
		$("#selectAllCheckBox").click(function()
		{
			if($("#selectAllCheckBox").val("checked")[0].checked) 
			{
				//check all track checkboxes
				$(".trackCheckBox").each(function()
				{
					if( !allreadyBeenDownloaded($(this).val("name")[0].name))
					{
						$(this).attr("checked" , true);
					} 
				});
			} 
			else //uncheck
			{
				$(".trackCheckBox").each(function()
				{
					if( !allreadyBeenDownloaded($(this).val("name")[0].name))
					{
						$(this).attr("checked" , false);
					}
				});
			}
		});
		//if Download btn is pressed 
		$("#DownloadBtn").click( function()
		{
			// collect the ids of the tracks that have been selected when 
			//Download Button is pressed
			$(".trackCheckBox").each(function()
			{
				if($(this).val("checked")[0].checked)
				{
					// checks to see if this track has already been downloaded
					if(!allreadyBeenDownloaded($(this).val("name")[0].name) )
					{
						// if it hasn't, then download it
						boxsChecked.push($(this).val("name")[0].name);
					}
				}
			});
			//send to flash
			if(boxsChecked.length > 0)
			{
				flashObject.downloadBtnClicked(boxsChecked);
				// disable download btn
				$("#DownloadBtn").attr("disabled" , true);
				// disable all check boxs
				$(".trackCheckBox , #selectAllCheckBox" ).attr("disabled" , true);
			}
		});	
	});// end jquery

	// As to js functions
	
	function getJsonData()
	{
		return Json_data;
	}
	function setInfoText(text)   
	{
		//TODO show what type of message
		$("#infoBoxTxt").html("<p>" + text + "</p>");
	}
	
	function updateProgressBar(progress , downLoadBarId)
	{
		$("#pb" + downLoadBarId).progressBar(progress);
	}
	var firstCalled = false;
	function updateSaveProgressBar(progress)
	{
		if(!firstCalled)
		{
			$("#pbSave").show();
			
			$("#pbSave").progressBar();
			// create the progress bar and inset it into the bottem of the info box
			firstCalled = true;
		} 
		else 
		{
			$("#pbSave").progressBar(progress); 
		}
			
		
	}
	function reset()
	{
		for (var h = 0 ; h < boxsChecked.length ; h++)
		{
			tracksAlreadyDownloaded.push(boxsChecked[h]);
		} 
		// enable all check boxs except for the ones that were previously checked
		$(".trackCheckBox").each(function()
		{
			$(this).attr("checked" , false);
			$(this).attr("disabled" , false);
		});
		$(".trackCheckBox").each(function()
		{
			for(var i = 0 ; i <tracksAlreadyDownloaded.length ; i++)
			{ 
				if($(this).val("name")[0].name == tracksAlreadyDownloaded[i] ) 
				{
					$(this).attr("disabled" , true);
					$(this).attr("checked" , true);
				}
			}
		});
		
		//
		// enable download button
		$("#DownloadBtn").attr("disabled" , false);
		// clear boxs checked
		boxsChecked = [];
		$("#selectAllCheckBox" ).attr("disabled" , false);
		
		// TODO get rid of save progress bar 
		$("#pbSave").hide();
		firstCalled = false;
		
	}
	</script>
</head>
<body>

<div id="multiDownloader"> 
	<h2>Download your Purchased Tracks</h2>
	
	<?php foreach ($test_data  as $i => $track_object) : ?>
	<p class="trackName"><?php echo ($track_object['name'] )?></p>
	<!-- progress bar  -->
	<span class="progressBar"  id="pb<?php echo($track_object['id'])?>" ></span>
	<!-- progress bar  -->
	<input type="checkbox" class="trackCheckBox"  name="<?php echo($track_object['id'])?>" value="" /> 
	<?php endforeach; ?>
	
	<p class="selectAll">Select All </p>
	<input type="checkbox" id="selectAllCheckBox" name="selectAll"  />
	<div id="infoBox">
		<div id="infoBoxTxt"></div>
		<span class="progressBar" id="pbSave" ></span>
	</div>
	
	
	<button id="DownloadBtn"  class="btn"  type="button" name="Download"  >Download Music</button><br />
	<div id="FlashGoesHere"></div>
	<!-- <button type="button" class="btn" name="Save"  disabled="disabled">Save Files</button>  -->
	<!-- <span class="progressBar" id="pbSave" ></span>-->
	<div id="footer"></div>
	
</div>

</body>
</html>