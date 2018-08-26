// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import <Foundation/Foundation.h>

#import "Deck.h"
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

/// A class representing a card matching game.
@interface CardMatchingGame : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes game with given deck that holds \c count cards
/// and \c kMatch cards are needed for a match.
- (instancetype)initWithCardCount:(NSUInteger)count
      usingDeck:(Deck *)deck withKMatching:(NSUInteger)kMatch NS_DESIGNATED_INITIALIZER;

/// Chooses a card at given index.
- (void)chooseCard:(Card *)card;


/// Returnes the card from given index.
- (Card *)cardAtIndex:(NSUInteger)index;

/// Returns an array of cards that are currently chosen.
- (NSArray *)getChosenCards;

/// Adds a random card to the game.
- (Card *)addCardToTable;

/// Returns matched cards currently in the game.
- (NSArray *)getMatchedCards;

/// The current score in the game.
@property (readonly, nonatomic) NSInteger score;

/// Number of cards required for a match.
@property (readonly, nonatomic) NSUInteger nMatchGame;

/// Cards currently on the game table.
@property (strong, nonatomic)NSMutableArray *curCardsOnTable;

/// Remaining cards in the deck.
@property (strong, nonatomic)Deck *remainingDeck;

@end

NS_ASSUME_NONNULL_END
