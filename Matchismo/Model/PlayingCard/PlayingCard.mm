// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import "PlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCard

- (int)match:(NSArray *)otherCards{
  int score = 0;
  for(int i = 0; i < otherCards.count; i++) {
    id card = otherCards[i];
    if([card isKindOfClass:[PlayingCard class]]) {
      PlayingCard *otherCard = (PlayingCard *)card;
      if(self.rank == otherCard.rank) {
        score += 4;
      } else if([otherCard.suit isEqualToString:self.suit]) {
        score += 1;
      }
    }
  }
  return score;
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit {
  if([[PlayingCard validSuits] containsObject:suit]) {
    _suit = suit;
  }
}

- (NSString *) suit {
  return _suit ? _suit : @"?";
}


+ (NSArray *)validSuits {
  return @[@"♠️", @"♣️", @"♥️", @"♦️"];
}

+ (NSArray *)rankStrings {
  return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
  return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank {
  if (rank <= [PlayingCard maxRank]) {
    _rank = rank;
  }
}


@end

NS_ASSUME_NONNULL_END
