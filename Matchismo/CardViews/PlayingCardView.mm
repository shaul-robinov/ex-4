// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import <UIKit/UIKit.h>

#import "PlayingCardView.h"
#import "PlayingCard.h"
#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView()

/// Scale factor for imaged cards.
@property (nonatomic) CGFloat faceCardScaleFactor;

@end

@implementation PlayingCardView

#define CARD_MATCHING_MARK_RATIO 0.0005

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

#define PIP_FONT_SCALE_FACTOR 0.012

@synthesize faceCardScaleFactor = _faceCardScaleFactor;


- (void)setSuit:(NSString *)suit
{
  _suit = suit;
  [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank
{
  _rank = rank;
  [self setNeedsDisplay];
}

- (void)setMatched:(BOOL)matched {
  _matched = matched;
  [self setNeedsDisplay];
}



- (CGFloat)faceCardScaleFactor {
  if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
  return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
  _faceCardScaleFactor = faceCardScaleFactor;
  [self setNeedsDisplay];
}


- (NSString *)rankAsString {
  return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}
#define CORNER_RADIUS 12.0

- (void)drawRect:(CGRect)rect
{
  // Drawing code
  [self drawCardWithColoredBackground:[UIColor whiteColor]];

  if (self.chosen) {
    UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",
                                              [self rankAsString], self.suit]];
    if (faceImage) {
      CGRect imageRect = CGRectInset(self.bounds,
                                     self.bounds.size.width * (1.0-self.faceCardScaleFactor),
                                     self.bounds.size.height * (1.0-self.faceCardScaleFactor));
      [faceImage drawInRect:imageRect];
    } else {
      [self drawPips];
    }

    [self drawCorners];
  } else {
    [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
  }
  if(self.matched) {
    [self drawCardAsMatched];
  }
}


- (void)flipCard {
  self.chosen = !self.chosen;
  [self setNeedsDisplay];
}

- (void)drawCardAsMatched {
  UIBezierPath *path = [[UIBezierPath alloc] init];
  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  [path moveToPoint:CGPointMake(0.3 * width, 0.4 * height)];
  [path addLineToPoint:CGPointMake(0.4 * width, 0.5 * height)];
  [path addLineToPoint:CGPointMake(0.8 * width, 0.1 * height)];
  [UIColor.greenColor setStroke];
  path.lineWidth = self.bounds.size.width * self.bounds.size.height * CARD_MATCHING_MARK_RATIO;
  [path stroke];
}


- (void)pushContextAndRotateUpsideDown
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)drawCorners
{
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  
  UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
  
  NSAttributedString *cornerText =
    [[NSAttributedString alloc] initWithString:[NSString
      stringWithFormat:@"%@\n%@", [self rankAsString], self.suit]
      attributes:@{ NSFontAttributeName : cornerFont,
      NSParagraphStyleAttributeName : paragraphStyle }];
  
  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [cornerText size];
  [cornerText drawInRect:textBounds];
  
  [self pushContextAndRotateUpsideDown];
  [cornerText drawInRect:textBounds];
  [self popContext];
}

- (void)drawPips
{
  NSUInteger rank = self.rank;
  if ((rank == 1) || (rank == 5) || (rank == 9) || (rank == 3)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((rank == 6) || (rank == 7) || (rank == 8)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((rank == 2) || (rank == 3) || (rank == 7) ||
      (rank == 8) || (rank == 10)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:PIP_VOFFSET2_PERCENTAGE
                    mirroredVertically:(rank != 7)];
  }
  if ((rank == 4) || (rank == 5) || (rank == 6) ||
      (rank == 7) || (rank == 8) || (rank == 9) || (rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET3_PERCENTAGE
                    mirroredVertically:YES];
  }
  if ((rank == 9) || (rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET1_PERCENTAGE
                    mirroredVertically:YES];
  }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
  if (upsideDown) [self pushContextAndRotateUpsideDown];
  CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  pipFont = [pipFont fontWithSize:[pipFont pointSize] *
             self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
  NSAttributedString *attributedSuit =
      [[NSAttributedString alloc] initWithString:self.suit
                                      attributes:@{ NSFontAttributeName : pipFont }];
  CGSize pipSize = [attributedSuit size];
  CGPoint pipOrigin = CGPointMake(
                                  middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                  middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                  );
  [attributedSuit drawAtPoint:pipOrigin];
  if (hoffset) {
    pipOrigin.x += hoffset*2.0*self.bounds.size.width;
    [attributedSuit drawAtPoint:pipOrigin];
  }
  if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
  [self drawPipsWithHorizontalOffset:hoffset
                      verticalOffset:voffset
                          upsideDown:NO];
  if (mirroredVertically) {
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:YES];
  }
}


- (void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}


- (void)initializeCardView:(PlayingCard *)card {
  assert([card isKindOfClass:[PlayingCard class]]);
  [self setProperties:card];
  [self setup];
  
}

- (void)setProperties:(PlayingCard *)card {
  self.rank = card.rank;
  self.suit = card.suit;
  self.chosen = card.chosen;
}

@end

NS_ASSUME_NONNULL_END
