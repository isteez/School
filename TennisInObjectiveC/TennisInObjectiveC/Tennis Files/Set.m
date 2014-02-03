//
//  Set.m
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "Set.h"
#import "SetScore.h"
#import "PointScore.h"
#import "GameScore.h"
#import "Game.h"
#import "Player.h"
#import "TieBreaker.h"

@implementation Set

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer:(Player *) p2
{
    if( (self = [super initWithFirstPlayer:p1 secondPlayer:p2] ) == nil )
        return nil;
    return self;
}

-(Score *) play:(Player *)player
{
    SetScore *setScore = [[SetScore alloc] initWithFirstPlayer:self.player1 secondPlayer:self.player2];
    
    while( ! [setScore haveAWinner] ) {
        Game *game = [[Game alloc] initWithFirstPlayer:self.player1 secondPlayer:self.player2];
        Score *score = [game play: player];
        [setScore addScore: [score getWinner]];
        score = nil;
        player = [Player otherPlayer:player];

        if( [setScore shouldPlayTieBreaker] ) {
            TieBreaker *tiebreaker = [[TieBreaker alloc] initWithFirstPlayer:self.player1 secondPlayer:self.player2];
            [setScore addTieScore:(TieBreakerScore *)[tiebreaker play: player]];
            return setScore;
        }
    }
    return setScore;
}

@end