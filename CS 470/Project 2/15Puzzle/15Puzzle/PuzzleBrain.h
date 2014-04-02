//
//  PuzzleBrain.h
//  15Puzzle
//
//  Created by Stephen Kyles on 2/6/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleBrain : NSObject

// Shuffles puzzle buttons
- (NSMutableArray *)shufflePuzzleButtons:(NSMutableArray *)puzzleButtonArray;

// Locating puzzle buttons within array
- (int)getBlankButtonIdx:(NSArray *)buttonArray withButton:(UIButton *)button;
- (int)getMoveablePuzzleButtonDownFrom:(NSArray *)buttonArray withBlankButton:(UIButton *)button;
- (int)getMoveablePuzzleButtonUpFrom:(NSArray *)buttonArray withBlankButton:(UIButton *)button;
- (int)getMoveablePuzzleButtonLeftFrom:(NSArray *)buttonArray withBlankButton:(UIButton *)button;
- (int)getMoveablePuzzleButtonRightFrom:(NSArray *)buttonArray withBlankButton:(UIButton *)button;

// Provides an number that corresponds to a random move
- (int)getRandomMove:(NSMutableArray *)buttonArray withButton:(UIButton *)button;

// New center points
- (CGPoint)getNewCenterPoint:(NSArray *)puzzleButtons with:(int)index;

// Has the puzzle been solved yet
- (BOOL)shouldContinueGame:(NSArray *)defaultPositions withCurrentButtonLocations:(NSMutableArray *)currentLocations;
- (BOOL)isShuffled:(BOOL)boolean;
@property (nonatomic) BOOL shuffled;
@property (nonatomic) BOOL isShuffling;

// Checks for legal move
- (BOOL)checkLegalMoveUp:(CGRect)rect withCurrentPosition:(CGPoint)point;
- (BOOL)checkLegalMoveDown:(CGRect)rect withCurrentPosition:(CGPoint)point;
- (BOOL)checkLegalMoveLeft:(CGRect)rect withCurrentPosition:(CGPoint)point;
- (BOOL)checkLegalMoveRight:(CGRect)rect withCurrentPosition:(CGPoint)point;

// Validates shuffle solution is solvable
- (BOOL)checkForASolutionWithSorted:(NSArray *)array andShuffled:(NSMutableArray *)mutableArray;

@end
