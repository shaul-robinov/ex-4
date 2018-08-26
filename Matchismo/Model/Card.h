// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Card object in a card game.
@interface Card : NSObject <NSCopying>

/// Returns non-zero value if the current card matches the others
/// according to the game rules, zero otherwise.
- (int)match:(NSArray *)otherCards;

/// The content of the card.
- (NSString *)contents;

/// The attributes to display the content properly.
- (NSDictionary *)attributes;

/// The content of the card.
@property (strong, nonatomic) NSString *contents;

/// Is the card currently chosen.
@property (nonatomic, getter=isChosen) BOOL chosen;

/// Was the card already matched.
@property (nonatomic, getter=isMatched) BOOL matched;

@end

NS_ASSUME_NONNULL_END
