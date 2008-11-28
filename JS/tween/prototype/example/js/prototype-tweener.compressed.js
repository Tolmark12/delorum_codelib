Element.Methods.addTween=function(_1,_2){var _3=_2["property"];var _4=(!_2["transition"])?Tween.regularEaseIn:Tween[_2["transition"]];var _5=(_1.style[_3]!="")?parseInt(_1.style[_3]):_1.style[_3];var _6=_2["value"];var _7=(!_2["time"])?1:_2["time"];var _8=_2["suffixe"];var t=new Tween(_1.style,_3,_4,_5,_6,_7,_8);t.start();};Element.addMethods();function Delegate(){}Delegate.create=function(o,f){var a=new Array();var l=arguments.length;for(var i=2;i<l;i++){a[i-2]=arguments[i];}return function(){var aP=[].concat(arguments,a);f.apply(o,aP);};};Tween=function(obj,_11,_12,_13,_14,_15,_16){this.init(obj,_11,_12,_13,_14,_15,_16);};var t=Tween.prototype;t.obj=new Object();t.prop="";t.func=function(t,b,c,d){return c*t/d+b;};t.begin=0;t.change=0;t.prevTime=0;t.prevPos=0;t.looping=false;t._duration=0;t._time=0;t._pos=0;t._position=0;t._startTime=0;t._finish=0;t.name="";t.suffixe="";t._listeners=new Array();t.setTime=function(t){this.prevTime=this._time;if(t>this.getDuration()){if(this.looping){this.rewind(t-this._duration);this.update();this.broadcastMessage("onMotionLooped",{target:this,type:"onMotionLooped"});}else{this._time=this._duration;this.update();this.stop();this.broadcastMessage("onMotionFinished",{target:this,type:"onMotionFinished"});}}else{if(t<0){this.rewind();this.update();}else{this._time=t;this.update();}}};t.getTime=function(){return this._time;};t.setDuration=function(d){this._duration=(d==null||d<=0)?100000:d;};t.getDuration=function(){return this._duration;};t.setPosition=function(p){this.prevPos=this._pos;var a=this.suffixe!=""?this.suffixe:"";this.obj[this.prop]=Math.round(p)+a;this._pos=p;this.broadcastMessage("onMotionChanged",{target:this,type:"onMotionChanged"});};t.getPosition=function(t){if(t==undefined){t=this._time;}return this.func(t,this.begin,this.change,this._duration);};t.setFinish=function(f){this.change=f-this.begin;};t.geFinish=function(){return this.begin+this.change;};t.init=function(obj,_22,_23,_24,_25,_26,_27){if(!arguments.length){return;}this._listeners=new Array();this.addListener(this);if(_27){this.suffixe=_27;}this.obj=obj;this.prop=_22;this.begin=_24;this._pos=_24;this.setDuration(_26);if(_23!=null&&_23!=""){this.func=_23;}this.setFinish(_25);};t.start=function(){this.rewind();this.startEnterFrame();this.broadcastMessage("onMotionStarted",{target:this,type:"onMotionStarted"});};t.rewind=function(t){this.stop();this._time=(t==undefined)?0:t;this.fixTime();this.update();};t.fforward=function(){this._time=this._duration;this.fixTime();this.update();};t.update=function(){this.setPosition(this.getPosition(this._time));};t.startEnterFrame=function(){this.stopEnterFrame();this.isPlaying=true;this.onEnterFrame();};t.onEnterFrame=function(){if(this.isPlaying){this.nextFrame();setTimeout(Delegate.create(this,this.onEnterFrame),0);}};t.nextFrame=function(){this.setTime((this.getTimer()-this._startTime)/1000);};t.stop=function(){this.stopEnterFrame();this.broadcastMessage("onMotionStopped",{target:this,type:"onMotionStopped"});};t.stopEnterFrame=function(){this.isPlaying=false;};t.continueTo=function(_29,_2a){this.begin=this._pos;this.setFinish(_29);if(this._duration!=undefined){this.setDuration(_2a);}this.start();};t.resume=function(){this.fixTime();this.startEnterFrame();this.broadcastMessage("onMotionResumed",{target:this,type:"onMotionResumed"});};t.yoyo=function(){this.continueTo(this.begin,this._time);};t.addListener=function(o){this.removeListener(o);return this._listeners.push(o);};t.removeListener=function(o){var a=this._listeners;var i=a.length;while(i--){if(a[i]==o){a.splice(i,1);return true;}}return false;};t.broadcastMessage=function(){var arr=new Array();for(var i=0;i<arguments.length;i++){arr.push(arguments[i]);}var e=arr.shift();var a=this._listeners;var l=a.length;for(var i=0;i<l;i++){if(a[i][e]){a[i][e].apply(a[i],arr);}}};t.fixTime=function(){this._startTime=this.getTimer()-this._time*1000;};t.getTimer=function(){return new Date().getTime()-this._time;};Tween.regularEaseIn=function(t,b,c,d){return c*(t/=d)*t+b;};Tween.regularEaseOut=function(t,b,c,d){return -c*(t/=d)*(t-2)+b;};Tween.regularEaseInOut=function(t,b,c,d){if((t/=d/2)<1){return c/2*t*t+b;}return -c/2*((--t)*(t-2)-1)+b;};Tween.strongEaseIn=function(t,b,c,d){return c*(t/=d)*t*t*t*t+b;};Tween.strongEaseOut=function(t,b,c,d){return c*((t=t/d-1)*t*t*t*t+1)+b;};Tween.strongEaseInOut=function(t,b,c,d){if((t/=d/2)<1){return c/2*t*t*t*t*t+b;}return c/2*((t-=2)*t*t*t*t+2)+b;};Tween.easeInQuad=function(t,b,c,d){return c*(t/=d)*t+b;};Tween.easeOutQuad=function(t,b,c,d){return -c*(t/=d)*(t-2)+b;};Tween.easeInOutQuad=function(t,b,c,d){if((t/=d/2)<1){return c/2*t*t+b;}return -c/2*((--t)*(t-2)-1)+b;};Tween.easeInCubic=function(t,b,c,d){return c*(t/=d)*t*t+b;};Tween.easeOutCubic=function(t,b,c,d){return c*((t=t/d-1)*t*t+1)+b;};Tween.easeInOutCubic=function(t,b,c,d){if((t/=d/2)<1){return c/2*t*t*t+b;}return c/2*((t-=2)*t*t+2)+b;};Tween.easeInQuart=function(t,b,c,d){return c*(t/=d)*t*t*t+b;};Tween.easeOutQuart=function(t,b,c,d){return -c*((t=t/d-1)*t*t*t-1)+b;};Tween.easeInOutQuart=function(t,b,c,d){if((t/=d/2)<1){return c/2*t*t*t*t+b;}return -c/2*((t-=2)*t*t*t-2)+b;};Tween.easeInQuint=function(t,b,c,d){return c*(t/=d)*t*t*t*t+b;};Tween.easeOutQuint=function(t,b,c,d){return c*((t=t/d-1)*t*t*t*t+1)+b;};Tween.easeInOutQuint=function(t,b,c,d){if((t/=d/2)<1){return c/2*t*t*t*t*t+b;}return c/2*((t-=2)*t*t*t*t+2)+b;};Tween.easeInSine=function(t,b,c,d){return -c*Math.cos(t/d*(Math.PI/2))+c+b;};Tween.easeOutSine=function(t,b,c,d){return c*Math.sin(t/d*(Math.PI/2))+b;};Tween.easeInOutSine=function(t,b,c,d){return -c/2*(Math.cos(Math.PI*t/d)-1)+b;};Tween.easeInExpo=function(t,b,c,d){return (t==0)?b:c*Math.pow(2,10*(t/d-1))+b;};Tween.easeOutExpo=function(t,b,c,d){return (t==d)?b+c:c*(-Math.pow(2,-10*t/d)+1)+b;};Tween.easeInOutExpo=function(t,b,c,d){if(t==0){return b;}if(t==d){return b+c;}if((t/=d/2)<1){return c/2*Math.pow(2,10*(t-1))+b;}return c/2*(-Math.pow(2,-10*--t)+2)+b;};Tween.easeInCirc=function(t,b,c,d){return -c*(Math.sqrt(1-(t/=d)*t)-1)+b;};Tween.easeOutCirc=function(t,b,c,d){return c*Math.sqrt(1-(t=t/d-1)*t)+b;};Tween.easeInOutCirc=function(t,b,c,d){if((t/=d/2)<1){return -c/2*(Math.sqrt(1-t*t)-1)+b;}return c/2*(Math.sqrt(1-(t-=2)*t)+1)+b;};Tween.easeInElastic=function(t,b,c,d){var s=1.70158;var p=0;var a=c;if(t==0){return b;}if((t/=d)==1){return b+c;}if(!p){p=d*0.3;}if(a<Math.abs(c)){a=c;var s=p/4;}else{var s=p/(2*Math.PI)*Math.asin(c/a);}return -(a*Math.pow(2,10*(t-=1))*Math.sin((t*d-s)*(2*Math.PI)/p))+b;};Tween.easeOutElastic=function(t,b,c,d){var s=1.70158;var p=0;var a=c;if(t==0){return b;}if((t/=d)==1){return b+c;}if(!p){p=d*0.3;}if(a<Math.abs(c)){a=c;var s=p/4;}else{var s=p/(2*Math.PI)*Math.asin(c/a);}return a*Math.pow(2,-10*t)*Math.sin((t*d-s)*(2*Math.PI)/p)+c+b;};Tween.easeInOutElastic=function(t,b,c,d){var s=1.70158;var p=0;var a=c;if(t==0){return b;}if((t/=d/2)==2){return b+c;}if(!p){p=d*(0.3*1.5);}if(a<Math.abs(c)){a=c;var s=p/4;}else{var s=p/(2*Math.PI)*Math.asin(c/a);}if(t<1){return -0.5*(a*Math.pow(2,10*(t-=1))*Math.sin((t*d-s)*(2*Math.PI)/p))+b;}return a*Math.pow(2,-10*(t-=1))*Math.sin((t*d-s)*(2*Math.PI)/p)*0.5+c+b;};Tween.easeInBack=function(t,b,c,d,s){if(s==undefined){s=1.70158;}return c*(t/=d)*t*((s+1)*t-s)+b;};Tween.easeOutBack=function(t,b,c,d,s){if(s==undefined){s=1.70158;}return c*((t=t/d-1)*t*((s+1)*t+s)+1)+b;};Tween.easeInOutBack=function(t,b,c,d,s){if(s==undefined){s=1.70158;}if((t/=d/2)<1){return c/2*(t*t*(((s*=(1.525))+1)*t-s))+b;}return c/2*((t-=2)*t*(((s*=(1.525))+1)*t+s)+2)+b;};Tween.easeInBounce=function(t,b,c,d){return c-Tween.easeOutBounce(x,d-t,0,c,d)+b;};Tween.easeOutBounce=function(t,b,c,d){if((t/=d)<(1/2.75)){return c*(7.5625*t*t)+b;}else{if(t<(2/2.75)){return c*(7.5625*(t-=(1.5/2.75))*t+0.75)+b;}else{if(t<(2.5/2.75)){return c*(7.5625*(t-=(2.25/2.75))*t+0.9375)+b;}else{return c*(7.5625*(t-=(2.625/2.75))*t+0.984375)+b;}}}};Tween.easeInOutBounce=function(t,b,c,d){if(t<d/2){return Tween.easeInBounce(x,t*2,0,c,d)*0.5+b;}return Tween.easeOutBounce(x,t*2-d,0,c,d)*0.5+c*0.5+b;};