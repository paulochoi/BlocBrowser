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
//@property (nonatomic, strong) NSArray *buttons;
//@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;

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

        //NSMutableArray *labelsArray = [NSMutableArray new];
        
        NSMutableArray *buttonsArray = [NSMutableArray new];
        
        for (NSString *currentTitle in self.currentTitles) {
            
            UIButton *button = [UIButton new];
            button.alpha = 0.70;
            
            
            
//            UILabel *label = [UILabel new];
//            label.userInteractionEnabled = NO;
//            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            //button.titleLabel.text = titleForThisLabel;
            [button setTitle:titleForThisLabel forState:UIControlStateNormal];
            [button setBackgroundColor:colorForThisLabel];
            //button.backgroundColor = colorForThisLabel;
                        
            button.titleLabel.textColor = [UIColor whiteColor];
            
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:10];
//            label.text = titleForThisLabel;
//            label.backgroundColor = colorForThisLabel;
//            label.textColor = [UIColor whiteColor];
//            
            [buttonsArray addObject:button];
            
            //NSLog(@"%@", label);
        }
        
        //self.labels = labelsArray;
        self.buttons = buttonsArray;
        
        for (UIButton *thisButton in self.buttons){
            [self addSubview:thisButton];
            [thisButton addTarget:self action:@selector(tapFired:) forControlEvents:UIControlEventTouchUpInside];
        }
        
//        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(tapFired:)];
//        [self addGestureRecognizer:self.tapGesture];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action: @selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action: @selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        
        self.longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longGesture];
        
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"========Layout Sub Views being called");
    
    for (UIButton *thisButton in self.buttons) {
        NSUInteger currentLabelIndex = [self.buttons indexOfObject:thisButton];
        
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
        
        thisButton.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);

    }
    
}

#pragma mark - Touch Handling

//- (UIButton *) labelFromTouches: (NSSet *) touches withEvent: (UIEvent *) event {
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
//    UIView *subview = [self hitTest:location withEvent:event];
//    
//    if ([subview isKindOfClass:[UIButton class]]) {
//        return (UIButton *) subview;
//    } else {
//        return nil;
//    }
//}


- (NSString *) labelFromTouches: (NSSet *) touches withEvent: (UIEvent *) event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    
    if ([subview isKindOfClass:[UIButton class]]) {
        return (NSString *) subview;
    } else {
        return nil;
    }
}



- (void) tapFired:(UIButton *) target{
    
    if ([self.delegate respondsToSelector:@selector(floatingToolbar:didPressButtonWithButton:)]) {
        [self.delegate floatingToolbar:self didPressButtonWithButton:target];
    }
    
}

- (void) panFired: (UIPanGestureRecognizer *) recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {

        CGPoint translation = [recognizer translationInView:self];
        
        //[self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]){
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        } else {
            
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }

}

- (void) pinchFired: (UIPinchGestureRecognizer *) recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        

        CGFloat scale = recognizer.scale;
        NSLog(@"scale is %f", scale);
//        CGFloat height = self.bounds.size.height;
//        CGFloat width = self.bounds.size.width;
//        
//        CGRect rect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToZoomWithScale:)]){
            [self.delegate floatingToolbar:self didTryToZoomWithScale:scale];
        }
        
    }
}

- (void) longPressFired: (UILongPressGestureRecognizer *) recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"recognized");
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didPressLongPress:)]) {
            [self.delegate floatingToolbar:self didPressLongPress:YES];
        }
    }
}

#pragma mark - Button Enabling
- (void) setEnabled:(BOOL)enabled fourButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    //NSLog(@"Calling from setEnabled %@",title);
    
    if (index != NSNotFound) {
        UIButton *button = [self.buttons objectAtIndex:index];
        button.userInteractionEnabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
    }
}


@end
