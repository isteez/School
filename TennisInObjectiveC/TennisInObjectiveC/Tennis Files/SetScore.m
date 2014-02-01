//
//  SetScore.m
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "SetScore.h"

@implementation SetScore

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer: (Player *) p2
{
    if( (self = [super initWithFirstPlayer:p1 secondPlayer:p2   ]) == nil)
        return nil;
    return self;
}

-(BOOL) haveAWinner
{
    return (self.player1Score >= 6 || self.player2Score >= 6) && abs( self.player1Score - self.player2Score) >= 2;
}

-(NSString *) description
{
    NSLog(@"SetScore... printing begins.");
    NSLog(@"p1 score = %d", self.player1Score);
    NSLog(@"p2 score = %d", self.player2Score);
    NSLog(@"SetScore... printing ends.");
    
    return self.player1Score > self.player2Score ?
    [NSString stringWithFormat:@"\n\nplayer 1 wins %d to %d\n\n", self.player1Score, self.player2Score] :
    [NSString stringWithFormat:@"\n\nplayer 2 wins %d to %d\n\n", self.player2Score, self.player1Score];
}

@end