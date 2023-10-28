'From Cuis 6.0 [latest update: #5940] on 25 July 2023 at 7:00:20 pm'!
!classDefinition: #StandardFileMenu category: 'Goodies-Tools-FileList'!
SelectionMenu subclass: #StandardFileMenu
	instanceVariableNames: 'canTypeFileName pattern excludePattern '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Goodies-Tools-FileList'!

!StandardFileMenu commentStamp: 'hlsf 7/25/2023 17:45:43' prior: 0!
I represent a SelectionMenu which operates like a modal dialog for selecting files, somewhat similar to the StandardFile dialogs in MacOS and Java Swing.

Try for example, the following:

	(StandardFileMenu oldFileFrom: DirectoryEntry smalltalkImageDirectory) inspect
	
	(StandardFileMenu new 
		oldFileFrom: DirectoryEntry smalltalkImageDirectory withPattern: '*.cs' excludePattern: '.*';
		startUpMenu) 	inspect
	
	((StandardFileMenu new 
		newFileFrom: DirectoryEntry smalltalkImageDirectory withPattern: '*.st') startUpWithCaption: 'dale') inspect!


!StandardFileMenu methodsFor: 'private' stamp: 'hlsf 7/25/2023 18:02:11'!
excludePattern: patString
" See method pattern: "

	excludePattern := patString substrings! !

!StandardFileMenu methodsFor: 'private' stamp: 'hlsf 7/25/2023 17:59:48'!
excludePatternMatches: aString
	^excludePattern anySatisfy: [ :pat | pat match: aString ]! !

!StandardFileMenu methodsFor: 'private' stamp: 'hlsf 7/25/2023 17:46:25'!
newFileFrom: aDirectory withPattern: aPattern excludePattern: anotherPattern

	canTypeFileName := true.
	self pattern: aPattern.
	self excludePattern: anotherPattern.
	^self makeFileMenuFor: aDirectory! !

!StandardFileMenu methodsFor: 'private' stamp: 'hlsf 7/25/2023 17:48:02'!
oldFileFrom: aDirectory withPattern: aPattern excludePattern: anotherPattern

	canTypeFileName := false.
	self pattern: aPattern.
	self excludePattern: anotherPattern.
	^self makeFileMenuFor: aDirectory! !


!StandardFileMenu methodsFor: 'private' stamp: 'hlsf 7/25/2023 17:46:51'!
newFileFrom: aDirectory withPattern: aPattern

	self newFileFrom: aDirectory withPattern: aPattern excludePattern: nil! !

!StandardFileMenu methodsFor: 'private' stamp: 'hlsf 7/25/2023 17:48:32'!
oldFileFrom: aDirectory withPattern: aPattern
	self oldFileFrom: aDirectory withPattern: aPattern excludePattern: nil! !

!StandardFileMenu methodsFor: 'menu building' stamp: 'hlsf 7/25/2023 18:09:06'!
directoryNamesString: aDirectory
"Answer a string concatenating the directory name strings in aDirectory, each string followed by a '[...]' indicator, and followed by a newLine."

	^ String streamContents:
		[:s | aDirectory directoryNames do: 
				[:dn |
					(self excludePatternMatches: dn) ifFalse: [
						 s nextPutAll: dn withBlanksTrimmed , ' [...]'; newLine]]]

! !

!StandardFileMenu methodsFor: 'menu building' stamp: 'hlsf 7/25/2023 17:32:11'!
fileNamesString: aDirectory
"Answer a string concatenating the file name strings in aDirectory, each string followed by a newLine."

	^String streamContents: 		[:s | 
		aDirectory fileNames do: 	[:fn |
			((self excludePatternMatches: fn) not 
			and: [self patternMatches: fn]) ifTrue: [
				s nextPutAll: fn withBlanksTrimmed; newLine]]]! !

!StandardFileMenu methodsFor: 'menu building' stamp: 'hlsf 7/25/2023 17:29:05'!
makeFileMenuFor: aDirectory
"Initialize an instance of me to operate on aDirectory"

	| theMenu |
	pattern ifNil: [ self pattern: '*'].
	excludePattern ifNil: [self excludePattern: ''].
	self 
		labels: 	(self menuLabelsString: aDirectory)
		lines: 	(self menuLinesArray: aDirectory).
	theMenu := self selections: (self menuSelectionsArray: aDirectory).
	^theMenu! !

!StandardFileMenu methodsFor: 'menu building' stamp: 'hlsf 7/25/2023 17:37:31'!
menuSelectionsArray: aDirectory
"Answer a menu selections object corresponding to aDirectory.  The object is an array corresponding to each item, each element itself constituting a two-element array, the first element of which contains a selector to operate on and the second element of which contains the parameters for that selector."

	|dirSize|
	dirSize := aDirectory pathComponents size.
	^Array streamContents: [:s |
		canTypeFileName ifTrue:
			[s nextPut: (StandardFileMenuResult
				directory: aDirectory
				name: nil)].
		s nextPut: (StandardFileMenuResult
			directory: (DirectoryEntry roots first)
			name: '').
		aDirectory pathComponents withIndexDo: 
			[:d :i | s nextPut: (StandardFileMenuResult
					directory: (self 
						advance: dirSize - i
						containingDirectoriesFrom: aDirectory)
					name: '')].
		aDirectory directoriesDo:		
			[:dir | 	(self excludePatternMatches: dir name)	 ifFalse: [
					s nextPut: (StandardFileMenuResult
						directory: dir
						name: '')] ].
		aDirectory fileNames do: 
			[:fn | ( (self excludePatternMatches: fn) not and: [self patternMatches: fn]) ifTrue: [
					s nextPut: (StandardFileMenuResult
						directory: aDirectory
						name: fn)]]]! !

!methodRemoval: StandardFileMenu #excludePpattern: stamp: 'hlsf 7/25/2023 17:24:59'!
StandardFileMenu removeSelector: #excludePpattern:!
!classDefinition: #StandardFileMenu category: 'Goodies-Tools-FileList'!
SelectionMenu subclass: #StandardFileMenu
	instanceVariableNames: 'canTypeFileName pattern excludePattern'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Goodies-Tools-FileList'!
