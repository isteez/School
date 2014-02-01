//
//  Competition.h
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Score.h"

@interface Competition : NSObject

@property (nonatomic) Player *player1;
@property (nonatomic) Player *player2;

-(instancetype) initWithFirstPlayer: (Player *) p1 secondPlayer: (Player *) p2;
-(Score *) play: (Player *) player;

@end
