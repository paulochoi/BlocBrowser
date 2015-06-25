//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Paulo Choi on 6/22/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation AwesomeFloatingToolbar

- (instancetype) initWithFourTitles:(NSArray *)titles {
    self = [super init];
    
    
    NSLog(@"%@",titles);
    
    if (self) {
        self.currentTitles = titles;
        
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];

        NSMutableArray *labelsArray = [NSMutableArray new];
        
        for (NSString *currentTitle in self.currentTitles) {
            UILabel *label = [UILabel new];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorForThisLabel;
            label.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:label];
            
            NSLog(@"%@", label);
        }
        
        self.labels = labelsArray;
        
        for (UILabel *thisLabel in self.labels){
            [self addSubview:thisLabel];
        }
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(tapFired:)];
        [self addGestureRecognizer:self.tapGesture];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action: @selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"========Layout Sub Views being called");
    
    for (UILabel *thisLabel in self.labels) {
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        if (currentLabelIndex < 2) {
            labelY = 0;
        } else {
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentLabelIndex % 2 == 0) {
            labelX = 0;
        } else {
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);


    }
    
}

#pragma mark - Touch Handling

- (UILabel *) labelFromTouches: (NSSet *) touches withEvent: (UIEvent *) event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    
    if ([subview isKindOfClass:[UILabel class]]) {
        return (UILabel *) subview;
    } else {
        return nil;
    }
    
}

- (void) tapFired:(UITapGestureRecognizer *) recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint location = [recognizer locationInView:self];
        UIView *tappedView = [self hitTest:location withEvent:nil];
        
        if ([self.labels containsObject:tappedView]) {
            if([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonwithTitle:)]){
                [self.delegate floatingToolbar:self didSelectButtonwithTitle:((UILabel *)tappedView).text];
            }
        }
        
    }
    
}

- (void) panFired: (UIPanGestureRecognizer *) recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {

        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        NSLog(@"%@",self);
        
        
        //[self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]){
            NSLog(@"responded to delegate");
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        } else {
            NSLog(@"did not respond");
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }

}


#pragma mark - Button Enabling
- (void) setEnabled:(BOOL)enabled fourButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    NSLog(@"Calling from setEnabled %@",title);
    
    if (index != NSNotFound) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    }
}


@end
