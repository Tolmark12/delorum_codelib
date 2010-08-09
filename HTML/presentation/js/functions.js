
// VARS DEFINED IN SOURCE HTML:
var useLabels;						// Set to true to use user defined variables instead of generic numbers

// STATE: 
var currentUlItem;
var currentLIItem;

// DICTIONARIES
var imageDictionary = {};
var defaultItems = {};

/** 
*	Loads the specified image into the browser window
*/
function displayImage( $id )
{
	// Set current button visuals to unselected:
	if (currentLIItem)
		currentLIItem.className = "unSelected"
	
	// Highlight the new button as selected:
	currentLIItem = document.getElementById( $id );
	if(currentLIItem)
		currentLIItem.className = "selected";
	
	// Retrieve image path, and set it as div bg:
	image = imageDictionary[ $id ];
	document.getElementById('body').style.background = image[2] + " url(" + image[0] + ") no-repeat top center";
	// Stretch the div to the correct height
	document.getElementById('image-div').style.height = image[1] +"px";
}

/** 
*	Displays the specified <ul> nav. Called via Select menu
*/
var currentUlItem;
function showNavById( $id ) {
	// Hide the current ul nav if there is one
	if (currentUlItem)
		currentUlItem.className = "hidden"
	
	// Show the new nave
	var item = document.getElementById($id);
	if (item) {
		item.className = 'unhidden'
		currentUlItem = item;
		displayImage( defaultItems[$id] );
	}
}

/** 
*	Create drop down and navigation
*/
function createNav( $images )
{
	// Create the select drop down
	var firstItem;
	var option;
	var ul;
	var li;
	var select 	= document.getElementById( "selectNav" );
	var navDiv	= document.getElementById( "nav" );
	var preload_image_object = new Image();
	var totalClusters = 0;
	// Loop through all of the stacks
	for (var x in $images){
		totalClusters++;
		// Create an optoin in the drop down:
		option = document.createElement("option");
		option.innerHTML = x;
		select.appendChild(option);

		var i = 0;
	    var len = $images[x].length;

		// Create the <ul> element : 
		ul = document.createElement("ul")
		ul.setAttribute("class", "hidden");
		ul.setAttribute("id", x);
		navDiv.appendChild( ul );

		// Create the child <li> elements:
		var count = 1;
		var defaultImage = null;
		for( var i in $images[x] ){
			if (!defaultImage)
				defaultImage = i;
				
			li = document.createElement( "li" );
			li.setAttribute("id", i);
			li.setAttribute("onclick", "displayImage('" + i + "')");
			
			li.innerHTML = (!useLabels)? count++ : i;
			
			ul.appendChild( li );

			// Create reference:
			imageDictionary[i] = $images[x][i];

			// Preload the images
			if (document.images)
	    		preload_image_object.src = $images[x][i][0];
		}
		
		defaultItems[x] = defaultImage;
		if (!firstItem)
			firstItem = x;
	}
	
	showNavById( firstItem );
	
	// If there is only one cluster, we don't need the drop down; therefore hide the drop down
	if (totalClusters == 1){
		select.className = "hidden";
		
		// If there is only one slide, hide the buttons
		if (count == 2) 
			ul.className = "hidden"
	}
		
	
}
