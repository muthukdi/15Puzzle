//
//  FifteenPuzzleGame.h
//  15Puzzle
//
//  Created by Dilip Muthukrishnan on 13-03-19.
//
//

#import <Foundation/Foundation.h>

@class FifteenPuzzleLayer;

@interface FifteenPuzzleGame : NSObject
{
    int gameArray[4][4];
    int movablePieces[4][2];
    FifteenPuzzleLayer *view;
}

- (id) initWithView:(FifteenPuzzleLayer *)layer;
- (int) valueAtRow:(int)row andColumn:(int)column;
- (BOOL) isPieceMovable:(int)row andColumn:(int)column;
- (void) movePieceAtRow:(int)row andColumn:(int)column;
- (void) actionFinished:(id)sender;
- (void) scramblePieces:(int)iterations;
- (BOOL) puzzleCompleted;


@end
