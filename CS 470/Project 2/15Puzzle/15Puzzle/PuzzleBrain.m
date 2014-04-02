//
//  PuzzleBrain.m
//  15Puzzle
//
//  Created by Stephen Kyles on 2/6/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "PuzzleBrain.h"

@interface PuzzleBrain()

@property (nonatomic, strong) NSArray *puzzleButtonCenters;
@property (nonatomic, strong) NSMutableArray *shuffledPuzzleButtons;
@property (nonatomic, strong) NSMutableArray *defaultPositions;
@property (nonatomic, strong) NSMutableArray *invertedLocation;

@end

@implementation PuzzleBrain

// The returned mutable array is a shuffled version of the
// mutable array that was sent. Two random indexes are generated
// and the buttons at those indexes are swapped. This however
// doesn't mean the new shuffled array is actually a solvable puzzle.
- (NSMutableArray *)shufflePuzzleButtons:(NSMutableArray *)puzzleButtonArray
{
    for (int i=0; i<[puzzleButtonArray count]; i++) {
        
        // Two random indexes
        int indexOne = i % [puzzleButtonArray count];
        int indexTwo = arc4random() % [puzzleButtonArray count];
        
        // Swap buttons at indexes
        if (indexOne != indexTwo) {
            [puzzleButtonArray exchangeObjectAtIndex:indexOne withObjectAtIndex:indexTwo];
        }
    }
    return puzzleButtonArray;
}

// The function returns a boolean value depending on the solvability of the
// shuffled array. The inverted count for each button in the array
// is stored and summed. If the value is odd, the puzzle is not solvable,
// if it's even, the puzzle is solvable.
- (BOOL)checkForASolutionWithSorted:(NSArray *)array andShuffled:(NSMutableArray *)mutableArray
{
    if (!self.invertedLocation) {
        self.invertedLocation = [[NSMutableArray alloc] init];
    }
    self.defaultPositions = [NSMutableArray arrayWithArray:array];
    self.shuffledPuzzleButtons = mutableArray;
    
    // Store the a number that represents where within the
    // shuffled array a specific button is
    for (UIButton *button in self.defaultPositions) {
        for (int i=0; i<[self.shuffledPuzzleButtons count]; i++) {
            if (button == self.shuffledPuzzleButtons[i]) {
                [self.invertedLocation addObject:[NSNumber numberWithInt:i]];
            }
        }
    }
    NSLog(@"%@", self.invertedLocation);
    
    // Determine if the number is greater than the remaining
    // numbers in the array.  If it is, our nunning counter is incremented.
    int counter = 0;
    for (int i=0; i<[self.invertedLocation count]; i++) {
        for (int j=i; j<([self.invertedLocation count]); j++) {
            if (self.invertedLocation[i] > self.invertedLocation[j]) {
                NSLog(@"location i: %@", self.invertedLocation[i]);
                NSLog(@"location j:%@", self.invertedLocation[j]);
                counter++;
                NSLog(@"counter: %d", counter);
            }
        }
    }
    
    // Is the count even or odd
    return counter % 2 ? NO : YES;
}

// Checks to verify an up move is legal.
// Uses the current center point of the blank button and the bottom
// of the puzzle view frame.
- (BOOL)checkLegalMoveUp:(CGRect)rect withCurrentPosition:(CGPoint)point
{
    if ((rect.size.height - point.y) == 51) {
        NSLog(@"Move is not legal");
        return NO;
    }
    return YES;
}

// Checks to verify a down move is legal.
// Uses the current center point of the blank button and the top
// of the puzzle view frame.
- (BOOL)checkLegalMoveDown:(CGRect)rect withCurrentPosition:(CGPoint)point
{
    if ((rect.size.height - point.y) == 261) {
        NSLog(@"Move is not legal");
        return NO;
    }
    return YES;
}

