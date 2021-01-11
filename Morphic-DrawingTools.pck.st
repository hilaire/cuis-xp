'From Cuis 5.0 [latest update: #4520] on 11 January 2021 at 7:59:13 pm'!
'Description '!
!provides: 'Morphic-DrawingTools' 1 5!
!requires: 'VectorGraphics' 1 185 nil!
SystemOrganization addCategory: 'Morphic-DrawingTools'!


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
	instanceVariableNames: ''
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


!RulerMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 1/11/2021 19:59:09'!
drawOn: canvas
	| length font |
	font _ FontFamily familyName: FontFamily defaultFamilyName pointSize: 4.
	length _ 205.
	canvas strokeWidth: 1 color: Color black fillColor: (Color yellow alpha: 0.8) do: [
		canvas roundRectangleMinX: -5 maxX: length minY: 0 maxY: 40 rx: 2 ry: 2].
	canvas strokeWidth: 1 color: Color black do: [
		0 to: length - 5  by: 10 do: [:x |
		canvas moveToX: x y: 0;
			lineToX: x y: 5]].
	0 to: length - 5  by: 10 do: [:x |
		canvas drawString: (x//10) asString atCenterX: x@8 font: font color: Color black		].! !
