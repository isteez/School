//
//  SetScore.m
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "SetScore.h"
#import "TieBreaker.h"
#import "TieBreakerScore.h"

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

-(BOOL) shouldPlayTieBreaker
{
    return self.player1Score == 6 && self.player2Score == 6;
}

-(void) addTieScore:(TieBreakerScore *)score
{
    [self addScore:[score getWinner]];
    tieScore = score;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"%d            %d", self.player1Score, self.player2Score];
}

@end