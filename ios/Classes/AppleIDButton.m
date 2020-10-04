//
//  AppleIdButton.m
//  apple_sign_in
//
//  Created by Tom on 21/06/2019.
//

#import "AppleIDButton.h"
#import <AuthenticationServices/AuthenticationServices.h>

@implementation AppleIDButton {
    ASAuthorizationAppleIDButton* _button;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    
    if ([super init]) {
        NSString* channelName = [NSString stringWithFormat:@"dev.gilder.tom/apple_sign_in_button_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        
        _viewId = viewId;
        
        ASAuthorizationAppleIDButtonType asiButtonType = [self buttonTypeFromString:args[@"asiButtonType"]];
        ASAuthorizationAppleIDButtonStyle asiButtonStyle = [self buttonStyleFromString:args[@"asiButtonStyle"]];
        _button = [ASAuthorizationAppleIDButton buttonWithType:asiButtonType
                                                         style:asiButtonStyle];
        
        _button.frame = frame;
        _button.enabled = [args[@"enabled"] boolValue];
        _button.cornerRadius = [args[@"cornerRadius"] floatValue];
        
        [_button addTarget:self
                    action:@selector(onTapped)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (UIView*)view {
    return _button;
}

- (void)onTapped {
    [_channel invokeMethod:@"onTapped" arguments:nil];
}

- (ASAuthorizationAppleIDButtonType)buttonTypeFromString:(NSString*)asiButtonType {
    if ([asiButtonType isEqualToString:@"ASIButtonType.continueButton"]) {
        return ASAuthorizationAppleIDButtonTypeContinue;
    }
    
    if ([asiButtonType isEqualToString:@"ASIButtonType.signIn"]) {
        return ASAuthorizationAppleIDButtonTypeSignIn;
    }
    
    // "ButtonType.defaultType"
    return ASAuthorizationAppleIDButtonTypeDefault;
}


- (ASAuthorizationAppleIDButtonStyle)buttonStyleFromString:(NSString*)asiButtonStyle {
    if ([asiButtonStyle isEqualToString:@"ASIButtonStyle.white"]) {
        return ASAuthorizationAppleIDButtonStyleWhite;
    }
    
    if ([asiButtonStyle isEqualToString:@"ASIButtonStyle.whiteOutline"]) {
        return ASAuthorizationAppleIDButtonStyleWhiteOutline;
    }
    
    // "ButtonStyle.black"
    return ASAuthorizationAppleIDButtonStyleBlack;
}

@end
