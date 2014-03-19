var exec = require("cordova/exec");

var ActionSheetPicker = function() {
    this.cdvServiceName = 'ActionSheetPicker';
};

ActionSheetPicker.prototype.showDateAndTimePicker = function ( successCallback, failureCallback, options ) {
    var defaults = {
        title: '',
        selectedDate: '',
        minimumDate: '',
        maximumDate: ''
    };

    for ( var key in defaults ) {
        if ( !options.hasOwnProperty( key ) ) {
            options[ key ] = defaults[ key ]
        } else if ( options[ key ] == null ) {
            options[ key ] = defaults[ key ];
        } else if ( options[ key ] instanceof Date ) {
            options[ key ] = options[ key ].toISOString();
        }
    }

    cordova.exec(
        successCallback,
        failureCallback,
        this.cdvServiceName,
        "showDateAndTimePicker",
        [ options ]
    );
};

module.exports = new ActionSheetPicker();