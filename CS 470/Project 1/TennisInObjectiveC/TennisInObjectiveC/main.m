//
//  main.m
//  TennisInObjectiveC
//
//  Created by Stephen Kyles on 1/31/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Player.h"
#import "Game.h"
#import "GameScore.h"
#import "Match.h"
#import "Matchscore.h"
#import "SetScore.h"
#import "Set.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        srandom(19);
        
        Player *player1 = [[Player alloc] initWithProbability: 40];
        Player *player2 = [[Player alloc] initWithProbability: 40];
        
        Match *match = [[Match alloc] initWithFirstPlayer:player1 secondPlayer:player2];
        Score *matchScore = [match play: player1];
        
        NSLog(@"%@", matchScore);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
