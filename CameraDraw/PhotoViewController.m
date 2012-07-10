//
//  PhotoViewController.m
//  CameraDraw
//
//  Created by Lui Marciante on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize imgPicker;
@synthesize label;

BOOL flagPhotoCall = FALSE;
BOOL imageSaved;
BOOL mouseSwiped;	
CGPoint lastPoint;

int mouseMoved;
int butSel = 0;
int butIcon = 0;
int butDraw = 0;
int intRotate = 0;
int last_x = 0;
int last_y = 0;
int size_x = 25;
int size_y =25;
int pensize = 4;

- (void)viewDidLoad
{
    [super viewDidLoad];

    //call the photo picker
    if (flagPhotoCall == FALSE)
        [self getPhoto];
    
}

- (void)viewWillAppear:(BOOL)animated   
{
    if (flagPhotoCall == FALSE)
        [self getPhoto];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(IBAction) eraseDraw {
    
    [imageDraw setImage:nil];
    
    butIcon=0;
    UIImage *btnImage = [UIImage imageNamed:@"36-toolbox.png"];
    //---[toolbox setImage:btnImage forState:UIControlStateNormal];    
    
    btnImage = [UIImage imageNamed:@"pencil.png"];
    //---[crayon setImage:btnImage forState:UIControlStateNormal];
    
}

-(IBAction) getPhoto {
    //ask for the camera or photo picker
    flagPhotoCall = TRUE;
    sheet = [[UIActionSheet alloc] initWithTitle:@"How would you like to build you album?"
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"Take a Picture", @"Choose Picture", nil];
    
    //--butIcon=0;
    //reset toolbox icon, so not to draw on new image till loaded
    //--UIImage *btnImage = [UIImage imageNamed:@"36-toolbox.png"];
    //--[toolbox setImage:btnImage forState:UIControlStateNormal];
    // Show the selection sheet
    [sheet showInView:self.view];
}

-(IBAction) btnCray1 {
    butIcon=0;
    //reset toolbox icon, so not to draw on new image till loaded
    UIImage *btnImage = [UIImage imageNamed:@"icons.png"];
    [toolbox setImage:btnImage forState:UIControlStateNormal];
    
    //select from the toolbox of draw tools
    if (butDraw<=30)
    {
        butIcon=31;
        UIImage *btnImage = [UIImage imageNamed:@"icon-grncrayon.png"];
        [crayon setImage:btnImage forState:UIControlStateNormal];
    }
    size_x = 25;
    size_y = 25;
    pensize = 4;
}

-(IBAction) btnIcon1 {
    butDraw=0;
    UIImage *btnImage = [UIImage imageNamed:@"brush.png"];
    [crayon setImage:btnImage forState:UIControlStateNormal];
    
    NSError *error;
    
    //reference to the docs folder, needs to be there to modify
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *Path = [documentsDirectory stringByAppendingPathComponent:@"Icons.plist"]; //add file name to path
    
    //manipulates files use nsfilemanager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: Path]) //check and see if file does not exists
    {
        NSString *temp = [[NSBundle mainBundle] resourcePath];
        NSString *bundle =  [temp stringByAppendingPathComponent:@"Icons.plist"];
        //copy the plist file
        [fileManager copyItemAtPath:bundle toPath:Path error:&error]; //copy file from bundle to doc folder
    }
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"Icons.plist"];
    NSMutableDictionary *savedDictonary = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    
    //NSString *value = [savedDictonary objectForKey:@"Root"];
    icons = [savedDictonary objectForKey:@"Root"];

    NSString *value =  [icons objectAtIndex:butIcon];
    NSLog(@"num: %@",value);
    
    if (value == Nil)
    {
        butIcon=0;
        //reset toolbox icon, so not to draw on new image till loaded
        UIImage *btnImage = [UIImage imageNamed:@"icons.png"];
        [toolbox setImage:btnImage forState:UIControlStateNormal];
    }
    else 
    {
        btnImage = [UIImage imageNamed:value];
        [toolbox setImage:btnImage forState:UIControlStateNormal];
        icon.image = btnImage;
        butIcon=butIcon+1;
    }
    
    size_x = 25;
    size_y = 25;
    pensize = 4;
}

-(IBAction) addText {
    //label.hidden = FALSE;
    iconText.hidden = FALSE;
    
    UIImage *img = [self textIntoImage:@"TEST" toImage:imageDraw.image]; 
    imageDraw.image = img;
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {  
    
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0f);
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    
    //UIGraphicsBeginImageContext(image1.size); 
    UIGraphicsBeginImageContext(self.view.frame.size);
    //combine 2 images files
    // Draw image1  
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];  
    // Draw image2  
    [image2 drawInRect:CGRectMake(last_x, last_y, size_x, size_y)];  
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    
    return resultingImage;  
} 

