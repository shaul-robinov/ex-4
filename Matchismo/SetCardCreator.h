// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Shaul Robinov.

NS_ASSUME_NONNULL_BEGIN

@class SetCard;

@interface SetCardCreator : NSObject

/// Draw a given set card in given bounds.
- (void)drawSetCardShape:(NSString *)shape
                 ofColor:(UIColor *)color
              andFilling:(NSNumber *)filling
                  ofRank:(NSNumber *)rank 
                inBounds:(CGRect)cardBounds;

@end

NS_ASSUME_NONNULL_END
