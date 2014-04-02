//
//  PentagoBrain.h
//  Pentago
//
//  Created by Stephen Kyles on 2/23/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PentagoBrain : NSObject

@property (nonatomic) BOOL redCanGo;

+(PentagoBrain *) sharedInstance;

// Game controls
- (int)whosTurnIsIt;
- (BOOL)checkForWin:(int)player;

// Adding balls to the game
- (CGPoint)getLocationInSubView:(CGPoint)point andTellBrainWhoItsFrom:(int)index;
- (BOOL)isThereABallInThatHoleAlready:(CGPoint)index subView:(int)subViewIndex;
- (void)addBallToTheGame:(CGPoint)index player:(int)player point:(int)point subView:(int)subViewIndex;

// Rotation logic
- (void)handleRightRotatationOfBalls:(int)index;
- (void)handleLeftRotatationOfBalls:(int)index;

@end
