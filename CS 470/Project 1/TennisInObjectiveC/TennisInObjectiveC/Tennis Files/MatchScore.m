//
//  MatchScore.m
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "MatchScore.h"

@interface MatchScore()
@property (nonatomic) NSMutableArray *scores;
@end

@implementation MatchScore

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer: (Player *) p2
{
    if( (self = [super initWithFirstPlayer:p1 secondPlayer:p2   ]) == nil)
        return nil;
    // initialize array to hold the set scores
    self.scores = [[NSMutableArray alloc] init];
    return self;
}

-(BOOL) haveAWinner
{
    return self.player1Score == 3 || self.player2Score == 3;
}

-(void)provideSetScores:(Score *)score
{
    [self.scores addObject:score];
    [score getWinner] == self.player1 ? self.player1Score++ : self.player2Score++;
}

-(NSString *) description
{
    NSLog(@"Set No.    Player A     Player B\n");
    for( int i = 0; i < [self.scores count]; i++ ) {
        NSLog(@"   %d          %@", i+1, [self.scores objectAtIndex:i]);
    }
    return self.player1Score > self.player2Score ?
    [NSString stringWithFormat:@"player 1 wins %d to %d\n", self.player1Score, self.player2Score] :
    [NSString stringWithFormat:@"player 2 wins %d to %d\n", self.player2Score, self.player1Score];
}

@end
