//
//  Boid.h
//  Pixel Zombiles
//
//  Created by Brandon Trebitowski on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum boidState
{
    kBoidStateWander,
    kBoidStateSeek
} BoidState;

@interface Boid : CCSprite

@property(nonatomic) float maxForce;
@property(nonatomic) float maxSpeed;
@property(nonatomic) BoidState state;
@property(nonatomic, strong) NSMutableArray *otherBoids;
@property(nonatomic) CGPoint velocity;
@property(nonatomic) CGPoint acceleration;
@property(nonatomic) float r;
@property(nonatomic) float wanderTheta;
@property(nonatomic) float separationDistance;

- (id) initWithFile:(NSString *)filename;
- (void) run:(ccTime) dt;
- (void) seek:(CGPoint) target;
- (void) wander;
- (CGPoint) steer:(CGPoint) target away:(BOOL) away;
+ (CGPoint) normalize:(CGPoint) point;

@end
