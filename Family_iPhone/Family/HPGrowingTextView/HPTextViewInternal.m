//
//  HPTextViewInternal.m
//
//  Created by Hans Pinckaers on 29-06-10.
//
//	MIT License
//
//	Copyright (c) 2011 Hans Pinckaers
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "HPTextViewInternal.h"

@interface HPTextViewInternal ()
- (void)_initialize;
- (void)_textChanged:(NSNotification *)notification;
@end

@implementation HPTextViewInternal

#pragma mark - Accessors
@synthesize placeholder = _placeholder;
@synthesize placeholderTextColor = _placeholderTextColor;

- (void)setText:(NSString *)string {
//	[super setText:string];
    BOOL originalValue = self.scrollEnabled;
    //If one of GrowingTextView's superviews is a scrollView, and self.scrollEnabled == NO,
    //setting the text programatically will cause UIKit to search upwards until it finds a scrollView with scrollEnabled==yes
    //then scroll it erratically. Setting scrollEnabled temporarily to YES prevents this.
    [self setScrollEnabled:YES];
    [super setText:string];
    [self setScrollEnabled:originalValue];
	[self setNeedsDisplay];
}


- (void)setPlaceholder:(NSString *)string {
	if ([string isEqual:_placeholder]) {
		return;
	}
	
	_placeholder = string;
	[self setNeedsDisplay];
}


- (void)setContentInset:(UIEdgeInsets)contentInset {
    UIEdgeInsets insets = contentInset;
	
	if(contentInset.bottom>8) insets.bottom = 0;
	insets.top = 0;
	[super setContentInset:contentInset];
	[self setNeedsDisplay];
}


- (void)setFont:(UIFont *)font {
	[super setFont:font];
	[self setNeedsDisplay];
}


- (void)setTextAlignment:(NSTextAlignment)textAlignment {
	[super setTextAlignment:textAlignment];
	[self setNeedsDisplay];
}

#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self _initialize];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
    
	if (self.text.length == 0 && self.placeholder) {
		// Inset the rect
		rect = UIEdgeInsetsInsetRect(rect, self.contentInset);
        
		// TODO: This is hacky. Not sure why 8 is the magic number
		if (self.contentInset.left == 0.0f) {
			rect.origin.x += 8.0f;
		}
		rect.origin.y += 8.0f;
        
		// Draw the text
		[_placeholderTextColor set];
		[_placeholder drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
	}
}


#pragma mark - Private

- (void)_initialize {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
	self.backgroundColor = [UIColor clearColor];
	self.placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
}


- (void)_textChanged:(NSNotification *)notification {
	[self setNeedsDisplay];
}



//-(void)setText:(NSString *)text
//{
//    BOOL originalValue = self.scrollEnabled;
//    //If one of GrowingTextView's superviews is a scrollView, and self.scrollEnabled == NO,
//    //setting the text programatically will cause UIKit to search upwards until it finds a scrollView with scrollEnabled==yes
//    //then scroll it erratically. Setting scrollEnabled temporarily to YES prevents this.
//    [self setScrollEnabled:YES];
//    [super setText:text];
//    [self setScrollEnabled:originalValue];
//}

-(void)setContentOffset:(CGPoint)s
{
	if(self.tracking || self.decelerating){
		//initiated by user...
        
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = 0;
        insets.top = 0;
        self.contentInset = insets;
        
	} else {

		float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
		if(s.y < bottomOffset && self.scrollEnabled){            
            UIEdgeInsets insets = self.contentInset;
            insets.bottom = 8;
            insets.top = 0;
            self.contentInset = insets;            
        }
	}
    	
	[super setContentOffset:s];
}

//-(void)setContentInset:(UIEdgeInsets)s
//{
//	UIEdgeInsets insets = s;
//	
//	if(s.bottom>8) insets.bottom = 0;
//	insets.top = 0;
//
//	[super setContentInset:insets];
//}

-(void)setContentSize:(CGSize)contentSize
{
    // is this an iOS5 bug? Need testing!
    if(self.contentSize.height > contentSize.height)
    {
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = 0;
        insets.top = 0;
        self.contentInset = insets;
    }
    
    [super setContentSize:contentSize];
}


//#if !__has_feature(objc_arc)
//- (void)dealloc {
//    [super dealloc];
//}
//#endif


@end
