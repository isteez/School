//
//  TieBreaker.h
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 2/1/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "Competition.h"

@interface TieBreaker : Competition

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer:(Player *) p2;
-(Score *) play: (Player *) player;

@end
