'From Cuis 5.0 [latest update: #4523] on 16 January 2021 at 11:42:40 am'!
'Description '!
!provides: 'Morphic-DrawingTools' 1 21!
!requires: 'VectorGraphics' 1 185 nil!
SystemOrganization addCategory: 'Morphic-DrawingTools'!


!classDefinition: #ToolButtonMorph category: 'Morphic-DrawingTools'!
PluggableButtonMorph subclass: #ToolButtonMorph
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-DrawingTools'!
!classDefinition: 'ToolButtonMorph class' category: 'Morphic-DrawingTools'!
ToolButtonMorph class
	instanceVariableNames: ''!

!classDefinition: #CompassMorph category: 'Morphic-DrawingTools'!
MovableMorph subclass: #CompassMorph
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-DrawingTools'!
!classDefinition: 'CompassMorph class' category: 'Morphic-DrawingTools'!
CompassMorph class
	instanceVariableNames: ''!

!classDefinition: #ProtractorMorph category: 'Morphic-DrawingTools'!
MovableMorph subclass: #ProtractorMorph
	instanceVariableNames: 'previousHandPosition font zeroAtRight'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-DrawingTools'!
!classDefinition: 'ProtractorMorph class' category: 'Morphic-DrawingTools'!
ProtractorMorph class
	instanceVariableNames: ''!

!classDefinition: #RulerMorph category: 'Morphic-DrawingTools'!
MovableMorph subclass: #RulerMorph
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-DrawingTools'!
!classDefinition: 'RulerMorph class' category: 'Morphic-DrawingTools'!
RulerMorph class
	instanceVariableNames: ''!

!classDefinition: #SetSquareMorph category: 'Morphic-DrawingTools'!
MovableMorph subclass: #SetSquareMorph
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-DrawingTools'!
!classDefinition: 'SetSquareMorph class' category: 'Morphic-DrawingTools'!
SetSquareMorph class
	instanceVariableNames: ''!


!ToolButtonMorph commentStamp: '<historical>' prior: 0!
A button with icon or text to plug on a drawing tool!

!ToolButtonMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 1/16/2021 09:40:04'!
drawOn: canvas
	canvas ellipseCenterX: 0 y: 0 rx:  (icon extent // 2) x ry:  (icon extent // 2) y borderWidth: 1 borderColor: Color black fillColor: color.
	canvas image: icon at: 0@0! !

!ProtractorMorph methodsFor: 'drawing' stamp: 'hlsf 1/13/2021 19:57:57'!
drawOn: canvas
|  p1 p2 |
	canvas strokeWidth: 0.2 color: Color black fillColor: (Color yellow alpha: 0.6) do: [: engine |
		engine abs_MoveToX: 100 negated y: 0.
		engine abs_ArcToX: 100 y: 0 radiusX: 100 radiusY: 100 angleOfXAxis: 0 largeFlag: true sweepFlag: true.
		engine abs_LineToX: -100 y: 		0		].
	canvas strokeWidth: 1 color: Color black do: [
		canvas moveToX: 0 y: -0.5; lineToX: 0 y: -8].
	-180 to: 0 do: [:degree |
		canvas strokeWidth: 0.5 color: Color black do: [:engine |
			p1 _ Point r: 100 degrees: degree.
			p2 _ Point r: 95 degrees: degree.
			engine abs_MoveToX: p1 x y: p1 y; abs_LineToX: p2 x y: p2 y]]		.
	-170 to: -10 by: 10 do: [:degree |
		canvas strokeWidth: 1 color: Color black do: [:engine |
			p1 _ Point r: 100 degrees: degree.
			p2 _ Point r: 90 degrees: degree.
			engine abs_MoveToX: p1 x y: p1 y; abs_LineToX: p2 x y: p2 y]].
	-175 to: -5 by: 10 do: [:degree |
		canvas strokeWidth: 0.6 color: Color black do: [:engine |
			p1 _ Point r: 100 degrees: degree.
			p2 _ Point r: 92 degrees: degree.
			engine abs_MoveToX: p1 x y: p1 y; abs_LineToX: p2 x y: p2 y]]! !

!ProtractorMorph methodsFor: 'initialization' stamp: 'hlsf 1/16/2021 11:32:15'!
initialize
	super initialize .
	self setProperty: #'handlesMouseOver:'  toValue: true.
	font _ FontFamily familyName: FontFamily defaultFamilyName pointSize: 4.
	zeroAtRight _ true.
	self updateGraduations.
	self insertButtons ! !

!ProtractorMorph methodsFor: 'initialization' stamp: 'hlsf 1/16/2021 11:41:00'!
insertButtons
| btn |
	btn _ PluggableButtonMorph new label: 'O' font: font.
	"icon: Theme current haloRotateIcon."
	btn model: self; actWhen: #buttonStillDown; action: #rotateProtractor.
	btn setProperty: #balloonText toValue: #helpRotate.
	self addMorph: btn.
	btn morphPosition: 65 @ -8.
	btn _ PluggableButtonMorph new label: '[]' font: font.
	"icon: Theme current haloScaleIcon."
	btn model: self; actWhen: #buttonStillDown; action: #scaleProtractor.
	btn setProperty: #balloonText toValue: #helpScale.
	self addMorph: btn.
	btn morphPosition: 45 @ -8.
	btn _ PluggableButtonMorph new label: '<>' font: font.
	"icon: Theme current undoIcon".
	btn model: self; action: #reverseGraduations.
	btn setProperty: #balloonText toValue: #helpReverse.
	self addMorph: btn.
	btn morphPosition: -80 @ -8.
	btn _ PluggableButtonMorph new label: 'X' font: font.
	"icon: Theme current undoIcon".
	btn model: self; action: #delete.
	btn setProperty: #balloonText toValue: #helpDelete.
	self addMorph: btn.
	btn morphPosition: -60 @ -8! !

!ProtractorMorph methodsFor: 'initialization' stamp: 'hlsf 1/14/2021 21:09:45'!
updateGraduations
	self graduations do: [:each | each delete].
	10 to: 170 by: 10 do: [:angle | 
		self 
			addLabel: (zeroAtRight ifTrue: [angle] ifFalse: [180 - angle]) asString 
			font: font 
			centeredAt: (Point r: 88 degrees: angle negated)
			rotationDegrees: angle].
! !

!ProtractorMorph methodsFor: 'action' stamp: 'hlsf 1/14/2021 21:10:10'!
reverseGraduations
	zeroAtRight _ zeroAtRight not.
	self updateGraduations ! !

!ProtractorMorph methodsFor: 'action' stamp: 'hlsf 1/14/2021 16:43:36'!
rotateProtractor
	| event p1 v1 v2|
	"any thing new to do?"
	self activeHand hasChanged ifFalse: [^self ].
	event _ self activeHand lastMouseEvent.
	event isMove 
		ifTrue: [
			p1 _ location transform: 0@0.
			v1 _ previousHandPosition - p1.
			previousHandPosition _ event eventPosition.
			v2 _ 	previousHandPosition - p1.
			(v1 isZero or: [v2 isZero]) ifTrue: [^self].
			self rotateBy:  ((v1 crossProduct: v2) / (v1 r * v2 r)) arcSin	] 
		ifFalse: [
			previousHandPosition _ event eventPosition].! !

!ProtractorMorph methodsFor: 'action' stamp: 'hlsf 1/14/2021 21:19:36'!
scaleProtractor
	| event p1 v1 v2|
	"any thing new to do?"
	self activeHand hasChanged ifFalse: [^self ].
	event _ self activeHand lastMouseEvent.
	event isMove 
		ifTrue: [
			p1 _ location transform: 0@0.
			v1 _ previousHandPosition - p1.
			previousHandPosition _ event eventPosition.
			v2 _ 	previousHandPosition - p1.
			v1 = v2 ifTrue: [^self].
			self scaleBy:  v2 r / v1 r	] 
		ifFalse: [
			previousHandPosition _ event eventPosition].! !

!ProtractorMorph methodsFor: 'accessing' stamp: 'hlsf 1/14/2021 20:59:29'!
addLabel: string font: aFont centeredAt: position rotationDegrees: angle
"Add a label top-centered at position and rotated of angle degrees"
	| p label |
	p _ position - (position normal * (aFont widthOfString: string asString) / 2). 
	label _ LabelMorph contents: string font: aFont.
	label rotation: (90 - angle) degreesToRadians.
	self addMorph: label.
	label morphPosition: p.
	^ label! !

!ProtractorMorph methodsFor: 'accessing' stamp: 'hlsf 1/15/2021 10:10:30'!
buttons
	^ self submorphsSatisfying: [:each | each is: #PluggableButtonMorph ]! !

!ProtractorMorph methodsFor: 'accessing' stamp: 'hlsf 1/14/2021 20:52:10'!
graduations
	^ self submorphsSatisfying: [:each | each class == LabelMorph]! !

!ProtractorMorph methodsFor: 'events' stamp: 'hlsf 1/15/2021 10:10:59'!
mouseEnter: event
	self buttons do: [:each | each show]! !

!ProtractorMorph methodsFor: 'events' stamp: 'hlsf 1/16/2021 09:43:50'!
mouseLeave: event
	self buttons do: [:each | each hide]
"	| btns | 
	btns _ 	self buttons.
	btns 
		detect: [:btn | btn mouseIsOver] 
		ifNone: [btns do: [:each | each hide]]"! !

!ProtractorMorph methodsFor: 'halos and balloon help' stamp: 'hlsf 1/16/2021 11:41:19'!
helpDelete
	^ 'Close the protractor'! !

!ProtractorMorph methodsFor: 'halos and balloon help' stamp: 'hlsf 1/16/2021 11:37:31'!
helpReverse
	^ 'Change the graduation direction'! !

!ProtractorMorph methodsFor: 'halos and balloon help' stamp: 'hlsf 1/16/2021 11:36:42'!
helpRotate
	^ 'Rotate the protractor'! !

!ProtractorMorph methodsFor: 'halos and balloon help' stamp: 'hlsf 1/16/2021 11:37:07'!
helpScale
	^ 'Change the scale of the protractor'! !

!RulerMorph methodsFor: 'drawing' stamp: 'hlsf 1/12/2021 14:35:14'!
drawOn: canvas
	| length font |
	font _ FontFamily familyName: FontFamily defaultFamilyName pointSize: 4.
	length _ 205.
	canvas strokeWidth: 1 color: Color black fillColor: (Color yellow alpha: 0.8) do: [
		canvas roundRectangleMinX: -5 maxX: length minY: 0 maxY: 40 rx: 2 ry: 5].
	canvas strokeWidth: 0 color: Color black fillColor: (Color yellow alpha: 0.8) do: [
		canvas rectangleMinX: -4 maxX: length - 1 minY:  1 maxY: 15].
	
	canvas strokeWidth: 1 color: Color black do: [
		0 to: length - 5  by: 10 do: [:x |
		canvas moveToX: x y: 0.5;
			lineToX: x y: 5]].
	0 to: length - 5  by: 10 do: [:x |
		canvas drawString: (x//10) asString atCenterX: x@8 font: font color: Color black		].! !

!SetSquareMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 1/12/2021 14:53:50'!
drawOn: canvas
	| length  |
	length _ 205.
	canvas strokeWidth: 1 color: Color black fillColor: (Color yellow alpha: 0.8) do: [
		canvas moveToX: 0 y: 0 negated; lineToX: length / 2.0 y: 0; lineToX: 0 y: length negated].
	canvas strokeWidth: 1 color: Color black fillColor: (Color white alpha: 1 ) do: [
		canvas moveToX: 20 y: 20 negated; lineToX: length / 2.0 -30 y: -20; lineToX: 20 y: length negated + 80]
	
	
	! !