// Checks to verify a left move is legal.
// Uses the current center point of the blank button and the right
// side of the puzzle view frame.
- (BOOL)checkLegalMoveLeft:(CGRect)rect withCurrentPosition:(CGPoint)point
{
    if ((rect.size.width - point.x) == 55) {
        NSLog(@"Move is not legal");
        return NO;
    }
    return YES;
}

// Checks to verify a right move is legal.
// Uses the current center point of the blank button and the left
// side of the puzzle view frame.
- (BOOL)checkLegalMoveRight:(CGRect)rect withCurrentPosition:(CGPoint)point
{
    if ((rect.size.width - point.x) == 265) {
        NSLog(@"Move is not legal");
        return NO;
    }
    return YES;
}

// Makes sure that the game is still going after each move
// Checks the location of each button.
- (BOOL)shouldContinueGame:(NSArray *)defaultPositions withCurrentButtonLocations:(NSMutableArray *)currentLocations
{
    int temp = 0;
    for (int i=0; i<[defaultPositions count]; i++) {
        if (currentLocations[i] == defaultPositions[i]) {
            temp++;
        }
    }
    return temp == [defaultPositions count] ? NO : YES;
}

// Sets the shuffled flag if a game is being played.
// Resets once a puzzle has been solved or reset back to it's default position.
- (BOOL)isShuffled:(BOOL)boolean
{
    return boolean ? YES : NO;
}

// Generates a single random move based off the current
// location of the blank button and the available moves
// that the button can make. This way we never have a
// move that isn't legal. The number that is generated matches
// a number the calling function has that dicates movement.
- (int)getRandomMove:(NSMutableArray *)buttonArray withButton:(UIButton *)button
{
    int up = 3;
    int down = 1;
    int right = 0;
    int left = 2;
    
    // bottom row
    if (buttonArray[15] == button) {
        int temp = arc4random() % 2;
        if (temp == 0) {
            return right;
        }
        else if (temp == 1){
            return down;
        }
    }
    else if (buttonArray[14] == button) {
        int temp = arc4random() % 3;
        if (temp == 0) {
            return right;
        }
        else if (temp == 1){
            return down;
        }
        else if (temp == 2){
            return left;
        }
    }
    else if (buttonArray[13] == button) {
        int temp = arc4random() % 3;
        if (temp == 0) {
            return right;
        }
        else if (temp == 1){
            return down;
        }
        else if (temp == 2){
            return left;
        }
    }
    else if (buttonArray[12] == button) {
        int temp = arc4random() % 2;
        if (temp == 0) {
            return down;
        }
        else if (temp == 1){
            return left;
        }
    }
    // 3rd row
    else if (buttonArray[11] == button) {
        int temp = arc4random() % 3;
        if (temp == 0) {
            return down;
        }
        else if (temp == 1){
            return right;
        }
        else if (temp == 2){
            return up;
        }
    }
    else if (buttonArray[10] == button) {
        int temp = arc4random() % 4;
        if (temp == 0) {
            return down;
        }
        else if (temp == 1){
            return right;
        }
        else if (temp == 2){
            return up;
        }
        else if (temp == 3){
            return left;
        }
    }
    else if (buttonArray[9] == button) {
        int temp = arc4random() % 4;
        if (temp == 0) {
            return down;
        }
        else if (temp == 1){
            return right;
        }
        else if (temp == 2){
            return up;
        }
        else if (temp == 3){
            return left;
        }
    }
    else if (buttonArray[8] == button) {
        int temp = arc4random() % 3;
        if (temp == 0) {
            return down;
        }
        else if (temp == 1){
            return up;
        }
        else if (temp == 2){
            return left;
        }
    }
    // 2nd row
    else if (buttonArray[7] == button) {
        int temp = arc4random() % 3;
        if (temp == 0) {
            return down;
        }
        else if (temp == 1){
            return up;
        }
        else if (temp == 2){
            return right;
        }
    }
    else if (buttonArray[6] == button) {
        int temp = arc4random() % 4;
        if (temp == 0) {
            return down;
        }
        else if (temp == 1){
            return right;
        }
        else if (temp == 2){
            return up;
        }
        else if (temp == 3){
            return left;
        }
    }
    else if (buttonArray[5] == button) {
        int temp = arc4random() % 4;
        if (temp == 0) {
            return down;
        }
        else if (temp == 1){
            return right;
        }
        else if (temp == 2){
            return up;
        }
        else if (temp == 3){
            return left;
        }
    }
    else if (buttonArray[4] == button) {
        int temp = arc4random() % 3;
        if (temp == 0) {
            return down = 1;
        }
        else if (temp == 1){
            return up = 2;
        }
        else if (temp == 2){
            return left = 3;
        }
    }
    // top row
    else if (buttonArray[3] == button) {
        int temp = arc4random() % 2;
        if (temp == 0) {
            return up;
        }
        else if (temp == 1){
            return right;
        }
    }
    else if (buttonArray[2] == button) {
        int temp = arc4random() % 3;
        if (temp == 0) {
            return up;
        }
        else if (temp == 1){
            return right;
        }
        else if (temp == 2){
            return left;
        }
    }
    else if (buttonArray[1] == button) {
        int temp = arc4random() % 3;
        if (temp == 0) {
            return up;
        }
        else if (temp == 1){
            return right;
        }
        else if (temp == 2){
            return left;
        }
    }
    else if (buttonArray[0] == button) {
        int temp = arc4random() % 3;
        if (temp == 0) {
            return up;
        }
        else if (temp == 1){
            return left;
        }
    }
    return 0;
}

