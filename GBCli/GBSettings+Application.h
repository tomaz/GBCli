//
//  GBSettings+Application.h
//  GBCli
//
//  Created by Tomaž Kragelj on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GBSettings.h"

@interface GBSettings (Application)

#pragma mark - Initialization & disposal

+ (id)mySettingsWithName:(NSString *)name parent:(GBSettings *)parent;

#pragma mark - Project information

@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *projectVersion;

#pragma mark - Paths

@property (nonatomic, strong) NSArray *inputPaths;
@property (nonatomic, strong) NSArray *outputPaths;

#pragma mark - Debugging aid

@property (nonatomic, assign) BOOL printSettings;

@end

#pragma mark - 

@interface GBSettings (Helpers)

- (void)applyFactoryDefaults;

@end
