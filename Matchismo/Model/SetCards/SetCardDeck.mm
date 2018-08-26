// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import "SetCardDeck.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardDeck
- (instancetype)init {
  if (self = [super init]) {
    for(NSString* shape in [SetCard validShapes]) {
      for(UIColor *color in [SetCard validColors]) {
        for(NSNumber *fillValue in [SetCard validFillings]) {
          for(NSNumber *rank in [SetCard validRanks]) {
            SetCard* newCard = [[SetCard alloc] init];
            newCard.shape = shape;
            newCard.color = color;
            newCard.filling = fillValue;
            newCard.rank = rank;
            [self addCard:newCard];
          }
        }
      }
    }
  }  
  return self;
}

@end

NS_ASSUME_NONNULL_END
