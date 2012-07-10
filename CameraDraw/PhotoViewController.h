//
//  PhotoViewController.h
//  CameraDraw
//
//  Created by Lui Marciante on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    
    IBOutlet UIImageView *imageDraw;
    IBOutlet UIImageView *imagePhoto;
    IBOutlet UIImageView *imageSave;
    IBOutlet UIButton *toolbox;
    IBOutlet UIButton *crayon;
    IBOutlet UIImageView *icon;
    IBOutlet UIImageView *iconText;    
    UITextField *label;
    UIImagePickerController *imgPicker;
    UIActionSheet *sheet;
    NSMutableArray *icons;
}

-(IBAction)eraseDraw;
-(IBAction)getPhoto;
-(IBAction)addText;
-(IBAction)btnIcon1;
-(IBAction)btnCray1;

@property(strong,nonatomic) IBOutlet UITextField *label;
@property(nonatomic, retain) UIImagePickerController *imgPicker;

@end
