// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import "Deck.h"

NS_ASSUME_NONNULL_BEGIN

@interface Deck()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation Deck

- (instancetype)init {
    if(self = [super init]) {
      self.cards = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop {
  if(atTop) {
      [self.cards insertObject:card atIndex:0];
    } else {
      [self.cards addObject:card];
    }
    
}

- (void)addCard:(Card *)card {
    [self addCard:card atTop:NO];
}

- (Card *)drawRandomCard {
    Card *randomCard = nil;
    
    if([self.cards count]){
      unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}

@end

NS_ASSUME_NONNULL_END
