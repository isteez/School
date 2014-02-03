//
//  TieBreakerScore.h
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 2/1/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "Score.h"

@interface TieBreakerScore : Score

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer: (Player *) p2;

@end
