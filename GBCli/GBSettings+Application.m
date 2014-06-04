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

+ (instancetype)mySettingsWithName:(NSString *)name parent:(GBSettings *)parent {
	id result = [self settingsWithName:name parent:parent];
	if (result) {
		[result registerArrayForKey:GBSettingKeys.inputPaths];
		[result registerArrayForKey:GBSettingKeys.outputPaths];
	}
	return result;
}

#pragma mark - Project information

GB_SYNTHESIZE_COPY(NSString *, projectName, setProjectName, GBSettingKeys.projectName)
GB_SYNTHESIZE_COPY(NSString *, projectVersion, setProjectVersion, GBSettingKeys.projectVersion)

#pragma mark - Paths

GB_SYNTHESIZE_OBJECT(NSArray *, inputPaths, setInputPaths, GBSettingKeys.inputPaths)
GB_SYNTHESIZE_OBJECT(NSArray *, outputPaths, setOutputPaths, GBSettingKeys.outputPaths)

#pragma mark - Debugging aid

GB_SYNTHESIZE_BOOL(printSettings, setPrintSettings, GBSettingKeys.printSettings)
GB_SYNTHESIZE_BOOL(printVersion, setPrintVersion, GBSettingKeys.printVersion)
GB_SYNTHESIZE_BOOL(printHelp, setPrintHelp, GBSettingKeys.printHelp)

@end

#pragma mark - 

@implementation GBSettings (Helpers)

- (void)applyFactoryDefaults {
	self.projectVersion = @"1.0";
	self.printSettings = NO;
}

@end

#pragma mark - 

const struct GBSettingKeys GBSettingKeys = {
	.projectName = @"project-name",
	.projectVersion = @"project-version",
	.inputPaths = @"input",
	.outputPaths = @"output",
	.printSettings = @"print-settings",
	.printVersion = @"version",
	.printHelp = @"help",
};