//
//  Bullet.h
//  Pixel Zombies
//
//  Created by Brandon Trebitowski on 9/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Bullet : CCSprite
@property(nonatomic, retain) NSMutableArray *zombies;
@property(nonatomic) CGPoint target;
@property(nonatomic) BOOL stale;
- (void) run:(ccTime) dt;
@end
