# Ki-84 Hayate

var ki84 = JapaneseWarbird.new();
var observers = [Altimeter.new(), BoostGauge.new(), CylinderTemperature.new(), ExhaustGasTemperature.new(35.8)];
foreach (observer; observers) {
    ki84.addObserver(observer);
}
