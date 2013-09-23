//
//  IntroLayer.h
//  PocketVillage
//
//  Created by Brandon Trebitowski on 8/22/12.
//  Copyright brandontreb.com 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface GameOverLayer : CCLayer

@property(nonatomic) BOOL won;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