// Finds the current location of the blank button
// inside of a given puzzle button array.
// Returns the buttons index.
- (int)getBlankButtonIdx:(NSArray *)buttonArray withButton:(UIButton *)button
{
    int temp;
    for (int i=0; i<buttonArray.count; i++) {
        if (button == buttonArray[i]) {
            temp = i;
        }
    }
    return temp;
}

// Finds the new center point of the blank button based off
// the center point of the button that will be replacing it,
// depending on which move is made and if that move is legal.
- (CGPoint)getNewCenterPoint:(NSArray *)puzzleButtons with:(int)index
{
    if (!self.puzzleButtonCenters) {
        self.puzzleButtonCenters = [[NSArray alloc] init];
    }
    self.puzzleButtonCenters = puzzleButtons;
    
    UIButton *temp;
    for (int i=0; i<puzzleButtons.count; i++) {
        if (index == i) {
            temp = puzzleButtons[i];
        }
    }
    return temp.center;
    [self delete:temp];
}

// Finds which puzzle button is the correct button for a swipe down.
// Uses the blank buttons location within the button array and the location
// of the button above the blank button.
- (int)getMoveablePuzzleButtonDownFrom:(NSArray *)buttonArray withBlankButton:(UIButton *)button
{
    int temp;
    for (int i=0; i<buttonArray.count; i++) {
        if (button == buttonArray[i]) {
            temp = i;
        }
    }
    // bottom row
    if (temp == 15) {
        temp = 11;
    }
    else if (temp == 14) {
        temp = 10;
    }
    else if (temp == 13) {
        temp = 9;
    }
    else if (temp == 12) {
        temp = 8;
    }
    // 3rd row
    else if (temp == 11) {
        temp = 7;
    }
    else if (temp == 10) {
        temp = 6;
    }
    else if (temp == 9) {
        temp = 5;
    }
    else if (temp == 8) {
        temp = 4;
    }
    // 2nd row
    else if (temp == 7) {
        temp = 3;
    }
    else if (temp == 6) {
        temp = 2;
    }
    else if (temp == 5) {
        temp = 1;
    }
    else if (temp == 4) {
        temp = 0;
    }
    // no row 1
    // you can't move a puzzle button down
    // out of scope of the puzzle view
    
    // return moveable button index
    return temp;
}

