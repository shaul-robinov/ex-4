// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardGameViewController()

@end

@implementation PlayingCardGameViewController
/// Number of cards required for a match in matchismo game
static const int kNumberCardsForMatch = 2;

/// Initial number of cards on the table.
static const int kInitialNumberOfCards = 25;

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)createGameWith:(NSUInteger)count cardsUsingDeck:(Deck *)deck{
  return [[CardMatchingGame alloc]
          initWithCardCount:count
          usingDeck:deck withKMatching:kNumberCardsForMatch];
}

- (UIImage *)backgroundImageForCard:(Card *)card {
  return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (PlayingCardView *)getCardViewFromCard:(Card *)card in:(CGRect)frame {
  assert([card isMemberOfClass :[PlayingCard class]]);
  PlayingCard *playingCard = (PlayingCard *)card;
  PlayingCardView *currentCardView = [[PlayingCardView alloc] initWithFrame:frame];
  [currentCardView initializeCardView:playingCard];
  return currentCardView;
}

- (NSUInteger)getInitialNumberOfCards {
  return kInitialNumberOfCards;
}

- (void)updateCardViewProperties:(PlayingCardView *)view ofCard:(PlayingCard *)card {
  view.rank = card.rank;
  view.suit = card.suit;
  view.matched = card.matched;
  if(view.chosen != card.chosen){
    [self animateTap:view];
  }
}

- (void)animateTap:(PlayingCardView *)view {
  [UIView transitionWithView:view
                    duration:0.15
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  animations:^(){
                    view.chosen = !view.chosen;
                  }
                  completion:^(BOOL finished){
                    return;
                  }];
}

@end

NS_ASSUME_NONNULL_END
