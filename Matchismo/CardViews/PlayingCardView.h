// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import "CardView.h"

@class PlayingCard;

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView : CardView

/// Card rank
@property (nonatomic)NSUInteger rank;

/// Card suit
@property (strong, nonatomic)NSString *suit;

/// Card is chosen or not.
@property (nonatomic)BOOL chosen;

/// Card is matched or not.
@property (nonatomic)BOOL matched;

@end

NS_ASSUME_NONNULL_END
