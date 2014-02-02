//
//  TieBreaker.m
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 2/1/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "TieBreaker.h"
#import "TieBreakerScore.h"
#import "PointScore.h"
#import "GameScore.h"
#import "Score.h"
#import "Player.h"

@implementation TieBreaker

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer:(Player *) p2
{
    if( (self = [super initWithFirstPlayer:p1 secondPlayer:p2] ) == nil )
        return nil;
    return self;
}

-(Score *) play:(Player *)player
{
    TieBreakerScore *tieBreakerScore = [[TieBreakerScore alloc] initWithFirstPlayer:self.player1 secondPlayer:self.player2];
    PointScore *pScore =  (PointScore *) [player serveAPoint];
    [tieBreakerScore addScore: [pScore getWinner]];
    
    bool switchTheServer = false;
    while( ! [tieBreakerScore haveAWinner] ) {
        [tieBreakerScore addScore: [pScore getWinner]];
        if (switchTheServer) {
            player = [player.otherPlayer:player];
        }
        switchTheServer = !switchTheServer;
    }
    return tieBreakerScore;
}

@end
