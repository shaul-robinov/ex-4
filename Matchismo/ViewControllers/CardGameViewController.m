//
//  ViewController.m
//  Matchismo
//
//  Created by Shaul Robinov on 02/08/2018.
//  Copyright © 2018 Shaul Robinov. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "Grid.h"
#import "CardView.h"

@interface CardGameViewController ()

/// The grid on which the views are placed.
@property (strong, nonatomic)Grid *grid;

/// The main view where the cards are placed on.
@property (weak, nonatomic) IBOutlet UIView *mainView;

// The deck used in the game.
@property (strong, nonatomic) Deck *deck;

/// UIButton that adds cards to the table.
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;

/// The game being played.
@property (strong, nonatomic) CardMatchingGame *game;

/// Dictionary that holds CardView-Card tuples where the view is the key and card is object
@property (strong, nonatomic)NSMutableDictionary *viewToCardCollection;

/// Dictionary that holds Card-CardView tuples where the card is the key and view is object
@property (strong, nonatomic)NSMutableDictionary *cardToViewCollection;

//Label displays the score of the game.
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation CardGameViewController

/// Number of cards added when the add cards button is pressed.
static const int kNUmberOfCardsToAdd = 3;

- (IBAction)collectCards:(UIPinchGestureRecognizer *)sender {
  CGPoint pinchLocation = [sender locationInView:self.mainView];
  if ((sender.state == UIGestureRecognizerStateChanged) ||
      (sender.state == UIGestureRecognizerStateBegan)) {
    [self setDeckCenterToPoint:pinchLocation];
  } else {
    [self reorderCards];
  }
}

- (void)setDeckCenterToPoint:(CGPoint)point {
  [UIView animateWithDuration:0.5
                        delay:0.0
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                          for(CardView *view in [self.cardToViewCollection allValues]) {
                            view.center = point;
                          }
                        }
                   completion:^(BOOL finished) {
                        }];
}

- (IBAction)addCards:(UIButton *)sender {
  for (int i = 0; i < kNUmberOfCardsToAdd; i++) {
    Card *newCard = [self.game addCardToTable];
    if(!newCard) {
      self.addCardButton.enabled = NO;
      self.addCardButton.alpha = 0.4;
      break;
    }
    CardView *cardSubView = [self getCardViewFromCard:newCard in:CGRectMake(0, 0, 1, 1)];
    [self addCard:newCard toView:cardSubView];
  }
  [self reorderCards];
}

- (IBAction)tapOnCard:(UITapGestureRecognizer *)sender {
  if(![sender.view isKindOfClass:[CardView class]]) {
    return;
  }
  CardView *cardSubView = (CardView *)sender.view;
  Card *cardAtView = self.viewToCardCollection[cardSubView];
  
  [self.game chooseCard:cardAtView];
  [self handleMatchedCard];
  [self updateUI];
}

- (void)reorderCards {
  [self initializeGrid];
  [UIView animateWithDuration:1.0
                        delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                          int i = 0;
                          for(Card *card in self.game.curCardsOnTable) {
                            CardView *curView = [self.cardToViewCollection objectForKey:card];
                            curView.frame = [self.grid frameAtIndex:i];
                            i++;
                          }
                        } completion:^(BOOL finished) {
                      
                        }];
}

- (void)handleMatchedCard {
  NSArray *matchedCards = [self getMatchedCards:self.game];
  for(Card *card in matchedCards) {
    CardView *view = [self.cardToViewCollection objectForKey:card];
    [view setAlpha:0];
    [self.cardToViewCollection removeObjectForKey:card];
    [self.viewToCardCollection removeObjectForKey:view];
  }
  [self updateCollections];
  [self reorderCards];
}

