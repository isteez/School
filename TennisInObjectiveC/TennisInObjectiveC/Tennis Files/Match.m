//
//  Match.m
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "Match.h"
#import "Player.h"
#import "Score.h"
#import "MatchScore.h"
#import "Set.h"

@implementation Match

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer:(Player *) p2
{
    if( (self = [super initWithFirstPlayer:p1 secondPlayer:p2] ) == nil )
        return nil;
    return self;
}

-(Score *) play:(Player *)player
{
    MatchScore *matchScore = [[MatchScore alloc] initWithFirstPlayer:self.player1 secondPlayer:self.player2];
    
    while( ! [matchScore haveAWinner] ) {
        Set *set = [[Set alloc] initWithFirstPlayer:self.player1 secondPlayer:self.player2];
        Score *score = [set play: player];
        [matchScore addScore: score];
        score = nil;
        player = [Player otherPlayer:player];
    }
    return matchScore;
}

@end
