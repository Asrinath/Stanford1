//
//  CalculatorViewController.m
//  Stanford1
//
//  Created by Aditya Srinath on 3/1/12.
//  Copyright (c) 2012 Firefly Logic. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL decimalEnteredOnceOrMore;
@property (nonatomic, strong) CalculatorBrain *brain;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)enterPressed;
- (IBAction)switchSignPressed;
- (IBAction)backspacePressed;
- (IBAction)clearPressed;
- (void)deleteEqualSign;

@end


@implementation CalculatorViewController

@synthesize display = _display;
@synthesize fullDisplay = _fullDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize decimalEnteredOnceOrMore = _decimalEnteredOnceOrMore;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = [sender currentTitle];
    NSLog(@"%@", digit);
    if (self.userIsInTheMiddleOfEnteringANumber && self.decimalEnteredOnceOrMore == NO) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else if (self.userIsInTheMiddleOfEnteringANumber && self.decimalEnteredOnceOrMore == YES) {
        if (![digit isEqualToString:@"."]) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    }
    else if (!self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = digit;
        [self deleteEqualSign];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
    if ([digit isEqualToString:@"."]) self.decimalEnteredOnceOrMore = YES;
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    [self deleteEqualSign];
    NSString *operation = [sender currentTitle];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", operation]];
    double result = [self.brain performOperation:operation];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@"= "];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)enterPressed {
    
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", self.display.text]];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalEnteredOnceOrMore = NO;
}

- (IBAction)switchSignPressed {
    
    if ([self.display.text doubleValue] > 0) {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
    }
    else if ([self.display.text doubleValue] < 0) {
        self.display.text = [self.display.text substringFromIndex:1];
    }
    
    if (!self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
}

- (IBAction)backspacePressed {
    
    if (([self.display.text length] == 3 && [self.display.text doubleValue] < 1 && [self.display.text doubleValue] > -1) ||
        ([self.display.text length] == 2 && [self.display.text doubleValue] < 1) ||
         [self.display.text length] == 1) {
        self.display.text = [NSString stringWithFormat:@"0"];
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.decimalEnteredOnceOrMore = NO;
    }
    else {
        self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
    }
}

- (IBAction)clearPressed {
    
    self.display.text = [NSString stringWithFormat:@"0"];
    self.fullDisplay.text = [NSString stringWithFormat:@""];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalEnteredOnceOrMore = NO;
    [self.brain clearStack];
}

- (void)deleteEqualSign {
    
    self.fullDisplay.text = [self.fullDisplay.text stringByReplacingOccurrencesOfString:@"= " withString:@""];
}

@end