- (void)updateCollections {
  for(Card *curCard in self.game.curCardsOnTable) {
    if(! self.cardToViewCollection[curCard]) {
      CardView *cardSubView = [self getCardViewFromCard:curCard in:CGRectMake(0, 0, 1, 1)];
      [self addCard:curCard toView:cardSubView];
    }
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateUI];
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter]
   addObserver:self selector:@selector(orientationChanged:)
   name:UIDeviceOrientationDidChangeNotification
   object:[UIDevice currentDevice]];
}

- (void) orientationChanged:(NSNotification *)note {
  [self reorderCards];
}

- (void)updateUI {
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  for(Card *card in self.cardToViewCollection) {
    CardView *view = [self.cardToViewCollection objectForKey:card];
    [self updateCardViewProperties:view ofCard:card];
  }
}

- (IBAction)dealGame:(UIButton *)sender {
  self.game = nil;
  self.deck = nil;
  self.grid = nil;
  self.cardToViewCollection = nil;
  self.addCardButton.enabled = true;
  self.addCardButton.alpha = 1;
  [self initGame];
}

- (void)initGame {
  [self.mainView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|
   UIViewAutoresizingFlexibleHeight];
  [self removeSubViews];
  [self.mainView setBackgroundColor:[UIColor clearColor]];
  [self initializeGrid];
  [self setCardsToSubViews];
  [self updateUI];
}

- (void)setCardsToSubViews {
  [self initializeGrid];
  [self removeSubViews];
  [self.cardToViewCollection removeAllObjects];
  [self updateCollections];
  [self reorderCards];
}

- (void)addCard:(Card *)card toView:(CardView *) cardView{
  [cardView setBackgroundColor:[UIColor clearColor]];
  [self.mainView addSubview:cardView];
  [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(tapOnCard:)]];
  [self.cardToViewCollection setObject:cardView forKey:card];
  [self.viewToCardCollection setObject:card forKey:cardView];
}

- (void)removeSubViews {
  for (UIView *subUIView in self.mainView.subviews) {
    [subUIView removeFromSuperview];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initGame];
}

- (void)initializeGrid {
  self.grid.size = self.mainView.frame.size;
  self.grid.cellAspectRatio = 1;
  self.grid.minimumNumberOfCells = self.game.curCardsOnTable.count;
}

- (Deck *)deck {
  if(!_deck){
    _deck = [self createDeck];
  }
  return _deck;
}

- (Grid *)grid {
  if(!_grid) {
    _grid = [[Grid alloc] init];
  }
  return _grid;
}

- (CardMatchingGame *)game {
  if(!_game) {
    _game = [self createGameWith:[self getInitialNumberOfCards] cardsUsingDeck:self.deck];
  }
  return _game;
}

- (NSMutableDictionary *)cardToViewCollection {
  if (!_cardToViewCollection) {
    _cardToViewCollection = [[NSMutableDictionary alloc] init];
  }
  return _cardToViewCollection;
}

- (NSMutableDictionary *)viewToCardCollection {
  if(!_viewToCardCollection) {
    _viewToCardCollection = [[NSMutableDictionary alloc] init];
  }
  return _viewToCardCollection;
}

/// Abstract method.
- (NSArray *)getMatchedCards:(CardMatchingGame *)game{
  return nil;
}

/// Abstract method.
- (CardMatchingGame *)createGameWith:(NSUInteger)count cardsUsingDeck:(Deck *)deck {
  return nil;
}

/// Abstract method.
- (UIImage *)backgroundImageForCard:(Card *)card {
  return nil;
}

/// Abstract method.
- (UIView *)getMainView {
  return nil;
}

/// Abstract method.
- (CardView *)getCardViewFromCard:(Card *)card in:(CGRect)frame{
  return nil;
}

/// Abstract method.
- (Deck *)createDeck {
  return nil;
}

/// Abstract method.
- (NSUInteger)getInitialNumberOfCards {
  return 0;
}

/// Abstract method.
- (void)updateCardViewProperties:(CardView *)view ofCard:(Card *)card {
  return;
}
@end
