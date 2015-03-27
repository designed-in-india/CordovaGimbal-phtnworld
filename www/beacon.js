cordova.define("de.appplant.cordova.plugin.beacon.Beacon", function(require, exports, module) { 
var exec = require('cordova/exec');
               
exports.custom = function (){
   cordova.exec(
            function callback(data) {

            },
            function errorHandler(err) {
            alert('Error');
            },
            'Beacon',
            'open',
            [  ]
            );
               
}
               
exports.initializeBeacon = function (){
cordova.exec(
            function callback(data) {
            
            },
            function errorHandler(err) {
            alert('Error');
            },
            'Beacon',
            'initializeBeacon',
            [  ]
            );
}
});
