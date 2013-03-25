//
//  FifteenPuzzleLayer.h
//  15Puzzle
//
//  Created by Dilip Muthukrishnan on 13-03-19.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import "cocos2d.h"
#import "FifteenPuzzleGame.h"
#import "SimpleAudioEngine.h"

@interface FifteenPuzzleLayer : CCLayer
{
    FifteenPuzzleGame *game;
    BOOL actionInProgress;
    UIAlertView *alert;
}


+(CCScene *) scene;

- (void) updateUI:(int)value;
- (CGPoint) convertScreenPointToArrayIndex:(CGPoint)screenPoint;
- (CGPoint) convertArrayIndexToScreenPoint:(CGPoint)arrayIndex;


@end
