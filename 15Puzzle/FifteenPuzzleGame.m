//
//  FifteenPuzzleGame.m
//  15Puzzle
//
//  Created by Dilip Muthukrishnan on 13-03-19.
//
//

#import "FifteenPuzzleGame.h"

@implementation FifteenPuzzleGame

- (id) initWithView:(FifteenPuzzleLayer *)layer
{
	if( (self=[super init]))
    {
        view = layer;
        int value = 0;
		for (int j = 0; j < 4; j++)
        {
            for (int i = 0; i < 4; i++)
            {
                gameArray[i][j] = value;
                value++;
            }
        }
        for (int j = 0; j < 4; j++)
        {
            for (int i = 0; i < 2; i++)
            {
                movablePieces[i][j] = 0;
            }
        }
        [self scramblePieces:100];
	}
	return self;
}

- (void) scramblePieces:(int)iterations
{
    for (int k = 0; k < iterations; k++)
    {
        // Gather up the moveable pieces
        int indexOfMovablePiece = 0;
        for (int j = 0; j < 4; j++)
        {
            for (int i = 0; i < 4; i++)
            {
                // This will always be either two, three, or four!
                if ([self isPieceMovable:i andColumn:j])
                {
                    movablePieces[indexOfMovablePiece][0] = i;
                    movablePieces[indexOfMovablePiece][1] = j;
                    indexOfMovablePiece++;
                }
            }
        }
        // Randomly select a piece to move
        int randomIndex = arc4random() % indexOfMovablePiece;
        [self movePieceAtRow:movablePieces[randomIndex][0] andColumn:movablePieces[randomIndex][1]];
    }
}

- (int) valueAtRow:(int)row andColumn:(int)column
{
    return gameArray[row][column];
}

- (BOOL) isPieceMovable:(int)row andColumn:(int)column
{
    // Where is zero?
    int zeroRow, zeroColumn;
    for (int j = 0; j < 4; j++)
    {
        for (int i = 0; i < 4; i++)
        {
            if (gameArray[i][j] == 0)
            {
                zeroRow = i;
                zeroColumn = j;
            }
        }
    }
    // How far away is zero?
    if (zeroRow != row && zeroColumn != column)
    {
        return NO;
    }
    if (zeroRow == row && zeroColumn == column)
    {
        return NO;
    }
    if (zeroRow == row)
    {
        if (abs(zeroColumn-column) > 1)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    if (zeroColumn == column)
    {
        if (abs(zeroRow-row) > 1)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}

- (void) movePieceAtRow:(int)row andColumn:(int)column
{
    // Where is zero?
    int zeroRow, zeroColumn;
    for (int j = 0; j < 4; j++)
    {
        for (int i = 0; i < 4; i++)
        {
            if (gameArray[i][j] == 0)
            {
                zeroRow = i;
                zeroColumn = j;
            }
        }
    }
    // Swap values with zero
    int value = gameArray[row][column];
    gameArray[zeroRow][zeroColumn] = value;
    gameArray[row][column] = 0;
}

- (BOOL) puzzleCompleted
{
    // If the first index is not zero
    if (gameArray[0][0])
    {
        return NO;
    }
    int list[15];
    int listIndex = 0;
    // Make sure everything is in order
    for (int j = 0; j < 4; j++)
    {
        for (int i = 0; i < 4; i++)
        {
            list[listIndex] = gameArray[i][j];
            listIndex++;
        }
    }
    for (int i = 1; i < 15; i++)
    {
        if (list[i] != list[i-1]+1)
        {
            return NO;
        }
    }
    return YES;
}


@end
