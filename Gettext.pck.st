'From Cuis 6.0 [latest update: #5090] on 4 March 2022 at 11:13:54 am'!
'Description '!
!provides: 'Gettext' 1 0!
SystemOrganization addCategory: 'Gettext'!


!classDefinition: #GetTextExporter category: 'Gettext'!
Object subclass: #GetTextExporter
	instanceVariableNames: 'stream'
	classVariableNames: ''
	poolDictionaries: 'nil'
	category: 'Gettext'!
!classDefinition: 'GetTextExporter class' category: 'Gettext'!
GetTextExporter class
	instanceVariableNames: ''!

!classDefinition: #LocaleID category: 'Gettext'!
Object subclass: #LocaleID
	instanceVariableNames: 'isoLanguage isoCountry'
	classVariableNames: ''
	poolDictionaries: 'nil'
	category: 'Gettext'!
!classDefinition: 'LocaleID class' category: 'Gettext'!
LocaleID class
	instanceVariableNames: ''!

!classDefinition: #MOFile category: 'Gettext'!
Object subclass: #MOFile
	instanceVariableNames: 'localeID fileName isLittleEndian magic revision nStrings originalTableOffset translatedTableOffset hashTableSize hashTableOffset hashTable originalStrings translatedStrings translations'
	classVariableNames: 'Cr Lf'
	poolDictionaries: 'nil'
	category: 'Gettext'!
!classDefinition: 'MOFile class' category: 'Gettext'!
MOFile class
	instanceVariableNames: ''!

!classDefinition: #NaturalLanguageTranslator category: 'Gettext'!
Object subclass: #NaturalLanguageTranslator
	instanceVariableNames: 'id'
	classVariableNames: 'Translators'
	poolDictionaries: 'nil'
	category: 'Gettext'!
!classDefinition: 'NaturalLanguageTranslator class' category: 'Gettext'!
NaturalLanguageTranslator class
	instanceVariableNames: ''!

!classDefinition: #GetTextTranslator category: 'Gettext'!
NaturalLanguageTranslator subclass: #GetTextTranslator
	instanceVariableNames: 'moFiles'
	classVariableNames: 'LocaleDirsForDomain SystemDefaultLocaleDirs UserDefaultLocaleDirs'
	poolDictionaries: 'nil'
	category: 'Gettext'!
!classDefinition: 'GetTextTranslator class' category: 'Gettext'!
GetTextTranslator class
	instanceVariableNames: ''!

!classDefinition: #TextDomainInfo category: 'Gettext'!
Object subclass: #TextDomainInfo
	instanceVariableNames: 'categoryPrefixes categories'
	classVariableNames: ''
	poolDictionaries: 'nil'
	category: 'Gettext'!
!classDefinition: 'TextDomainInfo class' category: 'Gettext'!
TextDomainInfo class
	instanceVariableNames: ''!

!classDefinition: #TextDomainManager category: 'Gettext'!
Object subclass: #TextDomainManager
	instanceVariableNames: ''
	classVariableNames: 'ClassCategories Classes DefaultDomain DomainInfos LoneClasses'
	poolDictionaries: 'nil'
	category: 'Gettext'!
!classDefinition: 'TextDomainManager class' category: 'Gettext'!
TextDomainManager class
	instanceVariableNames: ''!

!classDefinition: #TranslatedReceiverFinder category: 'Gettext'!
Object subclass: #TranslatedReceiverFinder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'nil'
	category: 'Gettext'!
!classDefinition: 'TranslatedReceiverFinder class' category: 'Gettext'!
TranslatedReceiverFinder class
	instanceVariableNames: ''!


!GetTextExporter commentStamp: '' prior: 0!
Export translations to gettext format divided into categories.

"Export gettext template files"
GetTextExporter new exportTemplate.

"Export translation files for current locale"
GetTextExporter new exportTranslator: (InternalTranslator newLocaleID: LocaleID current).

"Export all gettext template and po files."
GetTextExporter exportAll.

"To register a class category as a new domain"
TextDomainManager registerClassCategory: 'Morphic-Books' domain: 'Book'.
"Remove a class category"
TextDomainManager unregisterClassCategory: 'Morphic-Books'.!

!LocaleID commentStamp: '' prior: 0!
The ID for localization!

!MOFile commentStamp: '' prior: 0!
Wrapper for MO file of gettext.
Known limitation:  
	currently don't support prural form.
	translation strings have to be encoded in utf-8.

Implementation notes:
	Testing on XO showed emulation of hash search without plugin + on demand loading is slow.
	The test also showed conversion of utf8 string to Squeak's String is really slow (especially for non-latin language).
	so in this version, all of original/translated strings are loaded on initiaization,
	but "translated strings" is left as ByteString on loading time, to reduce loading time.
	After that the translated string is converted on demand. 
!

!NaturalLanguageTranslator commentStamp: '' prior: 0!
abstract class of natural language translator.
Class side manages and holds loaded instances of concrete classes.!

!GetTextTranslator commentStamp: '' prior: 0!
emulation of gettext runtime
Known limitation:  
     currently don't support prural form.
!

!TextDomainInfo commentStamp: '' prior: 0!
I hold criteria for deciding wheter a systemCategory belongs to domain. 
- categoryPrefixes is collection of prefix of class category.
- categories is for specifying fine grained criterion.
!

!TextDomainManager commentStamp: '' prior: 0!
I manages mapping from class category to textdomain.

Class variables:
 ClassCategories	IdentityDictionary -- classCategory -> domainName 
 Classes			IdentityDictionary -- class name (a Symbol) -> domainName   (a cache only!!)
 DefaultDomain	String -- the default domain name
 DomainInfos		Dictionary -- domainName -> a TextDomainInfo
 LoneClasses		IdentityDictionary -- class name (a Symbol) -> domainName.  For classes whose entire category are not all in the same domain (BookMorph and QuickGuideMorph)

TextDomainManager registerCategoryPrefix: 'DrGeoII' domain: 'DrGeoII'.
TextDomainManager unregisterDomain: 'DrGeoII'.

TextDomainManager registerClass: #QuickGuideMorph domain: 'quickguides'.
TextDomainManager registerClass: #QuickGuideHolderMorph  domain: 'quickguides'.
!

!TranslatedReceiverFinder commentStamp: '' prior: 0!
I am a utility class of Gettext. Most uses are internal to Gettext.

You can use me to browse all methods sending translation messages to non-string receivers:

	TranslatedReceiverFinder browseNonLiteralReceivers!

!LocaleID methodsFor: 'printing'!
printOn: stream
	"<language>-<country>"
	stream nextPutAll: self isoLanguage.
	self isoCountry
		ifNotNil: [stream nextPut: $-; nextPutAll: self isoCountry]! !

