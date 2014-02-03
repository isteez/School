//
//  SetScore.h
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "Score.h"
#import "TieBreakerScore.h"

@interface SetScore : Score
{
    TieBreakerScore *tieScore;
}

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer: (Player *) p2;
-(void) addTieScore:(TieBreakerScore *)score;
-(BOOL) shouldPlayTieBreaker;

@end
