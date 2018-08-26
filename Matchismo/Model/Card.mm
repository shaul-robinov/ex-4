// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@implementation Card

- (int)match:(NSArray *)otherCards {
  return 0;
}

- (NSString *)contents{
  return nil;
}

- (NSDictionary *)attributes{
  return nil;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
  return self;
}

@end

NS_ASSUME_NONNULL_END
