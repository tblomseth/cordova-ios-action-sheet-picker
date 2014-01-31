//
//Copyright (c) 2014, Michel Bouwmans
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

#import "ActionSheetDurationPicker.h"
#import <objc/message.h>

@interface ActionSheetDurationPicker ()

@property (nonatomic) NSTimeInterval selectedInterval;

@property (nonatomic, copy) ActionDurationDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionDurationCancelBlock onActionSheetCancel;

@end

@implementation ActionSheetDurationPicker
#pragma mark - Lifecycle
+ (id)showPickerWithTitle:(NSString *)title startInterval:(NSTimeInterval)startInterval doneBlock:(ActionDurationDoneBlock)doneBlock cancelBlock:(ActionDurationCancelBlock)cancelBlock origin:(id)origin {
    ActionSheetDurationPicker* picker = [[ActionSheetDurationPicker alloc] initWithTitle:title startInterval:startInterval doneBlock:doneBlock cancelBlock:cancelBlock origin:origin];
    [picker showActionSheetPicker];

    return picker;
}

- (id)initWithTitle:(NSString *)title startInterval:(NSTimeInterval)startInterval doneBlock:(ActionDurationDoneBlock)doneBlock cancelBlock:(ActionDurationCancelBlock)cancelBlock origin:(id)origin {
    self = [self initWithTitle:title startInterval:startInterval target:nil succesAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlock;
    }

    return self;
}

+ (id)showPickerWithTitle:(NSString *)title startInterval:(NSTimeInterval)startInterval target:(id)target succesAction:(SEL)successAction cancelAction:(SEL)cancelAction origin:(id)origin {
    ActionSheetDurationPicker* picker = [[ActionSheetDurationPicker alloc] initWithTitle:title startInterval:startInterval target:target succesAction:successAction cancelAction:cancelAction origin:origin];
    [picker showActionSheetPicker];

    return picker;
}

- (id)initWithTitle:(NSString *)title startInterval:(NSTimeInterval)startInterval target:(id)target succesAction:(SEL)successAction cancelAction:(SEL)cancelAction origin:(id)origin {
    self = [super initWithTarget:target successAction:successAction cancelAction:cancelAction origin:origin];
    if (self) {
        self.title = title;
        self.selectedInterval = startInterval;
    }

    return self;
}

- (UIView *)configuredPickerView {
    CGRect datePickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    datePicker.countDownDuration = self.selectedInterval;
    [datePicker addTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];

    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing (not used in this picker, but just in case somebody uses this as a template for another picker)
    self.pickerView = datePicker;

    return datePicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)action origin:(id)origin {
    if (self.onActionSheetDone) {
        self.onActionSheetDone(self, self.selectedInterval);
    } else if ([target respondsToSelector:action]) {
        objc_msgSend(target, action, self.selectedInterval, origin);
    } else {
        NSAssert(NO, @"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), sel_getName(action));
    }
}

- (void)eventForDatePicker:(id)sender {
    if (!sender || ![sender isKindOfClass:[UIDatePicker class]]) return;
    UIDatePicker* datePicker = (UIDatePicker *)sender;
    self.selectedInterval = datePicker.countDownDuration;
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
