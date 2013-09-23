//
//  Bullet.m
//  Pixel Zombies
//
//  Created by Brandon Trebitowski on 9/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"
#import "Boid.h"
#import "Zombie.h"

#define kBulletMaxLived 2.5
#define kBulletVelocity 5

@interface Bullet ()
@property(nonatomic) float liveTime;
@property(nonatomic) CGPoint velocity;
@end

@implementation Bullet

- (void) run:(ccTime) dt
{
    self.position = ccpAdd(self.position, self.velocity);

    if((self.position.x == self.velocity.x &&
       self.position.y == self.velocity.y) || self.liveTime >= kBulletMaxLived)
    {
        self.stale = YES;
    }
    
    self.liveTime += dt;
    
    [self checkHitZombie];
}

- (void) setTarget:(CGPoint)target
{
    _target = target;
    
    self.velocity = ccpSub(target, self.position);
    self.velocity = [Boid normalize:self.velocity];
    self.velocity = ccpMult(self.velocity, kBulletVelocity);
}

- (void) checkHitZombie
{
    CGRect myRect = self.boundingBox;
    for(Zombie *zombie in self.zombies)
    {
        CGRect zombieRect = zombie.boundingBox;
        if(CGRectIntersectsRect(myRect, zombieRect))
        {         
            self.stale = YES;
            zombie.dead = YES;
            break;
        }
    }
}

@end
