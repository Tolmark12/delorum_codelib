/**
 * addTween API:
 * 
 * property: the css property that you want to tween (required)
 * transition: the transition algorithm to use
 * value: the ending value of the property you are tweening (required)
 * time: amount of time to tween in seconds
 * suffix: the suffixe to tack on the end (optional)
 * 
 */
Element.Methods.addTween = function(element, data){
	var property = data['property'];
	var easing = (!data['transition']) ? Tween.regularEaseIn : Tween[data['transition']];
	var start = (element.style[property] != "") ? parseInt(element.style[property]) : element.style[property];
	var end = data['value'];
	var duration = (!data['time'])? 1 : data['time'];
	var suffixe = data['suffixe'];
	var t = new Tween(element.style,property,easing,start,end,duration,suffixe);
	t.start();
}

Element.addMethods();

//-------------- Add JsTween ----------------------//

/**********************************************************************
TERMS OF USE - EASING EQUATIONS
Open source under the BSD License.
Copyright (c) 2001 Robert Penner
JavaScript version copyright (C) 2006 by Philippe Maegerman
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

   * Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above
copyright notice, this list of conditions and the following disclaimer
in the documentation and/or other materials provided with the
distribution.
   * Neither the name of the author nor the names of contributors may
be used to endorse or promote products derived from this software
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*****************************************/
function Delegate() {}
Delegate.create = function (o, f) {
	var a = new Array() ;
	var l = arguments.length ;
	for(var i = 2 ; i < l ; i++) a[i - 2] = arguments[i] ;
	return function() {
		var aP = [].concat(arguments, a) ;
		f.apply(o, aP);
	}
}

Tween = function(obj, prop, func, begin, finish, duration, suffixe){
	this.init(obj, prop, func, begin, finish, duration, suffixe);
}
var t = Tween.prototype;

t.obj = new Object();
t.prop='';
t.func = function (t, b, c, d) { return c*t/d + b; };
t.begin = 0;
t.change = 0;
t.prevTime = 0;
t.prevPos = 0;
t.looping = false;
t._duration = 0;
t._time = 0;
t._pos = 0;
t._position = 0;
t._startTime = 0;
t._finish = 0;
t.name = '';
t.suffixe = '';
t._listeners = new Array();	
t.setTime = function(t){
	this.prevTime = this._time;
	if (t > this.getDuration()) {
		if (this.looping) {
			this.rewind (t - this._duration);
			this.update();
			this.broadcastMessage('onMotionLooped',{target:this,type:'onMotionLooped'});
		} else {
			this._time = this._duration;
			this.update();
			this.stop();
			this.broadcastMessage('onMotionFinished',{target:this,type:'onMotionFinished'});
		}
	} else if (t < 0) {
		this.rewind();
		this.update();
	} else {
		this._time = t;
		this.update();
	}
}
t.getTime = function(){
	return this._time;
}
t.setDuration = function(d){
	this._duration = (d == null || d <= 0) ? 100000 : d;
}
t.getDuration = function(){
	return this._duration;
}
t.setPosition = function(p){
	this.prevPos = this._pos;
	var a = this.suffixe != '' ? this.suffixe : '';
	this.obj[this.prop] = Math.round(p) + a;
	this._pos = p;
	this.broadcastMessage('onMotionChanged',{target:this,type:'onMotionChanged'});
}
t.getPosition = function(t){
	if (t == undefined) t = this._time;
	return this.func(t, this.begin, this.change, this._duration);
};
t.setFinish = function(f){
	this.change = f - this.begin;
};
t.geFinish = function(){
	return this.begin + this.change;
};
t.init = function(obj, prop, func, begin, finish, duration, suffixe){
	if (!arguments.length) return;
	this._listeners = new Array();
	this.addListener(this);
	if(suffixe) this.suffixe = suffixe;
	this.obj = obj;
	this.prop = prop;
	this.begin = begin;
	this._pos = begin;
	this.setDuration(duration);
	if (func!=null && func!='') {
		this.func = func;
	}
	this.setFinish(finish);
}
t.start = function(){
	this.rewind();
	this.startEnterFrame();
	this.broadcastMessage('onMotionStarted',{target:this,type:'onMotionStarted'});
}
t.rewind = function(t){
	this.stop();
	this._time = (t == undefined) ? 0 : t;
	this.fixTime();
	this.update();
}
t.fforward = function(){
	this._time = this._duration;
	this.fixTime();
	this.update();
}
t.update = function(){
	this.setPosition(this.getPosition(this._time));
	}
t.startEnterFrame = function(){
	this.stopEnterFrame();
	this.isPlaying = true;
	this.onEnterFrame();
}
t.onEnterFrame = function(){
	if(this.isPlaying) {
		this.nextFrame();
		setTimeout(Delegate.create(this, this.onEnterFrame), 0);
	}
}
t.nextFrame = function(){
	this.setTime((this.getTimer() - this._startTime) / 1000);
	}
t.stop = function(){
	this.stopEnterFrame();
	this.broadcastMessage('onMotionStopped',{target:this,type:'onMotionStopped'});
}
t.stopEnterFrame = function(){
	this.isPlaying = false;
}

