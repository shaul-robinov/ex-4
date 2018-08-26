// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import <UIKit/UIKit.h>

#import "SetCardCreator.h"
#import "SetCard.h"
#import "Deck.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardCreator()

/// Set cards color
@property (strong, nonatomic)UIColor *color;

/// Set cards shape
@property (strong, nonatomic)NSString *shape;

/// Set cards filling
@property (strong, nonatomic)NSNumber *filling;

/// Set cards rank
@property (nonatomic) NSNumber *rank;

@end

@implementation SetCardCreator

static const float kDefaultCardInteriorScaleFactor = 0.9;
static const float kMaxNumOfFramesInCard = 5;
#define SQUIGGLE_CURVE_FACTOR 0.5

- (void)drawSetCardShape:(NSString *)shape ofColor:(UIColor *)color
              andFilling:(NSNumber *)filling ofRank:(NSNumber *)rank
                inBounds:(CGRect)cardBounds{
  self.color = color;
  self.rank = rank;
  self.filling = filling;
  self.shape = shape;
  
  int curShapeIndex = 0;
  do {
    CGRect frame = [self getFrameOfShape:curShapeIndex outOf:[self.rank integerValue] inBounds:cardBounds.size];
    [self drawInFrame:frame withSize:cardBounds.size];
    curShapeIndex += 1;
  } while (curShapeIndex < [self.rank integerValue]);
  return;
}

- (void)drawInFrame:(CGRect)shapeFrame withSize:(CGSize)size  {
  UIBezierPath *path;
  if ([self.shape isEqualToString:@"oval"]) {
    path = [self drawOvalInFrame:shapeFrame];
  } else if ([self.shape isEqualToString:@"diamond"]) {
    path = [self drawDiamondInFrame:shapeFrame];
  } else if ([self.shape isEqualToString:@"squiggle"]) {
    path = [self drawSquiggleInFrame:shapeFrame.origin at:size];
  }
  [self.color set];
  [path stroke];
  [self fillShape: path];
}

- (void)fillShape:(UIBezierPath *)path {
  if ([self.filling isEqualToNumber: @(0)]) {
    [[UIColor whiteColor] setFill];
    [path fill];
  } else if ([self.filling isEqualToNumber: @(1)]) {
    [self.color setFill];
    [path fill];
  } else {
    [[UIColor whiteColor] setFill];
    [path fill];
    [self fillShapeWithLines:path];
  }
}

- (void)fillShapeWithLines:(UIBezierPath *)path {
  CGRect bounds = path.bounds;
  
  // create a UIBezierPath for the fill pattern
  UIBezierPath *stripes = [UIBezierPath bezierPath];
  for ( int x = 0; x < bounds.size.width; x += 5 ){
    [stripes moveToPoint:CGPointMake(bounds.origin.x + x, bounds.origin.y)];
    [stripes addLineToPoint:CGPointMake(bounds.origin.x + x, bounds.origin.y + bounds.size.height)];
  }
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  [path addClip];
  [self.color set];
  [stripes stroke];
  CGContextRestoreGState(context);
}

-(UIBezierPath *)drawOvalInFrame:(CGRect)shapeFrame {
  return [UIBezierPath bezierPathWithRoundedRect:shapeFrame
                                    cornerRadius:shapeFrame.size.height / 2];
}

- (UIBezierPath *)drawDiamondInFrame:(CGRect)shapeFrame {
  UIBezierPath *path = [[UIBezierPath alloc] init];
  CGFloat x = shapeFrame.origin.x;
  CGFloat y = shapeFrame.origin.y;
  CGFloat width = shapeFrame.size.width;
  CGFloat height = shapeFrame.size.height;
  [path moveToPoint:CGPointMake(x + width / 2, y + 0.1 * height)];
  [path addLineToPoint:CGPointMake(x + 0.1 * width, y + height / 2)];
  [path addLineToPoint:CGPointMake(x + width / 2, y + height * 0.9)];
  [path addLineToPoint:CGPointMake(x + width * 0.9 , y + height / 2)];
  [path closePath];
  return path;
}

- (UIBezierPath *)drawSquiggleInFrame:(CGPoint)point at:(CGSize)size
{
  
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(104, 15)];
  [path addCurveToPoint:CGPointMake(63, 54) controlPoint1:CGPointMake(112.4, 36.9) controlPoint2:CGPointMake(89.7, 60.8)];
  [path addCurveToPoint:CGPointMake(27, 53) controlPoint1:CGPointMake(52.3, 51.3) controlPoint2:CGPointMake(42.2, 42)];
  [path addCurveToPoint:CGPointMake(5, 40) controlPoint1:CGPointMake(9.6, 65.6) controlPoint2:CGPointMake(5.4, 58.3)];
  [path addCurveToPoint:CGPointMake(36, 12) controlPoint1:CGPointMake(4.6, 22) controlPoint2:CGPointMake(19.1, 9.7)];
  [path addCurveToPoint:CGPointMake(89, 14) controlPoint1:CGPointMake(59.2, 15.2) controlPoint2:CGPointMake(61.9, 31.5)];
  [path addCurveToPoint:CGPointMake(104, 15) controlPoint1:CGPointMake(95.3, 10) controlPoint2:CGPointMake(100.9, 6.9)];
  
  [path applyTransform:CGAffineTransformMakeScale(0.75 * size.width / 100, 0.2 * size.height / 50)];
  [path applyTransform:CGAffineTransformMakeTranslation(point.x + size.width * 0.04, point.y - size.height * 0.04)];
  
  return path;
}




- (CGRect)getFrameOfShape:(NSUInteger)index outOf:(NSUInteger)totalNumberOfShapes
                 inBounds:(CGSize)size {
  CGFloat heightMargin = size.height * ((1 - kDefaultCardInteriorScaleFactor) / 2);
  CGFloat widthMargin = size.width * ((1 - kDefaultCardInteriorScaleFactor) / 2);
  CGFloat rectHeight = (size.height *
                        kDefaultCardInteriorScaleFactor) / kMaxNumOfFramesInCard;
  NSUInteger framenum =[self getFrameNumber:index outOf:totalNumberOfShapes];
  CGFloat y = heightMargin +  framenum * rectHeight;
  CGFloat rectWidth = size.width - widthMargin * 2;
  CGFloat x = widthMargin;
  return CGRectMake(x, y, rectWidth, rectHeight);
}

///Card is split into 5 sections and each shape gets it's relevant section.
- (NSUInteger)getFrameNumber:(NSUInteger)index outOf:(NSUInteger)totalNumberOfShapes {
  if (index + 1 == totalNumberOfShapes) {
    return totalNumberOfShapes + 1;
  }
  return totalNumberOfShapes == 2 ? 1 : index * 2;
}

@end

NS_ASSUME_NONNULL_END
