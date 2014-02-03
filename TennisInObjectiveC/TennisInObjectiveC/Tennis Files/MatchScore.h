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
}

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer: (Player *) p2;
@property (nonatomic) NSMutableArray* scores;

@end
