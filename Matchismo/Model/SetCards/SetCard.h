// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.
#import "Card.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// A set game card object.
@interface SetCard : Card

/// Valid symbols the cards can have.
+ (NSArray<NSString *> *)validShapes;

/// Valid colors for the cards.
+ (NSArray<UIColor *> *)validColors;

/// Valid shades for the cards.
+ (NSArray<NSNumber *> *)validFillings;

/// Valid number of symbols the cards can have.
+ (NSArray<NSNumber *> *)validRanks;

/// Card color
@property (strong, nonatomic)UIColor *color;

/// Card shape
@property (strong, nonatomic)NSString *shape;

/// Card filling
@property (strong, nonatomic)NSNumber *filling;

/// Card rank
@property (nonatomic) NSNumber *rank;

@end

NS_ASSUME_NONNULL_END
