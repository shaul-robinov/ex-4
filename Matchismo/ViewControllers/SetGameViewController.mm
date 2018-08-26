// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardView.h"
#import "SetCard.h"
#import "Grid.h"
NS_ASSUME_NONNULL_BEGIN

@interface SetGameViewController()

@end

@implementation SetGameViewController

// Number of cards required for a match in set game.
static const int kNumberOfCardsForMatch = 3;

/// Initial number of cards on the table.
static const int kInitialNumberOfCards = 12;

- (Deck *)createDeck {
  return [[SetCardDeck alloc] init];
}

- (CardMatchingGame *)createGameWith:(NSUInteger)count cardsUsingDeck:(Deck *)deck{
  return [[CardMatchingGame alloc]
          initWithCardCount:count
          usingDeck:deck withKMatching:kNumberOfCardsForMatch];
}

- (NSUInteger)getInitialNumberOfCards {
  return kInitialNumberOfCards;
}

- (SetCardView *)getCardViewFromCard:(Card *)card in:(CGRect)frame {
  assert([card isKindOfClass:[SetCard class]]);
  SetCard *setCard = (SetCard *)card;
  SetCardView *currentCardView = [[SetCardView alloc] initWithFrame:frame];
  [currentCardView initializeCardView:setCard];
  return currentCardView;
}

- (void)updateCardViewProperties:(SetCardView *)view ofCard:(SetCard *)card {
  if(!card) {
    view.empty = true;
  }
  view.color = card.color;
  view.shape = card.shape;
  view.rank = card.rank;
  view.filling = card.filling;
  view.chosen = card.chosen;
}

- (NSArray *)getMatchedCards:(CardMatchingGame *)game{
  return [game getMatchedCards];
}
@end

NS_ASSUME_NONNULL_END
