// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import <UIKit/UIKit.h>

#import "SetCardCreator.h"
#import "SetCard.h"
#import "SetCardView.h"
#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardView()

/// Object for drawing set cards on a given view.
@property (strong, nonatomic)SetCardCreator *cardCreator;

@end

@implementation SetCardView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0


- (void)setColor:(UIColor *)color {
  _color = color;
  [self setNeedsDisplay]; //Updates the system that the view needs to be redrawn;
}

- (void)setRank:(NSNumber *)rank {
  _rank = rank;
  [self setNeedsDisplay];
}

- (void)setShape:(NSString *)shape {
  _shape = shape;
  [self setNeedsDisplay];
}

- (void)setFilling:(NSNumber *)filling {
  _filling = filling;
  [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen {
  _chosen = chosen;
  [self setNeedsDisplay];
}

- (void)setEmpty:(BOOL)empty {
  _empty = empty;
  [self setNeedsDisplay];
}

- (SetCardCreator *)cardCreator {
  if(!_cardCreator) {
    _cardCreator = [[SetCardCreator alloc] init];
  }
  return _cardCreator;
}

- (void)drawRect:(CGRect)rect {
  if(self.empty) {
    return;
  }
  UIColor *backgroundColor = self.chosen ? [UIColor grayColor] : [UIColor whiteColor];
  [self drawCardWithColoredBackground:backgroundColor];
  [self.cardCreator drawSetCardShape:self.shape
                             ofColor:self.color
                          andFilling:self.filling
                              ofRank:self.rank
                            inBounds:self.bounds];
  
}

- (void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}


- (void)flipCard {
  self.chosen = !self.chosen;
  [self setNeedsDisplay];
}


- (void)initializeCardView:(SetCard *)card {
  assert([card isKindOfClass:[SetCard class]]);
  [self setProperties:card];
  [self setup];
  [self setNeedsDisplay];
  
}

- (void)setProperties:(SetCard *)card {
  self.color = card.color;
  self.shape = card.shape;
  self.filling = card.filling;
  self.rank = card.rank;
  self.chosen = card.chosen;
  [self setNeedsDisplay];
}

@end

NS_ASSUME_NONNULL_END
