// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import "CardMatchingGame.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardMatchingGame()

///Score of the game.
@property (readwrite, nonatomic) NSInteger score;

///Number of cards required for a match
@property (readwrite, nonatomic) NSUInteger nMatchGame;

// Should the chosen cards be matched.
@property (nonatomic) BOOL shouldMatchCards;

//Currently chosen cards in the game.
@property (strong, nonatomic) NSMutableArray *chosenCards;

@end

//Bonus multiplier for matching \c kMtachGame cards.
static const int kMatchBonus = 4;

//Cost to choose a single card.
static const int kCostToChoose = 1;

@implementation CardMatchingGame

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
                    withKMatching:(NSUInteger)kMatch {
  if (self = [super init]) {
    self.curCardsOnTable = [[NSMutableArray alloc] init];
    self.chosenCards = [[NSMutableArray alloc] init];
    for(int i = 0; i < count; i++) {
      Card* randomCard = [deck drawRandomCard];
      if(!randomCard){
        self = nil;
        break;
      }
      [self.curCardsOnTable addObject:randomCard];
    }
    self.nMatchGame = kMatch;
  }
  self.remainingDeck = deck;
  return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
  return index < self.curCardsOnTable.count ?  self.curCardsOnTable[index] : nil;
}

- (void)chooseCard:(Card *)card {
  if(card.isMatched) {
    return;
  }
  if(card.isChosen) {
    card.chosen = NO;
    [self.chosenCards removeObject:card];
  } else {
    card.chosen = YES;
    if([self onlySingleCardWasChosen]) {
      self.score -= kCostToChoose;
    } else {
      [self updateScore:card];
      [self handleChosenCards:card];
      return;
    }
    [self.chosenCards addObject:card];
  }
}

- (void)updateScore:(Card *)card {
  int matchScore = [card match:self.chosenCards];
  if(matchScore) {
    self.shouldMatchCards = YES;
    matchScore = matchScore * kMatchBonus * (int)self.nMatchGame;
    self.score += matchScore;
  } else {
    self.score -= self.nMatchGame;
  }
}

- (void)handleChosenCards:(Card *)card{
  if(self.chosenCards.count + 1 != self.nMatchGame) {
    card.chosen = YES;
    [self.chosenCards addObject:card];
    return;
  }
  for(Card *otherCard in self.chosenCards) {
    otherCard.matched = self.shouldMatchCards;
    otherCard.chosen = self.shouldMatchCards;
  }
  [self.chosenCards removeAllObjects];
  if(self.shouldMatchCards) {
    card.matched = YES;
    card.chosen = YES;
    self.shouldMatchCards = NO;
  }
  else {
    [self.chosenCards addObject:card];
  }
  
}

- (BOOL)onlySingleCardWasChosen {
  return self.chosenCards.count == 0;
}

- (void)updateChosenCards {
  [self.chosenCards removeAllObjects];
  for(Card *otherCard in self.curCardsOnTable) {
    if(otherCard.isChosen && !otherCard.isMatched) {
      [self.chosenCards addObject:otherCard];
    }
  }
}

- (NSArray *)getChosenCards {
  return [self.chosenCards copy];
}

- (Card *)addCardToTable {
  Card *newCard = [self.remainingDeck drawRandomCard];
  if(!newCard) {
    return nil;
  }
  [self.curCardsOnTable addObject:newCard];
  return newCard;
}

- (NSArray *)getMatchedCards {
  NSMutableArray *cardsToRemove = [[NSMutableArray alloc] init];
  for(int i = 0; i < self.curCardsOnTable.count; i++) {
    Card *card = self.curCardsOnTable[i];
    if(card.matched) {
      [cardsToRemove addObject:card];
      Card *newCard = [self.remainingDeck drawRandomCard];
      if(newCard) {
        [self.curCardsOnTable addObject:newCard];
      }
    }
  }
  [self.curCardsOnTable removeObjectsInArray:cardsToRemove];
  return cardsToRemove;
}
@end

NS_ASSUME_NONNULL_END
