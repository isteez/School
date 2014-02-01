//
//  MatchScore.h
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "Score.h"
#import "SetScore.h"

@interface MatchScore : Score
{
    int setNumber;
    SetScore *scores[5];
}

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer: (Player *) p2;

@end
