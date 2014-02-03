//
//  Player.h
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Score;

@interface Player : NSObject

@property (nonatomic) int probabilityOfWinningAServe;

+(Player *) otherPlayer: (Player *) player;

-(instancetype) initWithProbability:(int) prob;
-(Score *) serveAPoint;

@end
