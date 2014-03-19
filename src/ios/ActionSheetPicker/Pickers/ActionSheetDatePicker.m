//
//Copyright (c) 2011, Tim Cinel
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//* Redistributions of source code must retain the above copyright
//notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//notice, this list of conditions and the following disclaimer in the
//documentation and/or other materials provided with the distribution.
//* Neither the name of the <organization> nor the
//names of its contributors may be used to endorse or promote products
//derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//


#import "ActionSheetDatePicker.h"
#import <objc/message.h>

@interface ActionSheetDatePicker()

@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic) NSDate *selectedDate;

@property (nonatomic, copy) ActionDateDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionDateCancelBlock onActionSheetCancel;

@end

@implementation ActionSheetDatePicker
#pragma mark - Lifecycle
+ (id)showPickerWithTitle:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate doneBlock:(ActionDateDoneBlock)doneBlock cancelBlock:(ActionDateCancelBlock)cancelBlock origin:(id)origin {
    ActionSheetDatePicker * picker = [[ActionSheetDatePicker alloc] initWithTitle:title datePickerMode:datePickerMode selectedDate:selectedDate doneBlock:doneBlock cancelBlock:cancelBlock origin:origin];
    [picker showActionSheetPicker];

    return picker;
}

- (id)initWithTitle:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate doneBlock:(ActionDateDoneBlock)doneBlock cancelBlock:(ActionDateCancelBlock)cancelBlock origin:(id)origin {
    self = [self initWithTitle:title datePickerMode:datePickerMode selectedDate:selectedDate target:nil action:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlock;
    }

    return self;
}

+ (id)showPickerWithTitle:(NSString *)title 
           datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate                                                                             
                 target:(id)target action:(SEL)action origin:(id)origin {
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:title datePickerMode:datePickerMode selectedDate:selectedDate target:target action:action origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action origin:(id)origin {
    self = [super initWithTarget:target successAction:action cancelAction:nil origin:origin];
    if (self) {
        self.title = title;
        self.datePickerMode = datePickerMode;
        self.selectedDate = selectedDate;
    }
    return self;
}

#pragma mark - Accessors
- (UIView *)configuredPickerView {
    CGRect datePickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    datePicker.datePickerMode = self.datePickerMode;
    datePicker.minimumDate = self.minimumDate;
    datePicker.maximumDate = self.maximumDate;
    datePicker.calendar = self.calendar;
    datePicker.timeZone = self.timeZone;
    datePicker.locale = self.locale;

    [datePicker setDate:self.selectedDate animated:NO];
    [datePicker addTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing (not used in this picker, but just in case somebody uses this as a template for another picker)
    self.pickerView = datePicker;
    
    return datePicker;
}

#pragma mark - Actions
- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)action origin:(id)origin {
    if (self.onActionSheetDone) {
        self.onActionSheetDone(self, self.selectedDate);
    } else if ([target respondsToSelector:action]) {
        objc_msgSend(target, action, self.selectedDate, origin);
    } else {
        NSAssert(NO, @"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), sel_getName(action));
    }
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        self.onActionSheetCancel(self);
    } else {
        [super notifyTarget:target didCancelWithAction:cancelAction origin:origin];
    }
}

- (void)eventForDatePicker:(id)sender {
    if (!sender || ![sender isKindOfClass:[UIDatePicker class]])
        return;
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    self.selectedDate = datePicker.date;
}

- (void)customButtonPressed:(id)sender {
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    NSInteger index = button.tag;
    NSAssert((index >= 0 && index < self.customButtons.count), @"Bad custom button tag: %ld, custom button count: %lu", (long)index, (unsigned long)self.customButtons.count);
    NSAssert([self.pickerView respondsToSelector:@selector(setDate:animated:)], @"Bad pickerView for ActionSheetDatePicker, doesn't respond to setDate:animated:");
    NSDictionary *buttonDetails = [self.customButtons objectAtIndex:index];
    NSDate *itemValue = [buttonDetails objectForKey:@"buttonValue"];
    UIDatePicker *picker = (UIDatePicker *)self.pickerView;    
    [picker setDate:itemValue animated:YES];
    [self eventForDatePicker:picker];
}

@end
