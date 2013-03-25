//
//  FifteenPuzzleLayer.m
//  15Puzzle
//
//  Created by Dilip Muthukrishnan on 13-03-19.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import "FifteenPuzzleLayer.h"

@implementation FifteenPuzzleLayer

+ (CCScene *) scene
{
	CCScene *scene = [CCScene node];
	FifteenPuzzleLayer *layer = [FifteenPuzzleLayer node];
	[scene addChild: layer];
	return scene;
}

- (id) init
{
	if( (self=[super init]))
    {
		for (int i = 0; i < 15; i++)
        {
            CCSprite *piece = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i.png",i+1]];
            piece.tag = i+1;
            [self addChild:piece];
        }
        [self setIsTouchEnabled:YES];
        game = [[FifteenPuzzleGame alloc] initWithView:self];
        alert = [[UIAlertView alloc] initWithTitle:@"15 Puzzle" message:@"Puzzle Complete!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self updateUI:0];
	}
	return self;
}

- (void) updateUI:(int)movedValue
{
    for (int j = 0; j < 4; j++)
    {
        for (int i = 0; i < 4; i++)
        {
            int value = [game valueAtRow:i andColumn:j];
            // Only does this at the start of the game!
            if (!movedValue)
            {
                if (value)
                {
                    CGPoint screenPoint = [self convertArrayIndexToScreenPoint:ccp(i, j)];
                    CCNode *piece = [self getChildByTag:value];
                    piece.position = screenPoint;
                }
            }
            else if (value == movedValue)
            {
                actionInProgress = YES;
                CGPoint screenPoint = [self convertArrayIndexToScreenPoint:ccp(i, j)];
                CCSprite *piece = (CCSprite *)[self getChildByTag:value];
                piece.color = ccRED;
                CCMoveTo *action = [CCMoveTo actionWithDuration:0.2f position:screenPoint];
                CCCallFuncN *actionDone = [CCCallFuncN actionWithTarget:self
                                                               selector:@selector(actionFinished:)];
                [piece runAction:[CCSequence actions:action, actionDone, nil]];
                return;
            }
        }
    }
}

- (void) actionFinished:(id)sender
{
    CCSprite *piece = (CCSprite *)sender;
    if ([game puzzleCompleted])
    {
        [alert show];
    }
    piece.color = ccWHITE;
    actionInProgress = NO;
}

- (CGPoint) convertScreenPointToArrayIndex:(CGPoint)screenPoint
{
    float x, y;
    if (screenPoint.x < 80.0)
    {
        x = 0.0;
    }
    else if (screenPoint.x >= 80.0 && screenPoint.x < 160.0)
    {
        x = 1.0;
    }
    else if (screenPoint.x >= 160.0 && screenPoint.x < 240.0)
    {
        x = 2.0;
    }
    else if (screenPoint.x >= 240.0 && screenPoint.x < 320.0)
    {
        x = 3.0;
    }
    if (screenPoint.y > 360.0)
    {
        y = 0.0;
    }
    else if (screenPoint.y > 280.0 && screenPoint.y <= 360.0)
    {
        y = 1.0;
    }
    else if (screenPoint.y > 200.0 && screenPoint.y <= 280.0)
    {
        y = 2.0;
    }
    else if (screenPoint.y >= 120.0 && screenPoint.y <= 200.0)
    {
        y = 3.0;
    }
    CGPoint arrayIndex = ccp(x, y);
    return arrayIndex;
}

- (CGPoint) convertArrayIndexToScreenPoint:(CGPoint)arrayIndex
{
    float screenX, screenY;
    if (arrayIndex.x == 0.0)
    {
        screenX = 40.0;
    }
    else if (arrayIndex.x == 1.0)
    {
        screenX = 120.0;
    }
    else if (arrayIndex.x == 2.0)
    {
        screenX = 200.0;
    }
    else if (arrayIndex.x == 3.0)
    {
        screenX = 280.0;
    }
    if (arrayIndex.y == 0.0)
    {
        screenY = 400.0;
    }
    else if (arrayIndex.y == 1.0)
    {
        screenY = 320.0;
    }
    else if (arrayIndex.y == 2.0)
    {
        screenY = 240.0;
    }
    else if (arrayIndex.y == 3.0)
    {
        screenY = 160.0;
    }
    CGPoint screenPoint = ccp(screenX, screenY);
    return screenPoint;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (actionInProgress)
    {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint screenPoint = [self convertTouchToNodeSpace:touch];
    if (screenPoint.y < 120.0 || screenPoint.y > 440.0)
    {
        NSLog(@"Invalid screen location!");
        return;
    }
    CGPoint arrayIndex = [self convertScreenPointToArrayIndex:screenPoint];
    int row = (int)arrayIndex.x;
    int column = (int)arrayIndex.y;
    if ([game isPieceMovable:row andColumn:column])
    {
        int valueToBeMoved = [game valueAtRow:row andColumn:column];
        [game movePieceAtRow:row andColumn:column];
        [self updateUI:valueToBeMoved];
        [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    }
    else
    {
        NSLog(@"Piece cannot be moved!");
    }
}

- (void) dealloc
{
	[super dealloc];
    [game release];
}

@end
