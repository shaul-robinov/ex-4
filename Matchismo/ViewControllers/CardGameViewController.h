//
//  ViewController.h
//  Matchismo
//
//  Created by Shaul Robinov on 02/08/2018.
//  Copyright © 2018 Shaul Robinov. All rights reserved.
//
//Abstract class, must implement mthods decribed below.

#import "CardMatchingGame.h"

#import <UIKit/UIKit.h>

@class CardView, Deck;

/// View controller for card game.
@interface CardGameViewController : UIViewController

///Creates a deck of cards appropriate for the game.
- (Deck *)createDeck;

/// Creates a game instance with given deck that holds \c count cards.
- (CardMatchingGame *)createGameWith:(NSUInteger)count cardsUsingDeck:(Deck *)deck; 

/// Returns the background image on the card.
- (UIImage *)backgroundImageForCard:(Card *)card;

/// Returns CardView object for \c card located in the \c frame
- (CardView *)getCardViewFromCard:(Card *)card in:(CGRect)frame;

/// Updates the view to hold the new cards properties
- (void)updateCardViewProperties:(CardView *)view ofCard:(Card *)card;

@end
