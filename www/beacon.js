
var exec = require('cordova/exec');
               
exports.custom = function (){
    alert('Custom');
               
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