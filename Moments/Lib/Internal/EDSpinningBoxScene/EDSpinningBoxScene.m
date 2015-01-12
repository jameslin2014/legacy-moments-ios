//
//  EDSpinningBoxScene.m
//  Box
//
//  Created by Evan Dekhayser on 12/16/14.
//  Copyright (c) 2014 Xappox, LLC. All rights reserved.
//

#import "EDSpinningBoxScene.h"

@implementation EDSpinningBoxScene

- (instancetype)init{
	if (self = [super init]){
		SCNNode *cameraNode = [SCNNode node];
		cameraNode.camera = [SCNCamera camera];
		[self.rootNode addChildNode:cameraNode];
		
		// place the camera
		cameraNode.position = SCNVector3Make(0, 0, 15);
		
		SCNNode *group = [SCNNode node];
		
		float shortSide = 0.125;
		float longSide = 1;
		float distanceBetween = longSide / 2 - shortSide / 2;
		
		UIColor *c = [UIColor colorWithRed:0 green:0.78 blue:0.42 alpha:1];
		UIColor *w = [UIColor whiteColor];
		
		SCNBox *boxZ = [SCNBox boxWithWidth:shortSide height:shortSide length:longSide chamferRadius:0];
		SCNNode *b1 = [SCNNode nodeWithGeometry:boxZ];
		b1.position = SCNVector3Make(-distanceBetween, -distanceBetween, 0);
		b1.geometry.firstMaterial.diffuse.contents = c;
		b1.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b1];
		SCNNode *b2 = [SCNNode nodeWithGeometry:boxZ];
		b2.position = SCNVector3Make(distanceBetween, -distanceBetween, 0);
		b2.geometry.firstMaterial.diffuse.contents = c;
		b2.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b2];
		SCNNode *b3 = [SCNNode nodeWithGeometry:boxZ];
		b3.position = SCNVector3Make(-distanceBetween, distanceBetween, 0);
		b3.geometry.firstMaterial.diffuse.contents = c;
		b3.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b3];
		SCNNode *b4 = [SCNNode nodeWithGeometry:boxZ];
		b4.position = SCNVector3Make(distanceBetween, distanceBetween, 0);
		b4.geometry.firstMaterial.diffuse.contents = c;
		b4.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b4];
		
		SCNBox *boxY = [SCNBox boxWithWidth:shortSide height:longSide length:shortSide chamferRadius:0];
		SCNNode *b5 = [SCNNode nodeWithGeometry:boxY];
		b5.position = SCNVector3Make(-distanceBetween, 0, -distanceBetween);
		b5.geometry.firstMaterial.diffuse.contents = c;
		b5.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b5];
		SCNNode *b6 = [SCNNode nodeWithGeometry:boxY];
		b6.position = SCNVector3Make(-distanceBetween, 0, distanceBetween);
		b6.geometry.firstMaterial.diffuse.contents = c;
		b6.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b6];
		SCNNode *b7 = [SCNNode nodeWithGeometry:boxY];
		b7.position = SCNVector3Make(distanceBetween, 0, -distanceBetween);
		b7.geometry.firstMaterial.diffuse.contents = c;
		b7.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b7];
		SCNNode *b8 = [SCNNode nodeWithGeometry:boxY];
		b8.position = SCNVector3Make(distanceBetween, 0, distanceBetween);
		b8.geometry.firstMaterial.diffuse.contents = c;
		b8.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b8];
		
		SCNBox *boxX = [SCNBox boxWithWidth:longSide height:shortSide length:shortSide chamferRadius:0];
		SCNNode *b9 = [SCNNode nodeWithGeometry:boxX];
		b9.position = SCNVector3Make(0, -distanceBetween, -distanceBetween);
		b9.geometry.firstMaterial.diffuse.contents = c;
		b9.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b9];
		SCNNode *b10 = [SCNNode nodeWithGeometry:boxX];
		b10.position = SCNVector3Make(0, -distanceBetween, distanceBetween);
		b10.geometry.firstMaterial.diffuse.contents = c;
		b10.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b10];
		SCNNode *b11 = [SCNNode nodeWithGeometry:boxX];
		b11.position = SCNVector3Make(0, distanceBetween, -distanceBetween);
		b11.geometry.firstMaterial.diffuse.contents = c;
		b11.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b11];
		SCNNode *b12 = [SCNNode nodeWithGeometry:boxX];
		b12.position = SCNVector3Make(0, distanceBetween, distanceBetween);
		b12.geometry.firstMaterial.diffuse.contents = c;
		b12.geometry.firstMaterial.specular.contents = w;
		[group addChildNode:b12];
		
		[self.rootNode addChildNode:group];
		
		[group runAction:[SCNAction repeatActionForever:[SCNAction rotateByX: M_2_PI y: M_PI z: M_2_SQRTPI duration:1.0]]];
		
		// create and add a light to the scene
		SCNNode *lightNode = [SCNNode node];
		lightNode.light = [SCNLight light];
		lightNode.light.type = SCNLightTypeOmni;
		lightNode.position = SCNVector3Make(0, 10, 10);
		[self.rootNode addChildNode:lightNode];
		
		// create and add an ambient light to the scene
		SCNNode *ambientLightNode = [SCNNode node];
		ambientLightNode.light = [SCNLight light];
		ambientLightNode.light.type = SCNLightTypeAmbient;
		ambientLightNode.light.color = [UIColor darkGrayColor];
		[self.rootNode addChildNode:ambientLightNode];
	}
	return self;
}

@end
