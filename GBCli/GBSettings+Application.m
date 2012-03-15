//
//  GbSettings+Application.m
//  GBCli
//
//  Created by Tomaž Kragelj on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GBSettings+Application.h"

@implementation GBSettings (Application)

#pragma mark - Initialization & disposal

+ (id)mySettingsWithName:(NSString *)name parent:(GBSettings *)parent {
	id result = [self settingsWithName:name parent:parent];
	if (result) {
		[result registerArrayForKey:@"output"];
	}
	return result;
}

#pragma mark - Project information

GB_SYNTHESIZE_COPY(NSString *, projectName, setProjectName, @"project-name")
GB_SYNTHESIZE_COPY(NSString *, projectVersion, setProjectVersion, @"project-version")

#pragma mark - Paths

GB_SYNTHESIZE_OBJECT(NSArray *, inputPaths, setInputPaths, @"input")
GB_SYNTHESIZE_OBJECT(NSArray *, outputPaths, setOutputPaths, @"output")

#pragma mark - Debugging aid

GB_SYNTHESIZE_BOOL(printSettings, setPrintSettings, @"print-settings")

@end

#pragma mark - 

@implementation GBSettings (Helpers)

- (void)applyFactoryDefaults {
	self.projectVersion = @"1.0";
	self.printSettings = NO;
}

@end