!LocaleID methodsFor: 'printing'!
storeOn: aStream 
	aStream nextPut: $(.
	aStream nextPutAll: self class name.
	aStream nextPutAll: ' isoString: '.
	aStream nextPutAll: '''' , self printString , ''''.
	aStream nextPut: $).
! !

!NaturalLanguageTranslator class methodsFor: 'class initialization'!
startUp: resuming 
	resuming
		ifFalse: [^ self].
	self privateStartUp.! !

!NaturalLanguageTranslator methodsFor: 'printing'!
printOn: aStream
	aStream nextPutAll: self class name; nextPut: $(; print: self localeID; nextPut: $)! !

!GetTextExporter methodsFor: 'exporting'!
appendTranslations: domains 

	self 
		appendTranslations: domains 
		for: self class defaultSelectors ! !

!GetTextExporter methodsFor: 'exporting'!
appendTranslations: domains for: someSelectors
	"Append translations in the given domains.
	Will be done by searching for strings receiving the given selectors"

	someSelectors do:[ :selector |
		self appendStringReceivers: selector into: domains]
! !

!GetTextExporter methodsFor: 'exporting'!
dirNameCategory: category translator: translator 
	"Answer a file name for the category. Make one if it is not exist yet.
	Make template file name if translator is nil"
	"self new dirNameCategory: 'Morphic-Scripting Support' translator:
	NaturalLanguageTranslator current"
	"self new dirNameCategory: 'Morphic-Scripting Support' translator: nil"
	| safeCategory fileName dirName pathName |
	safeCategory _ category copyReplaceAll: ' ' with: ':='.
	fileName _ translator
				ifNil: [safeCategory , '.pot']
				ifNotNil: [translator localeID posixName , '.po'].
	dirName _ (safeCategory findTokens: '-')
				inject: 'po'
				into: [:aString :next | aString , FileSystem disk delimiter asString , next].
	pathName _ dirName , FileSystem disk delimiter asString , fileName.
	(dirName asFileReference ensureCreateDirectory).
	^ pathName! !

!GetTextExporter methodsFor: 'exporting'!
dirNameDomain: domain translator: translator 
	"Answer a file name for the domain. Make one if it is not exist yet.
	Make template file name if translator is nil"
	"self new dirNameDomain: 'etoys' translator:
	NaturalLanguageTranslator current"
	"self new dirNameDomain: 'etoys' translator: nil"
	| fileName dirName pathName |
	"safeCategory _ category copyReplaceAll: ' ' with: ':='."
	fileName _ translator
				ifNil: [domain , '.pot']
				ifNotNil: [translator localeID posixName , '.po'].
	dirName _ 'po', FileSystem disk delimiter asString , domain.
	pathName _ dirName ,  FileSystem disk delimiter asString , fileName.
	(dirName asFileReference ensureCreateDirectory).
	^ pathName! !

!GetTextExporter methodsFor: 'exporting'!
exportTemplate
	"GetTextExporter new exportTemplate"
	self exportTranslator: nil! !

!GetTextExporter methodsFor: 'exporting'!
exportTranslator: translator 
	"Export translation files. the file extention is 'po', or 'pot' if translator is nil "
	"GetTextExporter new exportTranslator: NaturalLanguageTranslator current "
	
	self 
		exportTranslator: translator 
		for: self class defaultSelectors ! !

!GetTextExporter methodsFor: 'exporting'!
exportTranslator: translator for: someSelectors
	"Export translation files. the file extention is 'po', or 'pot' if translator is nil "
	"GetTextExporter new exportTranslator: NaturalLanguageTranslator current "
	| domains |
	domains _ Dictionary new.
	self appendTranslations: domains for: someSelectors.
	domains
		keysAndValuesDo: [:domainName :value |
			self
				export: value
				translator: translator
				domain: domainName]! !

!GetTextExporter methodsFor: 'file out'!
exportBody: literals translator: translator 
	"Export a gettext file body. literals is a dictionary of keyword ->
	#(MethodReference...) in the textDomain."
	"Build {sortKey. comment. msgid } to optimize sorting (getting category is
	too slow).
	If there are two or more methods for a mgsid, only first method
	(alphabetical) is used for sorting."
	| sorted msgid sortedMethods category sortKey comment triplets commentUnderLined |
	triplets _ literals associations
				collect: [:assoc | 
					msgid _ assoc key.
					sortedMethods _ assoc value asArray sort.
					category _ (Smalltalk at: sortedMethods first theNonMetaClassName) category asString.
					sortKey _ category , ',' , sortedMethods first printString , ',' , msgid.
					comment _ (sortedMethods
								collect: [:each | each actualClass asString , '>>' , each selector asString])
								inject: category
								into: [:result :methodName | result , ',' , methodName].
					"Replace white spaces to _ because gettext tool might
					replace a space to a new line some times, and it makes
					difficult to take a diff."
					commentUnderLined _ comment copyReplaceAll: ' ' with: ':='.
					Array
						with: sortKey
						with: commentUnderLined
						with: msgid].
	"Sort and output the words"
	sorted _ triplets
				sort: [:a :b | a first <= b first].
	sorted
		do: [:triplet | 
			comment _ triplet second.
			msgid _ triplet third.
			self exportRecordHeader: comment.
			self
				exportPhrase: msgid
				translation: (self translationFor: msgid in: translator)]! !

!GetTextExporter methodsFor: 'accessing'!
stream
	^ stream! !

!GetTextExporter methodsFor: 'accessing'!
stream: aStream
	stream _ aStream! !

!GetTextExporter methodsFor: 'private'!
appendStringReceivers: aSymbol into: domains
	| literals references domainName methodReference keywords found |
	
	found _ TranslatedReceiverFinder new stringReceiversOf: aSymbol.
	found do: [ :assoc |
		methodReference _ assoc key.
		keywords _ assoc value.
		domainName _ self getTextDomainForClassCategory:
			(Smalltalk at: methodReference theNonMetaClassName) category.
		literals _ domains at: domainName ifAbsentPut: [Dictionary new].
		keywords do: [ :literal |
			references _ literals at: literal ifAbsentPut: [OrderedCollection new].
			references add: methodReference.
		].
	]. 
! !

