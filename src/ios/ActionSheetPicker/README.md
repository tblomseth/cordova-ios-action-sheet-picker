# ActionSheetPicker = UIPickerView + UIActionSheet #
Well, that's how it started. Now, the following is more accurate: 

 * _**iPhone/iPod** ActionSheetPicker = ActionSheetPicker = A Picker + UIActionSheet_
 * _**iPad** ActionSheetPicker = A Picker + UIPopoverController_

Forked from [Tim Cinel](http://github.com/TimCinel).
Applies bugfixes and added some features needed in our solution. At the time of writing:
 * Add duration picker
 * Size string picker based on approximate textlength
 * Adding blocks support for date completion handler
 * Fix placing of popovers from origin
 * Cleanup code from a modern Objective-C perspective

## Overview ##
ActionSheetPicker
https://github.com/TimCinel/ActionSheetPicker

Easily present an ActionSheet with a PickerView, allowing user to select from a number of immutible options. Based on the HTML drop-down alternative found in mobilesafari.

Improvements more than welcome - they are kindly requested :)


## Benefits ##

 * Spawn pickers with convenience function - delegate or reference
   not required. Just provide a target/action callback.
 * Add buttons to UIToolbar for quick selection (see ActionSheetDatePicker below)
 * Delegate protocol available for more control
 * Universal (iPhone/iPod/iPad)


## Screen Shots ##

![ActionSheetPicker](http://i.imgur.com/TtkuG.png "ActionSheetPicker")
![ActionSheetDatePicker](http://i.imgur.com/IFDmw.png "ActionSheetDatePicker")
![ActionSheetDistancePicker](http://i.imgur.com/bkWvA.png "ActionSheetDistancePicker")
![iPad Support](http://i.imgur.com/Xu4wb.png "iPad Support")


## Credits ##

Thanks to all of the contributors for making ActionSheetPicker better for the iOS developer community. See AUTHORS for details.


### Contributors ###
[Michel Bouwmans](http://github.com/maruno)

[Filote Stefan](http://github.com/sfilo)

[Brett Gibson](http://github.com/brettg)

[John Garland](http://github.com/johnnyg) (iPad!)

[Mark van den Broek](http://github.com/heyhoo)

[Evan Cordell](http://github.com/ecordell)

[Greg Combs](http://github.com/grgcombs) (Refactor!)


### Creator ###

[Tim Cinel](http://github.com/TimCinel)

[@TimCinel](http://twitter.com/TimCinel)

[timcinel.com/](http://www.timcinel.com/)
