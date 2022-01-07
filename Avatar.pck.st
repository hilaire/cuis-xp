'From Cuis 6.0 [latest update: #5041] on 7 January 2022 at 2:40:01 pm'!
'Description A blinking avatar with eyes following the mouse cursor.'!
!provides: 'Avatar' 1 4!
SystemOrganization addCategory: 'Avatar'!


!classDefinition: #AvatarMorph category: 'Avatar'!
BoxedMorph subclass: #AvatarMorph
	instanceVariableNames: 'blink'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Avatar'!
!classDefinition: 'AvatarMorph class' category: 'Avatar'!
AvatarMorph class
	instanceVariableNames: ''!


!AvatarMorph commentStamp: '<historical>' prior: 0!
AvatarMorph new openInWorld .!

!AvatarMorph methodsFor: 'visual properties' stamp: 'HilaireFernandes 10/20/2017 11:10:03'!
defaultColor
	^ Color pink paler paler! !

!AvatarMorph methodsFor: 'drawing' stamp: 'hlsf 1/7/2022 14:32:51'!
drawIrisOn: canvas at: irisCenter
	| center radius shiftedDirection |
	radius _ (extent x min: extent y) // 12.
	shiftedDirection _ (self activeHand morphPosition - (self externalizeToWorld: irisCenter)) normalized * 5.
	center _ irisCenter + shiftedDirection.
	canvas 
		ellipseCenter: center 
		radius: radius asPoint
		borderWidth:  1 
		borderColor: Color black
		fillColor: Color blue! !

!AvatarMorph methodsFor: 'drawing' stamp: 'hlsf 1/7/2022 14:33:13'!
drawLeftEyeOn: canvas
	canvas 
		ellipseCenter: extent // 4 
		radius:  extent // 6 
		borderWidth:  3 
		borderColor: Color black
		fillColor: Color white.
	self drawIrisOn: canvas at: (extent x // 4) @ (extent y// 4)! !

!AvatarMorph methodsFor: 'drawing' stamp: 'hlsf 1/7/2022 14:39:50'!
drawOn: canvas
	canvas 
		ellipseCenter: extent // 2 
		radius: extent // 2 
		borderWidth: borderWidth 
		borderColor: borderColor 
		fillColor: color.
	self drawLeftEyeOn: canvas.
	self drawRightEyeOn: canvas.
	"Mouth, no much option to draw it"
	canvas line: (extent x // 4) @ (extent y * 3 // 4) to: (extent x *3 // 4) @ (extent y * 3 // 4) width: 3 color: Color brown! !

!AvatarMorph methodsFor: 'drawing' stamp: 'HilaireFernandes 10/20/2017 20:51:08'!
drawRightEyeOn: canvas
	blink
	ifFalse: [ 
		canvas 
			ellipseCenterX: extent x * 3 // 4 
			y: extent y // 4 
			rx: extent x // 6
			ry:  extent y // 6 
			borderWidth:  3 
			borderColor: Color black
			fillColor: Color white.
		self drawIrisOn: canvas at: (extent x * 3 // 4) @ (extent y // 4)]
	ifTrue: [
		canvas 
			line: (extent x * 7 // 12) @ (extent y // 4) to: (extent x *11 // 12) @ (extent y // 4) width: 3 color: Color black]
! !

!AvatarMorph methodsFor: 'initialization' stamp: 'HilaireFernandes 10/20/2017 17:14:11'!
initialize
	super initialize.
	extent _ 70@90.
	blink _ false! !

!AvatarMorph methodsFor: 'stepping' stamp: 'HilaireFernandes 10/20/2017 21:34:00'!
step
	blink _ 10 atRandom > 7 .
	self redrawNeeded! !

!AvatarMorph methodsFor: 'stepping' stamp: 'HilaireFernandes 10/20/2017 21:13:30'!
stepTime
	^ 500! !

!AvatarMorph methodsFor: 'stepping' stamp: 'HilaireFernandes 10/20/2017 17:11:03'!
wantsSteps
	^ true! !