!GetTextExporter methodsFor: 'private'!
createHeaders
	| headers |
	headers _ OrderedCollection new.
	headers add: 'Project-Id-Version' -> 'Pharo'.
	headers add: 'POT-Creation-Date' -> self currentDateAndTime.
	headers add: 'PO-Revision-Date' -> self currentDateAndTime.
	headers add: 'Last-Translator' -> ''.
	headers add: 'Language-Team' -> ''.
	headers add: 'MIME-Version' -> '1.0'.
	headers add: 'Content-Type' -> ('text/plain; charset=', stream converter class encodingNames first).
	headers add: 'Content-Transfer-Encoding' -> '8bit'.
	headers add: 'X-Pharo-SystemVersion' -> (SystemVersion current asString).
	^ headers! !

!GetTextExporter methodsFor: 'private'!
currentDateAndTime
	^ String
		streamContents: [:aStream | 
			aStream nextPutAll: Date today yyyymmdd;
				space.
			Time now
				print24: true
				showSeconds: false
				on: aStream.
			aStream nextPutAll: '-0000']! !

!GetTextExporter methodsFor: 'private'!
export: literals translator: translator domain: domainName 
	| fileName |
	"Export a gettext file in a category. literals is a dictionary of keyword -> #(MethodReference...) in the textDomain."
	fileName _ self dirNameDomain: domainName translator: translator.
	[stream _ FileStream forceNewFileNamed: fileName.
	stream lineEndConvention: #lf.
	stream converter: UTF8TextConverter new.
	self exportHeader: domainName.
	self exportBody: literals translator: translator]
		ensure: [stream close]! !

!GetTextExporter methodsFor: 'private'!
exportHeader: domainName
	| headers |
	self exportTag: 'msgid' msg: ''.
	self exportTag: 'msgstr' msg: ''.
	headers _ self createHeaders.
	headers add: 'X-Pharo-Domain' -> domainName.
	headers do: [:each | self exportHeaderLineKey: each key value: each value].
	stream cr; cr! !

!GetTextExporter methodsFor: 'private'!
exportHeaderLineKey: keyString value: valueString 
	stream nextPut: $";
		 nextPutAll: keyString;
		 nextPut: $:;
		 space;
		 nextPutAll: valueString;
		 nextPutAll: '\n';
		 nextPut: $";
		 cr.! !

!GetTextExporter methodsFor: 'private'!
exportPhrase: phraseString translation: translationString 
	| normalizedTrans tmp transStartsWithCR transEndsWithCR|
	phraseString isEmpty
		ifTrue: [^ self].
	self exportTag: 'msgid' msg: phraseString.
	translationString size = 0 ifTrue: [
		normalizedTrans _ ''
	] ifFalse: [
		transEndsWithCR _ translationString last = (Character cr).
		phraseString last = (Character cr) ifTrue: [
			transEndsWithCR ifTrue: [
				normalizedTrans _ translationString
			] ifFalse: [
				normalizedTrans _  translationString , String cr
			]
		] ifFalse: [
			transEndsWithCR ifTrue: [
				normalizedTrans _ translationString allButLast
			] ifFalse: [
				normalizedTrans _ translationString
			]
		].
		transStartsWithCR _ normalizedTrans first = (Character cr).
		phraseString first = (Character cr) ifTrue: [
			transStartsWithCR ifFalse: [
				tmp _ (Character cr asString) , normalizedTrans.
				normalizedTrans _ tmp.
			]
		] ifFalse: [
			transStartsWithCR ifTrue: [
				normalizedTrans _ normalizedTrans allButFirst
			]
		]
	].
	self exportTag: 'msgstr' msg: normalizedTrans.
	stream cr! !

!GetTextExporter methodsFor: 'private'!
exportRecordHeader: context
	stream 
		nextPutAll: '#: ';
		nextPutAll: context;
		cr.! !

!GetTextExporter methodsFor: 'private'!
exportTag: tag msg: aString 
	| pos end line |
	(aString indexOf: Character cr)
			= 0
		ifTrue: [self exportTag: tag singleLine: aString]
		ifFalse: [self exportTag: tag singleLine: ''.
			pos _ 1.
			end _ 0.
			[end < aString size]
				whileTrue: [end _ aString indexOf: Character cr startingAt: pos.
					end = 0
						ifTrue: [end _ aString size].
					line _ aString copyFrom: pos to: end.
					stream nextPut: $";
						
						nextPutAll: (self formatString: line);
						 nextPut: $";
						 cr.
					pos _ end + 1]]! !

!GetTextExporter methodsFor: 'private'!
exportTag: tag singleLine: aString 
	stream nextPutAll: tag.
	stream space.
	stream nextPut: $".
	stream
		nextPutAll: (self formatString: aString).
	stream nextPut: $".
	stream cr! !

!GetTextExporter methodsFor: 'private'!
formatReplacements
	| replacements |
	replacements _ OrderedCollection new.
	replacements add: '\' -> '\\'.
	replacements add: String cr -> '\r'.
	replacements add: String tab -> '\t'.
	replacements add: '"' -> '\"'.
	^ replacements! !

!GetTextExporter methodsFor: 'private'!
formatString: aString 
	| result |
	result _ aString.
	self formatReplacements
		do: [:each | result _ result copyReplaceAll: each key with: each value].
	^ result! !

!GetTextExporter methodsFor: 'private'!
getTextDomainForClassCategory: aClassCategory
	^TextDomainManager domainForClassCategory:  aClassCategory
		! !

!GetTextExporter methodsFor: 'private'!
translationFor: aKey in: translator
	translator ifNil: [^''].
	translator translations at: aKey ifPresent: [:s | ^s].
	"If we have old camelCase translations, make space-separated words"
	translator translations at: aKey toCamelCase ifPresent: [:s | 
		(s includes: Character space) ifTrue: [^s].
		^s fromCamelCase].
	^''! !

!GetTextExporter class methodsFor: 'utilities'!
exportTemplate
	"GetTextExporter exportTemplate"
	self new exportTemplate! !

!GetTextExporter class methodsFor: 'utilities'!
exportTemplateFor: someSelectors
	"Writes files to be used as the translation template.
	It will include strings that are receivers of any of someSelectors"
	
	self new exportTranslator: nil for: someSelectors ! !

!GetTextExporter class methodsFor: 'utilities'!
exportTemplateIncluding: aSelector
	"Writes files to be used as the translation template.
	It will include strings that are receivers of aSelector"
	
	self exportTemplateFor: self defaultSelectors, {aSelector} ! !

!GetTextExporter class methodsFor: 'utilities'!
keys
	| categories |
	categories _ Dictionary new.
	GetTextExporter new appendTranslations: categories.
	^ categories values
		inject: Set new
		into: [:set :next | set addAll: next keys;
				 yourself]! !

