//
//  TieBreakerScore.m
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 2/1/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "TieBreakerScore.h"

@implementation TieBreakerScore

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer: (Player *) p2
{
    if( (self = [super initWithFirstPlayer:p1 secondPlayer:p2   ]) == nil)
        return nil;
    return self;
}

-(BOOL) haveAWinner
{
    return self.player1Score >= 7 || (self.player2Score >= 7  && abs(self.player1Score - self.player2Score >=2));
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"\n\n(Tie Breaker %d - %d)\n\n", self.player1Score, self.player2Score];
}

@end
