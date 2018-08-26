// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import "CardView.h"

@class SetCard;

NS_ASSUME_NONNULL_BEGIN

@interface SetCardView : CardView

/// Card color
@property (strong, nonatomic)UIColor *color;

/// Card shape
@property (strong, nonatomic)NSString *shape;

/// Card filling
@property (strong, nonatomic)NSNumber *filling;

/// Card rank
@property (nonatomic) NSNumber *rank;

/// Card is chosen or not
@property (nonatomic)BOOL chosen;

/// View is empty, it shouldnt display any card.
@property (nonatomic)BOOL empty;

@end

NS_ASSUME_NONNULL_END
