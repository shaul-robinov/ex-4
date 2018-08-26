// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardDeck
- (instancetype)init {
  if (self = [super init]) {
    for(NSString *suit in [PlayingCard validSuits]) {
      for(NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
        PlayingCard* card = [[PlayingCard alloc] init];
        card.rank = rank;
        card.suit = suit;
        [self addCard:card];
      }
    }    
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