t.continueTo = function(finish, duration){
	this.begin = this._pos;
	this.setFinish(finish);
	if (this._duration != undefined)
		this.setDuration(duration);
	this.start();
}
t.resume = function(){
	this.fixTime();
	this.startEnterFrame();
	this.broadcastMessage('onMotionResumed',{target:this,type:'onMotionResumed'});
}
t.yoyo = function (){
	this.continueTo(this.begin,this._time);
}

t.addListener = function(o){
	this.removeListener (o);
	return this._listeners.push(o);
}
t.removeListener = function(o){
	var a = this._listeners;	
	var i = a.length;
	while (i--) {
		if (a[i] == o) {
			a.splice (i, 1);
			return true;
		}
	}
	return false;
}
t.broadcastMessage = function(){
	var arr = new Array();
	for(var i = 0; i < arguments.length; i++){
		arr.push(arguments[i]);
	}
	var e = arr.shift();
	var a = this._listeners;
	var l = a.length;
	for (var i=0; i<l; i++){
		if(a[i][e])
		a[i][e].apply(a[i], arr);
	}
}
t.fixTime = function(){
	this._startTime = this.getTimer() - this._time * 1000;
}
t.getTimer = function(){
	return new Date().getTime() - this._time;
}

Tween.regularEaseIn = function(t,b,c,d){
	return c*(t/=d)*t + b;
	}
Tween.regularEaseOut = function(t,b,c,d){
	return -c *(t/=d)*(t-2) + b;
	}

Tween.regularEaseInOut = function(t,b,c,d){
	if ((t/=d/2) < 1) return c/2*t*t + b;
	return -c/2 * ((--t)*(t-2) - 1) + b;
	}
Tween.strongEaseIn = function(t,b,c,d){
	return c*(t/=d)*t*t*t*t + b;
	}
Tween.strongEaseOut = function(t,b,c,d){
	return c*((t=t/d-1)*t*t*t*t + 1) + b;
	}

Tween.strongEaseInOut = function(t,b,c,d){
	if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
	return c/2*((t-=2)*t*t*t*t + 2) + b;
	}

Tween.easeInQuad = function (t, b, c, d) {
		return c*(t/=d)*t + b;
	}
	
Tween.easeOutQuad = function (t, b, c, d) {
		return -c *(t/=d)*(t-2) + b;
	}
	
Tween.easeInOutQuad = function (t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t + b;
		return -c/2 * ((--t)*(t-2) - 1) + b;
	}
Tween.easeInCubic = function (t, b, c, d) {
		return c*(t/=d)*t*t + b;
	}
	
Tween.easeOutCubic = function (t, b, c, d) {
		return c*((t=t/d-1)*t*t + 1) + b;
	}
	
Tween.easeInOutCubic = function (t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t + b;
		return c/2*((t-=2)*t*t + 2) + b;
	}
	
Tween.easeInQuart = function (t, b, c, d) {
		return c*(t/=d)*t*t*t + b;
	}
	
Tween.easeOutQuart = function (t, b, c, d) {
		return -c * ((t=t/d-1)*t*t*t - 1) + b;
	}
	
Tween.easeInOutQuart = function (t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
		return -c/2 * ((t-=2)*t*t*t - 2) + b;
	}
	
Tween.easeInQuint = function (t, b, c, d) {
		return c*(t/=d)*t*t*t*t + b;
	}
	
Tween.easeOutQuint = function (t, b, c, d) {
		return c*((t=t/d-1)*t*t*t*t + 1) + b;
	}
	
Tween.easeInOutQuint = function (t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
		return c/2*((t-=2)*t*t*t*t + 2) + b;
	}
	
Tween.easeInSine = function (t, b, c, d) {
		return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
	}
	
Tween.easeOutSine = function (t, b, c, d) {
		return c * Math.sin(t/d * (Math.PI/2)) + b;
	}
	
Tween.easeInOutSine = function (t, b, c, d) {
		return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
	}
	
Tween.easeInExpo = function (t, b, c, d) {
		return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
	}
	
Tween.easeOutExpo = function (t, b, c, d) {
		return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
	}
	
Tween.easeInOutExpo = function (t, b, c, d) {
		if (t==0) return b;
		if (t==d) return b+c;
		if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
		return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
	}
	
Tween.easeInCirc = function (t, b, c, d) {
		return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
	}
	
Tween.easeOutCirc = function (t, b, c, d) {
		return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
	}
	
Tween.easeInOutCirc = function (t, b, c, d) {
		if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
		return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
	}
	
Tween.easeInElastic = function (t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
	}
	
Tween.easeOutElastic = function (t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b;
	}
	
Tween.easeInOutElastic = function (t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
	}
	
Tween.easeInBack = function (t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		return c*(t/=d)*t*((s+1)*t - s) + b;
	}
	
Tween.easeOutBack = function (t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	}
	
Tween.easeInOutBack = function (t, b, c, d, s) {
		if (s == undefined) s = 1.70158; 
		if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
	}
	
Tween.easeInBounce = function (t, b, c, d) {
		return c - Tween.easeOutBounce (x, d-t, 0, c, d) + b;
	}
	
Tween.easeOutBounce = function (t, b, c, d) {
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	}
	
Tween.easeInOutBounce = function (t, b, c, d) {
		if (t < d/2) return Tween.easeInBounce (x, t*2, 0, c, d) * .5 + b;
		return Tween.easeOutBounce (x, t*2-d, 0, c, d) * .5 + c*.5 + b;
	}