// Finds which puzzle button is the correct button for a swipe up.
// Uses the blank buttons location within the button array and the location
// of the button below the blank button.
- (int)getMoveablePuzzleButtonUpFrom:(NSArray *)buttonArray withBlankButton:(UIButton *)button
{
    int temp;
    for (int i=0; i<buttonArray.count; i++) {
        if (button == buttonArray[i]) {
            temp = i;
        }
    }
    // top row
    if (temp == 3) {
        temp = 7;
    }
    else if (temp == 2) {
        temp = 6;
    }
    else if (temp == 1) {
        temp = 5;
    }
    else if (temp == 0) {
        temp = 4;
    }
    // 2nd row
    else if (temp == 7) {
        temp = 11;
    }
    else if (temp == 6) {
        temp = 10;
    }
    else if (temp == 5) {
        temp = 9;
    }
    else if (temp == 4) {
        temp = 8;
    }
    // 3rd row
    else if (temp == 11) {
        temp = 15;
    }
    else if (temp == 10) {
        temp = 14;
    }
    else if (temp == 9) {
        temp = 13;
    }
    else if (temp == 8) {
        temp = 12;
    }
    // no bottom row
    // you can't move a puzzle button up
    // out of scope of the puzzle view
    
    // return moveable button index
    return temp;
}

// Finds which puzzle button is the correct button for a swipe left.
// Uses the blank buttons location within the button array and the location
// of the button to the left of the blank button.
- (int)getMoveablePuzzleButtonLeftFrom:(NSArray *)buttonArray withBlankButton:(UIButton *)button
{
    int temp;
    for (int i=0; i<buttonArray.count; i++) {
        if (button == buttonArray[i]) {
            temp = i;
        }
    }
    // 1st column
    if (temp == 12) {
        temp = 13;
    }
    else if (temp == 8) {
        temp = 9;
    }
    else if (temp == 4) {
        temp = 5;
    }
    else if (temp == 0) {
        temp = 1;
    }
    // 2nd column
    else if (temp == 13) {
        temp = 14;
    }
    else if (temp == 9) {
        temp = 10;
    }
    else if (temp == 5) {
        temp = 6;
    }
    else if (temp == 1) {
        temp = 2;
    }
    // 3rd column
    else if (temp ==14) {
        temp = 15;
    }
    else if (temp == 10) {
        temp = 11;
    }
    else if (temp == 6) {
        temp = 7;
    }
    else if (temp == 2) {
        temp = 3;
    }
    // no 3rd column
    // you can't move a puzzle button left
    // out of scope of the puzzle view
    
    // return moveable button index
    return temp;
}

// Finds which puzzle button is the correct button for a swipe right.
// Uses the blank buttons location within the button array and the location
// of the button to the right of the blank button.
- (int)getMoveablePuzzleButtonRightFrom:(NSArray *)buttonArray withBlankButton:(UIButton *)button
{
    int temp;
    for (int i=0; i<buttonArray.count; i++) {
        if (button == buttonArray[i]) {
            temp = i;
        }
    }
    // far right column
    if (temp == 15) {
        temp = 14;
    }
    else if (temp == 11) {
        temp = 10;
    }
    else if (temp == 7) {
        temp = 6;
    }
    else if (temp == 3) {
        temp = 2;
    }
    // 3rd column
    else if (temp == 14) {
        temp = 13;
    }
    else if (temp == 10) {
        temp = 9;
    }
    else if (temp == 6) {
        temp = 5;
    }
    else if (temp == 2) {
        temp = 1;
    }
    // 2nd column
    else if (temp == 13) {
        temp = 12;
    }
    else if (temp == 9) {
        temp = 8;
    }
    else if (temp == 5) {
        temp = 4;
    }
    else if (temp == 1) {
        temp = 0;
    }
    // no 1st column
    // you can't move a puzzle button right
    // out of scope of the puzzle view
    
    // return moveable button index
    return temp;
}

@end