!GetTextExporter class methodsFor: 'utilities'!
listAllHelp
	"self listAllHelp"
	| spec specs oCatalog flap flapSelectors allKeys oCatalogHelp flapHelp |
	oCatalog _ Dictionary new.
	Morph withAllSubclasses
		do: [:aClass | (aClass class includesSelector: #descriptionForPartsBin)
				ifTrue: [spec _ aClass descriptionForPartsBin.
					oCatalog at: spec formalName put: spec documentation]].
	Morph withAllSubclasses
		do: [:aClass | (aClass class includesSelector: #supplementaryPartsDescriptions)
				ifTrue: [specs _ aClass supplementaryPartsDescriptions.
					specs
						do: [:each | oCatalog at: each formalName put: each documentation]]].
	flap _ Dictionary new.
	flapSelectors _ #(#defaultsQuadsDefiningPlugInSuppliesFlap #defaultsQuadsDefiningStackToolsFlap #defaultsQuadsDefiningSuppliesFlap #defaultsQuadsDefiningToolsFlap #defaultsQuadsDefiningWidgetsFlap #defaultsQuadsDefiningScriptingFlap ).
	flapSelectors
		do: [:selector | 
			specs _ Flaps perform: selector.
			specs
				do: [:each | flap at: each third put: each fourth]].
	allKeys _ oCatalog keys intersection: flap keys.
	allKeys asArray sort
		do: [:each | 
			oCatalogHelp _ oCatalog
						at: each
						ifAbsent: [''].
			flapHelp _ flap
						at: each
						ifAbsent: [''].
			oCatalogHelp = flapHelp
				ifFalse: [Transcript cr; show: 'Name: ' , each.
					Transcript cr; show: 'O: ' , oCatalogHelp.
					Transcript cr; show: 'F: ' , flapHelp.
					Transcript cr.

]]! !

!GetTextExporter class methodsFor: 'accessing'!
defaultSelectors
	"Answers the selectors that are sent to strings that should be translated"
	
	^ #(
		#translated 
		#translatedNoop
		)! !

!LocaleID methodsFor: 'printing'!
posixName
	"(LocaleID isoString: 'es-MX') posixName"
	"(LocaleID isoString: 'es') posixName"
	"language[_territory]"
	^ self isoCountry
		ifNil: [self isoLanguage]
		ifNotNil: [self isoLanguage , '_' , self isoCountry]! !

!LocaleID methodsFor: 'comparing'!
= anotherObject
	self class == anotherObject class
		ifFalse: [^false].
	^self isoLanguage = anotherObject isoLanguage
		and: [self isoCountry = anotherObject isoCountry]! !

!LocaleID methodsFor: 'comparing'!
hash
	^self isoLanguage hash bitXor: self isoCountry hash! !

!LocaleID methodsFor: 'testing'!
hasParent
	^self isoCountry notNil! !

!LocaleID methodsFor: 'initialize'!
isoLanguage: langString isoCountry: countryStringOrNil
	isoLanguage _ langString.
	isoCountry _ countryStringOrNil! !

!LocaleID methodsFor: 'accessing'!
displayCountry
	^(ISOLanguageDefinition iso2Countries at: self isoCountry asUppercase ifAbsent: [ self isoCountry ]) ! !

!LocaleID methodsFor: 'accessing'!
displayLanguage
	| language |
	language _ (ISOLanguageDefinition iso2LanguageTable
				at: self isoLanguage
				ifAbsent: [^ self isoLanguage]) language.
	^ self isoCountry
		ifNil: [language]
		ifNotNil: [language , ' (' , self displayCountry , ')']! !

!LocaleID methodsFor: 'accessing'!
isoCountry
	^isoCountry! !

!LocaleID methodsFor: 'accessing'!
isoLanguage
	^isoLanguage! !

!LocaleID methodsFor: 'accessing'!
isoString
	^self asString! !

!LocaleID methodsFor: 'accessing'!
parent
	^self class isoLanguage: self isoLanguage! !

!LocaleID methodsFor: 'accessing'!
translator
	^ NaturalLanguageTranslator localeID: self ! !

!LocaleID class methodsFor: 'accessing'!
current
	^Locale current localeID! !

!LocaleID class methodsFor: 'accessing'!
previous
	^Locale previous localeID! !

!LocaleID class methodsFor: 'instance creation'!
isoLanguage: langString
	^self isoLanguage: langString isoCountry: nil! !

!LocaleID class methodsFor: 'instance creation'!
isoLanguage: langString isoCountry: countryStringOrNil
	^self new isoLanguage: langString isoCountry: countryStringOrNil! !

!LocaleID class methodsFor: 'instance creation'!
isoString: isoString
	"Parse the isoString (<language>-<country>) into its components and return the matching LocaleID"
	"LocaleID isoString: 'en' "
	"LocaleID isoString: 'en-us' "

	| parts language country |
	parts _ isoString findTokens: #($- ).
	language _ parts first.
	parts size > 1
		ifTrue: [country _ parts second].
	^self isoLanguage: language isoCountry: country! !

!LocaleID class methodsFor: 'instance creation'!
posixName: aString 
	^ self
		isoString: (aString copyReplaceAll: '_' with: '-')! !

!LocaleID class methodsFor: 'accessing-defaults'!
default
	^ self isoLanguage: 'en'! !

!MOFile methodsFor: 'experimental'!
hashPjw: aString
	"This is the hash function used by the (unused) hashTable. Kept in case someone wants to try and make it work"
	"So called `hashpjw' function by P.J. Weinberger
   	[see Aho/Sethi/Ullman, COMPILERS: Principles, Techniques and Tools,
   	1986, 1987 Bell Telephone Laboratories, Inc.] "
	| stringSize hash g |
	stringSize _ aString size.
	hash _ 0.
	1 to: stringSize do: [:pos |
		hash _ hash bitShift: 4.
		hash _ hash + ((aString at: pos) asInteger).
		g _ hash bitAnd: 16rF0000000.
		g = 0 ifFalse: [
			hash _ hash  bitXor: (g bitShift: -24).
			hash _ hash bitXor: g.
		]
	].
	^hash.
! !

!MOFile methodsFor: 'public'!
atRandom

	^translatedStrings at: nStrings atRandom.
! !

!MOFile methodsFor: 'public'!
fileName
	^fileName! !

!MOFile methodsFor: 'public'!
fileName: path
	fileName _ path! !

!MOFile methodsFor: 'public'!
load: aFileName localeID: id
	"all of strings are loaded. 
	translation strings are converted to internal string format on load time.
	original-string/index pairs are registerd to Dictionary on load time."
	localeID _ id.
	FileStream readOnlyFileNamed: aFileName do: [:strm | |originalTable translatedTable|
	fileName _ aFileName.
	self loadHeader: strm.
	
	originalTable _ self loadStringPointers: strm 
									offset: originalTableOffset.
									
	translatedTable _ self loadStringPointers: strm 
										offset: translatedTableOffset.

	originalStrings _ self loadStrings: strm 
							pointers: originalTable.

	translatedStrings _ self loadStrings: strm 
								pointers: translatedTable.

	translations _ Dictionary new: nStrings.  
	1 to: nStrings do: [:index |
		| key |
		key _ originalStrings at: index.
		translations at: key put: index.].
	
	originalStrings _ nil] ! !

!MOFile methodsFor: 'public'!
searchFor: aString
	| index |
	index _ translations at: aString ifAbsent: [^nil].
	^translatedStrings at: index.
	
! !

!MOFile methodsFor: 'public'!
translationFor: aString 
	aString size = 0 ifTrue: [^ '']. "Gettext header"
	^ (self searchFor: aString) ifNil: [aString]
! !

!MOFile methodsFor: 'private'!
loadHeader: strm
	strm binary.
	magic _  strm uint32.
	magic = 16rDE120495 
		ifTrue: [isLittleEndian _ true]
		ifFalse: [
			magic = 16r950412DE 
				ifTrue: [isLittleEndian _ false]
				ifFalse: [ self error: 'invalid MO']
		].
	revision _ self nextInt32From: strm.
	nStrings _ self nextInt32From: strm.
	originalTableOffset _ self nextInt32From: strm.
	translatedTableOffset _ self nextInt32From: strm.
	hashTableSize _ self nextInt32From: strm.
	hashTableOffset _ self nextInt32From: strm.
! !

!MOFile methodsFor: 'private'!
loadStringPointers: strm offset: tableOffset
	"returns tupple {arrayOfOffsetToString  arrayOfLengthOfString}"
	| offsetTable lenTable len offset tupple |
	offsetTable _ IntegerArray new: nStrings.
	lenTable _ IntegerArray new: nStrings.
	strm binary.
	strm position: tableOffset.
	1 to: nStrings do: [:index |
		len _ self nextInt32From: strm.
		offset _ self nextInt32From: strm.
		offsetTable at: index put: offset.
		lenTable at: index put: len.
	].
	tupple _ Array new: 2.
	tupple at: 1 put: offsetTable.
	tupple at: 2 put:  lenTable.
	^tupple
! !

!MOFile methodsFor: 'private'!
loadStrings: strm pointers: table
	"We convert string encoding at load time.
	Currently, we do not take care to set the leadingChar for a languageEnvironment"
	^self loadStrings: strm pointers: table encoding: #utf8 languageEnvironment: nil
! !

!MOFile methodsFor: 'private'!
loadStrings: strm pointers: tupple encoding: encodingName languageEnvironment: env
	| offsetTable lenTable strings |
	strm ascii; 
		converter: (TextConverter newForEncoding: encodingName).
	offsetTable _  tupple first.
	lenTable _ tupple second.
	strings _ Array new: nStrings.
	1 to: nStrings do: [:index | |  rawStr start byteLength endPos|
		start _ offsetTable at: index.
		byteLength _ lenTable at: index.
		endPos _ start + byteLength.
		rawStr _  (String new: byteLength) writeStream.
		strm position:  start.
		[strm position < endPos] whileTrue: [rawStr nextPut: strm next].
		strings at: index put: rawStr contents.
		

	].
	^strings.! !

!MOFile methodsFor: 'private'!
nextInt32From: strm
	^isLittleEndian 
			ifTrue: [^strm nextLittleEndianNumber: 4]
			ifFalse: [^strm nextInt32]! !

!MOFile class methodsFor: 'class initialization'!
initialize
	Cr _ Character cr.
	Lf _ Character lf.
! !

!MOFile class methodsFor: 'instance creation'!
fileName: path localeID: id
	^self new 
			load:path localeID: id! !

!NaturalLanguageTranslator methodsFor: 'translation'!
translate: aString inDomain: aDomainName
	^ aString! !

!NaturalLanguageTranslator methodsFor: 'accessing'!
atRandom

	self subclassResponsibility.
! !

!NaturalLanguageTranslator methodsFor: 'accessing'!
domainRegistered: aDomainName
	"notify that new TextDomain is registered.  Concrete subclass can responds to this event if needed"! !

!NaturalLanguageTranslator methodsFor: 'accessing'!
domainUnregistered: aDomainName
	"notify that new TextDomain is unregistered.  Concrete subclass can responds to this event if needed"! !

!NaturalLanguageTranslator methodsFor: 'accessing'!
isDomainLoaded: aDomainName
	"ask if translation dictionary for the domain has been loaded and available now for use"
	self subclassResponsibility.! !

!NaturalLanguageTranslator methodsFor: 'accessing'!
localeID
	^id! !

!NaturalLanguageTranslator methodsFor: 'accessing'!
localeID: anID
	id _ anID! !

!NaturalLanguageTranslator methodsFor: 'language switching'!
setCurrent
	"notify locale of the translator become current"
! !

!NaturalLanguageTranslator class methodsFor: 'class initialization'!
initialize
	(Smalltalk classNamed: #SessionManager)
		ifNotNil: [:sessionManagerClass|
			sessionManagerClass default
				registerSystemClassNamed: self name
				atPriority: 100]
		ifNil: [Smalltalk addToStartUpList: NaturalLanguageTranslator after: FileLocator].
	
	! !

!NaturalLanguageTranslator class methodsFor: 'class initialization'!
privateStartUp
	self reset.
	GetTextTranslator reset.
	self localeChanged.! !

!NaturalLanguageTranslator class methodsFor: 'actions'!
reset
	"Flush the translator instances"
	
	Translators _ nil! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
availableForLocaleID: localeID 
	"Answer available locale ID.
	If translator is not found for correct locale ID, then isoLanguage is
	attempted for the key."
	^ self translators
		at: localeID
		ifAbsent: [localeID hasParent
				ifTrue: [self translators
						at: localeID parent
						ifAbsent: [self default]]
				ifFalse: [self default]] ! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
availableLanguageLocaleIDs
	"Return the locale ids for the currently available languages.  
	Meaning those which either internally or externally have  
	translations available."
	"NaturalLanguageTranslator availableLanguageLocaleIDs"
	^ self translators values collect:[:each | each localeID]! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
current
	^ self availableForLocaleID: LocaleID current! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
current: aTranslator
	"Register a translator that should receiver the translation messages"
	
	Current _ aTranslator! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
default
	"Answer translator for backstop"
	"self default translate: 'test'"
	^ self new
		localeID: (LocaleID isoLanguage: 'en')! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
domainRegistered: aDomainName
	"notify that new TextDomain is registered"
	self translators do: [:each | each domainRegistered: aDomainName]! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
domainUnregistered: aDomainName
	"notify that new TextDomain is unregistered"
	self translators do: [:each | each domainUnregistered: aDomainName]! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
localeChanged
	"notify some project starts to use this locale.
	 this facility may use the event to load translation data dynamically" 
	self current setCurrent
! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
removeLocaleID: localeID 
	"self removeLocaleID: (LocaleID isoString: 'ja-kids')"
	^ self translators
		removeKey: localeID
		ifAbsent: []! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
resetCaches

	self deprecated: 'Use #reset'.
	
	Translators _ nil.! !

!NaturalLanguageTranslator class methodsFor: 'accessing'!
translators
	^ Translators ifNil: [Translators _ Dictionary new]	! !

!NaturalLanguageTranslator class methodsFor: 'translation'!
translate: aString
	^ self translate: aString toLocale: LocaleID current! !

!NaturalLanguageTranslator class methodsFor: 'translation'!
translate: aString toLocale: localeID
	| here domain |
	here _ thisContext sender sender sender methodClass.
	domain _ TextDomainManager domainForClass: here.
	^ self translate: aString toLocale: localeID inDomain: domain! !

!NaturalLanguageTranslator class methodsFor: 'translation'!
translate: aString toLocale: localeID inDomain: aDomainName
	^ (self availableForLocaleID: localeID)
		translate: aString inDomain: aDomainName! !

!NaturalLanguageTranslator class methodsFor: 'cleanup'!
cleanUp
	AllKnownPhrases _ nil! !

!GetTextTranslator methodsFor: 'accessing'!
atRandom

	| v |
	moFiles ifEmpty: [^ ''].
	(v _ moFiles atRandom value) ifNil: [^ ''].
	^ v atRandom.
! !

!GetTextTranslator methodsFor: 'accessing'!
domainRegistered: aDomainName
	"only current translator actually load the MO, to minimize loading time.
	 other translator will load anyway when it goes current"
	(self class current == self) 
		ifTrue: [self moFileForDomain: aDomainName].
	! !

!GetTextTranslator methodsFor: 'accessing'!
domainUnregistered: aDomainName
	moFiles removeKey: aDomainName ifAbsent: [^self]
	! !

!GetTextTranslator methodsFor: 'accessing'!
isDomainLoaded: aDomainName
	| mo |
	mo _ moFiles at: aDomainName ifAbsent: [nil].
	^mo isNil not.
! !

!GetTextTranslator methodsFor: 'accessing'!
loadMOFiles
	TextDomainManager allKnownDomains 
		do: [:domainName |
			self moFileForDomain: domainName
		].! !

!GetTextTranslator methodsFor: 'accessing'!
refresh
	"Purge the cached translations (and load on demand)"
	
	moFiles _ Dictionary new
! !

!GetTextTranslator methodsFor: 'accessing'!
reloadMOFiles
	
	self deprecated: 'Use the more intuitive refresh method'.
	
	self refresh! !

!GetTextTranslator methodsFor: 'language switching'!
setCurrent
	"ensure actual contents of MOs is loaded on switching language"
	self loadMOFiles! !

!GetTextTranslator methodsFor: 'private'!
loadMOFileForDomain: aDomainName
	| moName |

	moName _ self class findMOForLocaleID: self localeID 
								domain: aDomainName.
	moName notNil
			 ifTrue: [^MOFile new load: moName
								localeID: self localeID]
			ifFalse: [^nil]
! !

!GetTextTranslator methodsFor: 'private'!
moFileForDomain: domainName
	"Returns the cached MOFile for the given domainName (or nil).
	If none is cached, it will try to load one (every time) and cache it on demand."
	| moFile |

	^moFiles 
		at: domainName 
		ifAbsent: [
			moFile _ self loadMOFileForDomain: domainName.
			moFile notNil ifTrue:[
				moFiles at: domainName put: moFile].
			moFile]! !

!GetTextTranslator methodsFor: 'translation'!
translate: aString inDomain: aDomainName
	| mo |
	mo _ self moFileForDomain: aDomainName.
	^mo isNil 
		ifTrue: [aString] 
		ifFalse: [mo translationFor: aString]
! !

!GetTextTranslator methodsFor: 'initialize-release'!
initialize
	moFiles _ Dictionary new.! !

!GetTextTranslator class methodsFor: 'class initialization'!
initialize
	SystemDefaultLocaleDirs _ OrderedCollection new.
	UserDefaultLocaleDirs _ OrderedCollection new.
	LocaleDirsForDomain _ Dictionary new.! !

!GetTextTranslator class methodsFor: 'translation data layout'!
addSystemDefaultLocaleDir: dir
	"new dir will be put as first"
 	self systemDefaultLocaleDirs addFirst: dir! !

!GetTextTranslator class methodsFor: 'translation data layout'!
defaultLocaleDirs
	| dirs |
	dirs _ OrderedCollection new.
	UserDefaultLocaleDirs ifNotNil: [dirs addAll: UserDefaultLocaleDirs].
	dirs addAll: self systemDefaultLocaleDirs.
	^dirs
! !

!GetTextTranslator class methodsFor: 'translation data layout'!
localeDirForDomain: aDomainName
	"returns registered localeDirectory for the textdomain. returns nil if not registered"
	^LocaleDirsForDomain at: aDomainName ifAbsent: [nil]! !

!GetTextTranslator class methodsFor: 'translation data layout'!
localeDirsForDomain: aDomainName
	"returns collection of locale directories for text domain.  
	This includes user defined one for the domain, user defaults and system defaults" 
	| dirs dir |
	dirs _ OrderedCollection new.
	dir _ self localeDirForDomain: aDomainName.
	dir ifNotNil: [dirs add: dir].
	dirs addAll:  self defaultLocaleDirs. 
	
	^dirs! !

!GetTextTranslator class methodsFor: 'translation data layout'!
setLocaleDir: path forDoamin: aDomainName
	self LocaleDirsForDomain
		at: aDomainName
		put: path.! !

!GetTextTranslator class methodsFor: 'translation data layout'!
setupLocaleDirs
	| dirs sepa localesDirName |
	sepa _ FileSystem disk delimiter asString.
	SystemDefaultLocaleDirs _ nil.
	dirs _ self systemDefaultLocaleDirs.
	localesDirName _ 'locale'.
	dirs add:  (Smalltalk imageDirectory fullName) , sepa , localesDirName.
	dirs add:  (Smalltalk vm path) , sepa , localesDirName.
	^dirs! !

!GetTextTranslator class methodsFor: 'translation data layout'!
systemDefaultLocaleDirs
	^SystemDefaultLocaleDirs ifNil: [SystemDefaultLocaleDirs _ OrderedCollection new]
! !

!GetTextTranslator class methodsFor: 'translation data layout'!
userDefaultLocaleDirs
	^UserDefaultLocaleDirs ifNil: [UserDefaultLocaleDirs _ OrderedCollection new]
! !

!GetTextTranslator class methodsFor: 'private'!
findMOForLocaleID: id domain: aDomainName
	| sepa langSubDir path |
	sepa _ FileSystem disk delimiter asString.
	langSubDir _ self langDirNameForLocaleID: id.
	(self localeDirsForDomain: aDomainName)
		do: [:each |
			path _ each , sepa , langSubDir, sepa , (self moNameForDomain: aDomainName).
			[(path asFileReference exists)
				 ifTrue: [^path]] on: InvalidDirectoryError do: [:e | ^nil]].
	^nil.! !

!GetTextTranslator class methodsFor: 'private'!
langDirNameForLocaleID: id
	"returns relative path from locale directory to actual directory containing MOs"
	^(id posixName) , (FileSystem disk delimiter asString)  , 'LC_MESSAGES'! !

!GetTextTranslator class methodsFor: 'private'!
localeDirsForDomain
	^LocaleDirsForDomain ifNil: [LocaleDirsForDomain _ Dictionary new]! !

!GetTextTranslator class methodsFor: 'private'!
moNameForDomain: domainName
	^domainName , '.mo'! !

!GetTextTranslator class methodsFor: 'instance creation'!
newForLocaleID: id
	^self new localeID: id! !

!TextDomainInfo methodsFor: 'initialize-release'!
initialize
	categoryPrefixes _ Set new.
	categories _ IdentitySet new.
! !

!TextDomainInfo methodsFor: 'private'!
category: categoryName matches: prefix
	^ categoryName notNil and: [categoryName = prefix or: [categoryName beginsWith: prefix, '-']]! !

!TextDomainInfo methodsFor: 'accessing'!
categories
	^categories! !

!TextDomainInfo methodsFor: 'accessing'!
categoryPrefixes
	^categoryPrefixes! !

!TextDomainInfo methodsFor: 'accessing'!
includesCategory: categorySymbol
	(categories includes: categorySymbol) ifTrue: [^true].
	categoryPrefixes do: [:each |
		(self category: categorySymbol matches: each) ifTrue: [^true]
	].

	^false.! !

!TextDomainInfo methodsFor: 'accessing'!
matchedSystemCategories
	^SystemOrganization categories 
		select: [:cat | self includesCategory: cat]! !

!TextDomainManager class methodsFor: 'accessing'!
allKnownDomains
	| domains |
	domains _ Set new.
	domains addAll: ClassCategories values.
	domains add: self defaultDomain.
	^domains
! !

!TextDomainManager class methodsFor: 'accessing'!
defaultDomain
	^DefaultDomain! !

!TextDomainManager class methodsFor: 'accessing'!
defaultDomain: aDomainName
	DefaultDomain _ aDomainName! !

!TextDomainManager class methodsFor: 'accessing'!
domainForClass: aClass
	^Classes at: aClass theNonMetaClass name ifAbsent: [self defaultDomain]! !

!TextDomainManager class methodsFor: 'accessing'!
domainForClassCategory: aCategorySymbol
	^ClassCategories at: aCategorySymbol ifAbsent: [self defaultDomain]! !

!TextDomainManager class methodsFor: 'accessing'!
registerCategoryPrefix: aString domain: aDomainName
	| domInfo |
	domInfo _ self domainInfoFor: aDomainName.
	domInfo categoryPrefixes add: aString.
	self refresh.! !

!TextDomainManager class methodsFor: 'accessing'!
registerClass: className domain: aDomainName
	LoneClasses at: className put: aDomainName.
	self refresh.	"moves it to Classes"
! !

!TextDomainManager class methodsFor: 'accessing'!
registerClassCategory: categorySymbol domain: aDomainName
	| domInfo |
	domInfo _ self domainInfoFor: aDomainName.
	domInfo categories add: categorySymbol.
	self refresh.
! !

!TextDomainManager class methodsFor: 'accessing'!
registerDomain: domainName
	| domInfo |
	domInfo _ TextDomainInfo new.
	DomainInfos at: domainName put: domInfo.
	NaturalLanguageTranslator domainRegistered: domainName.
	^domInfo! !

!TextDomainManager class methodsFor: 'accessing'!
unregisterDomain: domainName
	DomainInfos removeKey: domainName.
	self refresh.
	NaturalLanguageTranslator domainUnregistered: domainName.
! !

!TextDomainManager class methodsFor: 'private'!
domainInfoFor: domainName
	^DomainInfos at: domainName ifAbsentPut: [ self registerDomain: domainName]! !

!TextDomainManager class methodsFor: 'private'!
domainInfos
	^DomainInfos! !

!TextDomainManager class methodsFor: 'private'!
refresh
	ClassCategories _ IdentityDictionary new.
	Classes _ IdentityDictionary new.
	DomainInfos keysAndValuesDo: [:domainName :domainInfo |
		domainInfo matchedSystemCategories do: [:cat |
			ClassCategories at: cat ifPresent: [self error: 'category ', (cat asString) , '  belongs to multiple domains'].
			ClassCategories at: cat put: domainName.
			(SystemOrganization listAtCategoryNamed: cat ) do: [ :cls |
				Classes at: cls put: domainName.
			]
		]
	].
	Classes addAll: LoneClasses.! !

!TextDomainManager class methodsFor: 'class initialization'!
initialize
	"	TextDomainManager initialize	"

	ClassCategories _ IdentityDictionary new.
	Classes _ IdentityDictionary new.
	LoneClasses _ IdentityDictionary new.
	DomainInfos _ Dictionary new.
	self defaultDomain: 'pharo'.! !

!TranslatedReceiverFinder methodsFor: 'private'!
arraySearch: aSymbol fromArray: anArray addTo: aCollection 
	"Find literals ahead of aSymbol from arrays in the method."
	"BUG: it can handle just one occurrence"
	| index |
	(index _ anArray identityIndexOf: aSymbol) > 1
		ifTrue: [aCollection add: (anArray at: index - 1) asString].
	(anArray
		select: [:each | each isMemberOf: Array])
		do: [:each | self
				arraySearch: aSymbol
				fromArray: each
				addTo: aCollection].
	^ aCollection! !

!TranslatedReceiverFinder methodsFor: 'private'!
arraySearch: aSymbol messageNode: aParseNode addTo: aCollection 
	"Find literals ahead of aSymbol from arrays in the method."
	
	aParseNode nodesDo: [:node |
		node isLiteral ifTrue: [
			(node literalValue isMemberOf: Array) ifTrue: [
				self 
					arraySearch: aSymbol
					fromArray: node literalValue
					addTo: aCollection]]].		
	^ aCollection! !

!TranslatedReceiverFinder methodsFor: 'private'!
search: aSymbol messageNode: aParseNode addTo: aCollection 
	aParseNode nodesDo: [:node | 
		node isMessage ifTrue: [
			node selector = aSymbol ifTrue: [
				aCollection add: node]]].
	^ aCollection! !

!TranslatedReceiverFinder methodsFor: 'accessing'!
findWordsWith: aSymbol in: aMethodReference 
	"Find words for translation with the symbol in a method. See
	LanguageEditorTest >>testFindTranslatedWords"
	"| message | 
	message _ MethodReference new setStandardClass: Morph class
	methodSymbol: #supplementaryPartsDescriptions.
	self new findWordsWIth: #translatedNoop in: message"
	| messages keywords aParseNode |

	aParseNode _ aMethodReference methodClass parseTreeFor: aMethodReference selector.
	"Find from string literal"
	messages _ Set new.
	self
		search: aSymbol
		messageNode: aParseNode
		addTo: messages.
	keywords _ OrderedCollection new.
	messages
		select: [:aMessageNode | aMessageNode receiver isLiteralNode]
		thenDo: [:aMessageNode | keywords add: aMessageNode receiver value
				"literalStringsDo: [:literal | keywords add: literal]"].
	"Find from array literal"
	self
		arraySearch: aSymbol
		messageNode: aParseNode
		addTo: keywords.
	^ keywords! !

!TranslatedReceiverFinder methodsFor: 'accessing'!
nonLiteralReceiversOf: aSymbol
	"self new nonLiteralReceiversOf: aSymbol"
	| receivers |
	"Answer method references of non literal senders of #translated"
	^ (SystemNavigation default allCallsOn: aSymbol)
		select: [:message | 
			receivers _ OrderedCollection new.
			self search: aSymbol messageNode: (message realClass parseTreeFor: message selector) addTo: receivers.
			receivers
				anySatisfy: [:each | (each receiver isLiteralNode) not]]! !

!TranslatedReceiverFinder methodsFor: 'accessing'!
stringReceiversOf: aSymbol
	"Find string receivers for a symbol.
	Answer a collection of aMethodReference -> {keyword. keyword...}"
	"self new stringReceiversOf: #translated"
	| keywords methodReferences |
	methodReferences _ SystemNavigation default allCallsOn: aSymbol.
	^ methodReferences inject: OrderedCollection new into: [:list :next |
		keywords _ self findWordsWith: aSymbol in: next.
		keywords
			ifNotEmpty: [list add: next -> keywords].
		list]
! !

!TranslatedReceiverFinder methodsFor: 'actions'!
searchBlockNode: aBlockNode addTo: aCollection

	aBlockNode statements do: [:e |
		(e isMemberOf: MessageNode) ifTrue: [self searchMessageNode: e addTo: aCollection].
		(e isMemberOf: ReturnNode) ifTrue: [self searchReturnNode: e addTo: aCollection].
	].
! !

!TranslatedReceiverFinder methodsFor: 'actions'!
searchMessageNode: aMessageNode addTo: aCollection

	((aMessageNode receiver isMemberOf: LiteralNode) and: [(aMessageNode selector isMemberOf: SelectorNode) and: [aMessageNode selector key = #translated]]) ifTrue: [
		aCollection add: aMessageNode receiver key.
	].

	(aMessageNode receiver isMemberOf: BlockNode) ifTrue: [self searchBlockNode: aMessageNode receiver addTo: aCollection].
	(aMessageNode receiver isMemberOf: MessageNode) ifTrue: [self searchMessageNode: aMessageNode receiver addTo: aCollection].
	(aMessageNode receiver isMemberOf: ReturnNode) ifTrue: [self searchReturnNode: aMessageNode receiver addTo: aCollection].

	aMessageNode arguments do: [:a |
		(a isMemberOf: BlockNode) ifTrue: [self searchBlockNode: a addTo: aCollection].
		(a isMemberOf: MessageNode) ifTrue: [self searchMessageNode: a addTo: aCollection].
		(a isMemberOf: ReturnNode) ifTrue: [self searchReturnNode: a addTo: aCollection].
	].
! !

!TranslatedReceiverFinder methodsFor: 'actions'!
searchMethodNode: aMethodNode addTo: aCollection

	(aMethodNode block isMemberOf: BlockNode) ifTrue: [self searchBlockNode: aMethodNode block addTo: aCollection].
	(aMethodNode block isMemberOf: MessageNode) ifTrue: [self searchMessageNode: aMethodNode block addTo: aCollection].
	(aMethodNode block isMemberOf: ReturnNode) ifTrue: [self searchReturnNode: aMethodNode block addTo: aCollection].
! !

!TranslatedReceiverFinder methodsFor: 'actions'!
searchReturnNode: aReturnNode addTo: aCollection

	(aReturnNode expr isMemberOf: BlockNode) ifTrue: [self searchBlockNode: aReturnNode expr addTo: aCollection].
	(aReturnNode expr isMemberOf: MessageNode) ifTrue: [self searchMessageNode: aReturnNode expr addTo: aCollection].
! !

!TranslatedReceiverFinder methodsFor: 'actions'!
senders
	| m o |
	m _ SystemNavigation default allCallsOn: #translated.
	m _ m
		collect: [ :e | 
			e classIsMeta
				ifTrue: [ (Smalltalk globals at: e classSymbol) class decompile: e methodSymbol ]
				ifFalse: [ (Smalltalk globals at: e classSymbol) decompile: e methodSymbol ] ].
	o _ OrderedCollection new.
	m do: [ :e | self searchMethodNode: e addTo: o ].
	^ o sort! !

!TranslatedReceiverFinder class methodsFor: 'utilities'!
browseNonLiteralReceivers
	"TranslatedReceiverFinder browseNonLiteralReceivers"
	SystemNavigation default
		browseMessageList: (self new nonLiteralReceiversOf: #translated)  asSortedCollection
		name: 'Non literal receivers of #translated'
		autoSelect: 'translated'! !
MOFile initialize!
NaturalLanguageTranslator initialize!
GetTextTranslator initialize!
TextDomainManager initialize!
