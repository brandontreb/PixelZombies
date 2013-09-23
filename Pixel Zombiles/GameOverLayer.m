//
//  IntroLayer.m
//  PocketVillage
//
//  Created by Brandon Trebitowski on 8/22/12.
//  Copyright brandontreb.com 2012. All rights reserved.
//


// Import the interfaces
#import "GameOverLayer.h"
#import "GameLayer.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation GameOverLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    self.won = [d boolForKey:@"WIN"];
    
	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

    NSString *text = self.won ? @"Killed them zombies DEAD!" : @"Braaaaaainnnnns. DEAD!";
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Marker Felt" fontSize:45];
	label.position = ccp(size.width/2, size.height/2);

	// add the label as a child to this Layer
	[self addChild: label];
    
}

#pragma mark - touch

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene] withColor:ccWHITE]];
}

@end
