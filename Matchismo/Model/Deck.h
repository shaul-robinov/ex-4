// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Card;

/// Deck object, a collection of cards.
@interface Deck : NSObject

/// Adds a card to the deck, if \c atTop then to the top
/// of the deck.
- (void)addCard:(Card *)card atTop:(BOOL)atTop;

/// Adds a card to the deck.
- (void)addCard:(Card *)card;

/// Draws random card from the deck and returns it.
/// The card will be pulled from the deck.
- (Card *)drawRandomCard;

@end

NS_ASSUME_NONNULL_END
