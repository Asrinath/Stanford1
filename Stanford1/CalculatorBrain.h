//
//  CalculatorBrain.h
//  Stanford1
//
//  Created by Aditya Srinath on 3/2/12.
//  Copyright (c) 2012 Firefly Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearStack;

@end
