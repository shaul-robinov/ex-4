// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.
#import "Card.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Class representing a card in the Matchismo game.
@interface PlayingCard : Card

/// The valid suits of the cards.
+ (NSArray *)validSuits;

/// The max rank a card can hold.
+ (NSUInteger)maxRank;

/// Card suit
@property (strong, nonatomic) NSString *suit;

/// Card rank
@property (nonatomic) NSUInteger rank;

@end

NS_ASSUME_NONNULL_END

