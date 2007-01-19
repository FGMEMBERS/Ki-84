# Mitsubishi A6M2 model 21 
var force = 1.0;
var alt_m = 0.0;
var fdm_ok = 0;
toggle_canopy = func{
}

#set_local_sec = func {
#  hour = getprop("/instrumentation/clock/indicated-hour") + 1;
#  min =  getprop("/instrumentation/clock/indicated-min") + 1;
#  sec = getprop("/instrumentation/clock/indicated-sec[0]") - hour * 3600 - min * 60;
#  setprop("/instrumentation/clock/local-sec", getprop("/instrumentation/clock/local-hour[0]") * 3600 + min * 60 + sec);
#  setprop("/instrumentation/clock/local-min-sec", min * 60 + sec);
#}

setlistener("/sim/signals/fdm-initialized", func {
   setprop("/instrumentation/altimeter/indicated-altitude-m",0.0);
   setprop("/engines/engine/cyl-temp",0.0);
   fdm_ok=1;
});

updates = func{
  setprop("/instrumentation/altimeter/indicated-altitude-m",getprop("/instrumentation/altimeter/indicated-altitude-ft") * 0.3048);
    if(getprop("/engines/engine/running") != 0){
    interpolate("/engines/engine/cyl-temp", 0.5 + (getprop("/controls/engines/engine/throttle")* 0.5), 150);
    }else{
    interpolate("/engines/engine/cyl-temp", 0.0, 500);
    }

   force = getprop("/accelerations/pilot-g");
   if(force == nil) {force = 1.0;}
   eyepoint = getprop("sim/view/config/y-offset-m") +0.01;
   eyepoint -= (force * 0.01);
   if(getprop("/sim/current-view/view-number") < 1){
      setprop("/sim/current-view/y-offset-m",eyepoint);
      }
  registerTimer();    
   }


registerTimer = func {
    settimer(updates, 0);
}

setlistener("/controls/canopy/opened", func {
    var position = cmdarg().getValue();
    interpolate("/controls/canopy/position-norm", position, 2);},1);

registerTimer();
