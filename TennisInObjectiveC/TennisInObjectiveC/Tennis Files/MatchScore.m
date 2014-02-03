//
//  MatchScore.m
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "MatchScore.h"

@implementation MatchScore

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer: (Player *) p2
{
    if( (self = [super initWithFirstPlayer:p1 secondPlayer:p2   ]) == nil)
        return nil;
    return self;
}

-(BOOL) haveAWinner
{
    return self.player1Score == 3 || self.player2Score == 3;
}

-(void)addScore:(Score *)score
{
    [self.scores addObject:score];
    NSLog(@"%@", score);
    NSLog(@"%@", self.scores);
    [score getWinner] == self.player1 ? self.player1Score++ : self.player2Score++;
    setNumber++;
}

-(NSString *) description
{
    NSLog(@"Set No.    Player A     Player B\n");
    for( int i = 0; i < setNumber; i++ ) {
        NSLog(@"   %d          %@", i+1, self.scores[i]);
    }
    return self.player1Score > self.player2Score ?
    [NSString stringWithFormat:@"\n\nplayer 1 wins %d to %d\n\n", self.player1Score, self.player2Score] :
    [NSString stringWithFormat:@"\n\nplayer 2 wins %d to %d\n\n", self.player2Score, self.player1Score];
}

@end
