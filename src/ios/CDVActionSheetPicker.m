/********* CDVActionSheetPicker.m Cordova Plugin Implementation *******/

#import "CDVActionSheetPicker.h"
#import <Cordova/CDV.h>
#import "ActionSheetDatePicker.h"

@implementation CDVActionSheetPicker

@synthesize webView;
@synthesize callbackId = _callbackId;
@synthesize isoDateTimeFormatter = _isoDateTimeFormatter;

- (void)pluginInitialize
{
  NSDateFormatter *isoDateTimeFormatter = [[ NSDateFormatter alloc ] init ];
  [ isoDateTimeFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC" ]];
  [ isoDateTimeFormatter setDateFormat: @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'" ];
  self.isoDateTimeFormatter = isoDateTimeFormatter;
}

#pragma mark - Public methods

- (void)showDateAndTimePicker:(CDVInvokedUrlCommand *)command
{
  self.callbackId = command.callbackId;
  
	NSDictionary *options = [command.arguments objectAtIndex:0];
  NSString *title = [ options objectForKey:@"title" ] ?: @"";
	NSString *selectedDateStr = [ options objectForKey:@"selectedDate" ] ?: @"";
	NSString *minimumDateStr = [ options objectForKey:@"minimumDate" ] ?: @"";
  NSString *maximumDateStr = [ options objectForKey:@"maximumDate" ] ?: @"";

  // Initialize picker
  ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:title
                                                                datePickerMode:UIDatePickerModeDateAndTime
                                                                  selectedDate:[ selectedDateStr length ] != 0 ? [ self.isoDateTimeFormatter dateFromString:selectedDateStr ] : [ NSDate date ]
                                                                        target:self
                                                                        action:@selector(dateAndTimeWasSelected:element:)
                                                                        origin:self.webView
                                                                  cancelAction:@selector(actionPickerCancelled:sender:)];
  
  // Set date constraints
  picker.minimumDate = [ minimumDateStr length ] != 0 ? [ self.isoDateTimeFormatter dateFromString:minimumDateStr ] : nil;
  picker.maximumDate = [ maximumDateStr length ] != 0 ? [ self.isoDateTimeFormatter dateFromString:maximumDateStr ] : nil;
  
  // Have picker shown
  [picker showActionSheetPicker];
  
}

#pragma mark - Private methods

-(void)dateAndTimeWasSelected:(NSDate *)selectedDateAndTime element:(id)element {
    // Strip selected date to minute precision
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    NSDateComponents *components = [ calendar components:flags fromDate:selectedDateAndTime ];
    selectedDateAndTime = [ calendar dateFromComponents:components ];
    
    // Generate UNIX/POSIX timestamp
    NSString *unixTimeStampInMillisStr = [[ NSNumber numberWithDouble:[ selectedDateAndTime timeIntervalSince1970 ] * 1000 ] stringValue ];
    
    // Generate result
    NSDictionary *result = [ NSDictionary dictionaryWithObjectsAndKeys:@"dateSelected", @"status", unixTimeStampInMillisStr, @"value", nil ];
    
    // Call back to CDV
    CDVPluginResult *pluginResult = [ CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result ];
    [ self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId ];	
}

- (void)actionPickerCancelled:(id)sender {
  NSDictionary *result = [ NSDictionary dictionaryWithObjectsAndKeys:@"selectionCanceled", @"status", @"", @"value", nil ];
  
  // Call back to CDV
  CDVPluginResult *pluginResult = [ CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result ];
  [ self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId ];
}

@end