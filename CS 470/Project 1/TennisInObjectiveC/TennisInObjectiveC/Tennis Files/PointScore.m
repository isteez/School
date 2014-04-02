//
//  PointScore.m
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "PointScore.h"

@implementation PointScore

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer: (Player *) p2
{
    if( (self = [super initWithFirstPlayer:p1 secondPlayer:p2   ]) == nil)
        return nil;
    return self;
}

-(BOOL) haveAWinner
{
    return self.player1Score == 1 || self.player2Score == 1;
}

-(NSString *) description
{
    NSLog(@"PointScore... printing begins.");
    NSLog(@"p1 score = %d", self.player1Score);
    NSLog(@"p2 score = %d", self.player2Score);
    NSLog(@"PointScore... printing ends.");
    
    return [NSString stringWithFormat:@"\n\nplayer1 score = %d\nplayer2 score = %d\n\n", self.player1Score, self.player2Score ];
    
}

@end
