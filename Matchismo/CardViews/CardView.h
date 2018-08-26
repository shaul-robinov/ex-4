// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

NS_ASSUME_NONNULL_BEGIN

@class Card;

/// UIView displays card on the main view.
@interface CardView : UIView <NSCopying>

/// Draws a card with background color.
- (void)drawCardWithColoredBackground:(UIColor *)color;

/// Scale factor to round cards corners
- (CGFloat)cornerScaleFactor;

/// Offset factor for cards corners.
- (CGFloat)cornerOffset;

/// Initializes card's view.
- (void)initializeCardView:(Card *)card;

/// Flips card.
- (void)flipCard;

@end

NS_ASSUME_NONNULL_END