- (UIImage *)textIntoImage:(NSString *)text toImage:(UIImage *)img {
    
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0f);
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    
    //UIGraphicsBeginImageContext(image1.size); 
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    CGRect aRectangle = CGRectMake(0,0, img.size.width, img.size.height);
    [img drawInRect:aRectangle];
    
    [[UIColor redColor] set];           // set text color
    NSInteger fontSize = 20;
    if ( [text length] > 200 ) {
        fontSize = 10;
    }
    UIFont *font = [UIFont boldSystemFontOfSize: fontSize];     // set text font
    
    [ text drawInRect : aRectangle                      // render the text
             withFont : font
        lineBreakMode : UILineBreakModeTailTruncation  // clip overflow from end of last line
            alignment : UITextAlignmentCenter ];
    
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();   // extract the image
    UIGraphicsEndImageContext();     // clean  up the context.
    return theImage;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;   
    if (buttonIndex == 0)
    {
        butSel = 1;
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:self.imgPicker animated:YES];
        imageSaved = FALSE;
    }
    else if (buttonIndex == 1)
    {
        butSel = 2;
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:self.imgPicker animated:YES];
        imageSaved = FALSE;
    }
    else if (buttonIndex == 2)
    {
        imageSaved = TRUE;
    }
    
}

//////////////////////


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//start touch
	mouseSwiped = NO;
	//UITouch *touch = [touches anyObject];
    UITouch *touch = [touches anyObject];
    
	lastPoint = [touch locationInView:self.view];
    //offset icon edge
	//lastPoint.y -= 15;
    lastPoint.y -= 0;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //if pen selected draw a continous line, otherwise drop the icon
    //CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    
    //CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    //currentPoint.y -= 20;
    
    if (butIcon >=30)
    {
        //crayon selected draw line
    	mouseSwiped = YES;
        UITouch *touch = [touches anyObject];	
        CGPoint currentPoint = [touch locationInView:self.view];
        currentPoint.y -= 0;
        //currentPoint.y -= 0;
        UIGraphicsBeginImageContext(self.view.frame.size);
        [imageDraw.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        //pen thickness
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), pensize);
        if (butIcon ==31)  //set Green Crayon
        {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
        }
        else if (butIcon ==32)  //set Red Crayon        
        {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
        }    
        else if (butIcon ==33)  //set Blue Crayon
        {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 1.0, 1.0);
        }    
        else if (butIcon ==34)  //set Black
        {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        }
        else if (butIcon ==35)  //set white
        {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);
        }
        else if (butIcon ==36)  //set grey
        {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), .8, .8, .8, .8);
        }
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        imageDraw.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
		
        mouseMoved++;
        //remove sharp movements
        if (mouseMoved == 10) {
            mouseMoved = 0;
        }    
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //once movement complete combine the image files
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];    
    
    //NSLog(@"x = %f",touchPoint.x);
    //NSLog(@"x = %f",touchPoint.y);  
    
    last_x = touchPoint.x;
    last_y = touchPoint.y;  
    size_x = 25;
    size_y = 25;
    pensize = 4;
    
    //NSLog(@"%f - %f",touchPoint.x,touchPoint.y);
    
    UIImage *img = [self addImage:imageDraw.image toImage:icon.image]; 
    imageDraw.image = img;

    if (butIcon >=31)
    {
        
        if(!mouseSwiped) {
            UIGraphicsBeginImageContext(self.view.frame.size);
            [imageDraw.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4.0);
            if (butIcon ==31)  //set Green Crayon
            {
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
            }
            else if (butIcon ==32)  //set Red Crayon        
            {
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
            }    
            else if (butIcon ==33)  //set Blue Crayon
            {
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 1.0, 1.0);
            }  
            else if (butIcon ==34)  //set Black
            {
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);
            }
            else if (butIcon ==35)  //set white
            {
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 0.0);
            }
            else if (butIcon ==36)  //set grey
            {
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), .5, .5, .5, .5);
            }
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            CGContextFlush(UIGraphicsGetCurrentContext());
            imageDraw.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    
}

-(IBAction) longPress:(UILongPressGestureRecognizer *)recognizer {
    
    //NSLog(@"LongPress");
    
    CGPoint touchPoint = [[recognizer valueForKey:@"_startPointScreen"] CGPointValue];    
    
    size_x = 40;
    size_y = 40;
    pensize = 9;
    
    last_x = touchPoint.x;
    last_y = touchPoint.y;
    
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
            UIImage *img = [self addImage:imageDraw.image toImage:icon.image]; 
            imageDraw.image = img;
    }
    
}



//////////////////////

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img  editingInfo:(NSDictionary *)editInfo {
    
    [picker dismissModalViewControllerAnimated:YES];
    
    if(butSel==1){
        //////Camera option selected
        NSData *ImageData = UIImageJPEGRepresentation(img, 0);
        [[NSUserDefaults standardUserDefaults] setObject:ImageData forKey:@"image"];
        UIImage *scaledImage = [UIImage imageWithCGImage:[img CGImage] scale:5 orientation:UIImageOrientationRight];
        
        imagePhoto.image = scaledImage; 
        
        UIImage *tmpimg = [UIImage imageNamed:@"blankdot.png"];
        UIImage *imgmod = [self addImage:imagePhoto.image toImage:tmpimg]; 
        imagePhoto.image = imgmod;
    }
    
    if(butSel == 2){
        //////Photo roll option selected
        NSData *ImageData2 = UIImageJPEGRepresentation(img, 0);
        [[NSUserDefaults standardUserDefaults] setObject:ImageData2 forKey:@"image2"];
        UIImage *scaledImage = [UIImage imageWithCGImage:[img CGImage] scale:5 orientation:UIImageOrientationUp];
        
        imagePhoto.image = scaledImage;
    }
    
    flagPhotoCall = FALSE;
    NSLog(@"%i",flagPhotoCall);
}

///////////////////


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end