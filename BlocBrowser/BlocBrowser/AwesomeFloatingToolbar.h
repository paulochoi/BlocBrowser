//
//  AwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Paulo Choi on 6/22/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwesomeFloatingToolbar;

@protocol AwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonwithTitle:(NSString *)title;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToZoomWithScale:(CGFloat)scale;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didPressLongPress:(BOOL)pressed;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didPressButtonWithButton:(UIButton *)button;

@end

@interface AwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) setEnabled:(BOOL)enabled fourButtonWithTitle:(NSString *)title;
- (UIButton *) labelFromTouches: (NSSet *) touches withEvent: (UIEvent *) event;
@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;
@property (nonatomic, strong) NSArray *buttons;

@end
