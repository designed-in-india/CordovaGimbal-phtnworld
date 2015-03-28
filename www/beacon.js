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
               
exports.copyGimbalFiles = function (){
cordova.exec(
            function callback(data) {
            
            },
            function errorHandler(err) {
            alert('Error');
            },
            'Beacon',
            'copyFileFromBundle',
            [  ]
            );
}
