//
//  Soldier.m
//  Pixel Zombiles
//
//  Created by Brandon Trebitowski on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Soldier.h"
#import "Zombie.h"
#import "Bullet.h"

#define kMinZombieDistance 80
#define kBulletCount 20
#define kBulletFrequency .25

@interface Soldier()
@property(strong) Zombie *closeZombie;
@property(nonatomic) float closeZombieDistance;
@property(nonatomic, strong) NSMutableArray *bullets;
@property(nonatomic, strong) NSMutableArray *bulletsFired;
@property(nonatomic) float bulletCount;
@end

@implementation Soldier

- (id) initWithFile:(NSString *)filename
{
    if(self = [super initWithFile:filename])
    {
        self.bullets = [NSMutableArray array];
    }
    return self;
}

- (void) run:(ccTime)dt
{
    [self checkZombies];
    
    if(self.closeZombie)
    {
        if(self.bulletCount >= kBulletFrequency)
        {
            Bullet *bullet = [[Bullet alloc] initWithFile:@"yellow.png"];
            bullet.position = self.position;
            bullet.target = self.closeZombie.position;
            bullet.scale = .25;
            bullet.zombies = self.zombies;
            [self.bullets addObject:bullet];
            [self.parent addChild:bullet];
            self.bulletCount = 0;
        }
        
        self.bulletCount += dt;
        
        if(!self.isPlayer)
        {
            //self.velocity = CGPointZero;
            //self.acceleration = CGPointZero;
        }
    }
    else
    {
        if(!self.isPlayer)
        {
            [self wander];
        }
        else
        {
            if(self.position.x != self.destination.x ||
               self.position.y != self.destination.y)
            {
                [self seek:self.destination];
            }
        }
    }
    
    NSMutableArray *staleBullets = [NSMutableArray array];
    
    for(Bullet *bullet in self.bullets)
    {
        [bullet run:dt];
        if([bullet stale])
        {
            [self.parent removeChild:bullet cleanup:NO];
            [staleBullets addObject:bullet];
        }
    }
    
    [self.bullets removeObjectsInArray:staleBullets];
    
    [super run:dt];
}

- (void) checkZombies
{
    if(!self.zombies || [self.zombies count] == 0) return;
    BOOL nearbyZombie = NO;
    
    for(Zombie *zombie in self.zombies)
    {
        float distance = ccpDistance(zombie.position, self.position);
        if((distance < self.closeZombieDistance || self.closeZombieDistance == 0) && distance <= kMinZombieDistance)
        {
            self.closeZombieDistance = distance;
            self.closeZombie = zombie;
            nearbyZombie = YES;
        }
    }
    
    if(!nearbyZombie)
    {
        self.closeZombie = nil;
        self.closeZombieDistance = 0;
    }
}

@end
