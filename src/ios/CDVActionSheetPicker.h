/********* CDVActionSheetPicker.h Cordova Plugin Header *******/

#import <Cordova/CDV.h>

@interface CDVActionSheetPicker : CDVPlugin

#pragma mark - Properties

@property (nonatomic, copy) NSString* callbackId;
@property (nonatomic, retain) NSDateFormatter* isoDateTimeFormatter;

#pragma mark - Instance methods

- (void)showDateAndTimePicker:(CDVInvokedUrlCommand*)command;

@end