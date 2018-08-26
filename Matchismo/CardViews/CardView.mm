// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import <UIKit/UIKit.h>

#import "CardView.h"
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CardView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor {
  return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius {
  return CORNER_RADIUS * [self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}

- (void)drawCardWithColoredBackground:(UIColor *)color {
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:[self cornerRadius]];
  [self pushContext];
  [roundedRect addClip];
  [color setFill];
  UIRectFill(self.bounds);
  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
  [self popContext];
}

- (void)pushContext {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
}

- (void)popContext {
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  return self;
}

- (void)flipCard {
  return;
}

- (void)initializeCardView:(Card *)card {
  return;
}
@end

NS_ASSUME_NONNULL_END
