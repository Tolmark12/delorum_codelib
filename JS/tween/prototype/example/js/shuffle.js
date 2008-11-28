window.onload = init;

function init()
{
	Shuffle.setElementCount();
	Shuffle.setContentWidth();
}

Shuffle = {
	elementCount: 0,
	
	currentLeftPosition: 0,
	
	currentElement: 1,
	
	setElementCount: function()
	{
		Shuffle.elementCount = $$('.section').length;
	},
	
	setContentWidth: function()
	{
		$('content').style.width = (Shuffle.elementCount + 1) * 750;
	},
	
	left: function()
	{
		var left;
		if (Shuffle.currentElement == 1){
			left = -(750 * (Shuffle.elementCount -1));
			Shuffle.currentElement = Shuffle.elementCount;
		}
		else {
			left =  -(750 * (Shuffle.currentElement -2));
			Shuffle.currentElement = Shuffle.currentElement -1;
		}
		$('content').addTween({property: 'marginLeft', value: left, transition: 'easeOutExpo', time: .5});
	},
	
	right: function()
	{
		var left;
		if (Shuffle.currentElement == Shuffle.elementCount){
			left = 0;
			Shuffle.currentElement = 1;
		}
		else {
			left =  -(750 * Shuffle.currentElement);
			Shuffle.currentElement++;
		}
		$('content').addTween({property: 'marginLeft', value: left, transition: 'easeOutExpo', time: .5});
	}
}