viewDidLoad
	super viewDidLoad.
	self navigationController setNavigationBarHidden: false animated: true.

	"Сортируем модели и складываем в массив"
	models := self brand models allObjects sortBy: [:a :b | a name caseInsensitiveCompare: b name].
	models do: [:model |
		subgenerations
			at: model name
			put: (model subgenerations allObjects sortBy: [:a :b | a name caseInsensitiveCompare: b name]]



tableView: tableView didSelectRowAtIndexPath: indexPath
	| modelName subgeneration controller |
	modelName := (self models at: indexPath section) name.
	subgeneration := (self subgenerations at: modelName) at: indexPath row.

	controller := CatalogueModificationViewController new
		setName: subgeneration model name;
		setGeneration: ('({1}, {2})' format: {subgeneration generation. subgeneration years})
		setSubgeneration: subgeneration;
		yourself.

	self navigationController pushViewController: controller animated: true.
	tableView deselectRowAtIndexPath: indexPath animated: true.
	self trackModelSelectionEventForModelWithName: modelName



didFinishLoadingImage: operation
	NSThread isMainThread ifFalse: [
		^self
			performSelectorOnMainThread: #didFinishLoadingImage:
			withObject: operation
			waitUntilDone: false].

	cell := self modelTableView cellForRowAtIndexPath: operation indexPath.
	self removeSpinnerFromImageView: cell imageView.
	cell imageView setImage: (operation loadedImage isNil
		ifTrue: [self class placeholderImage]
		ifFalse: [operation loadedImage]).
	cell setNeedsLayout.
}



didFailLoadingImage: operation
	| cell |
	NSThread isMainThread ifFalse: [
		^self
			performSelectorOnMainThread: #didFailLoadingImage:
			withObject: operation
			waitUntilDone: false].

	cell := self modelTableView cellForRowAtIndexPath: operation indexPath.
	self removeSpinnerFromImageView: cell imageView.
	cell imageView setImage: self class placeholderImage.
	cell setNeedsLayout



trackModelSelectionEventForModelWithName: modelName
	GANTracker sharedTracker
		trackEvent: 'Catalog'
		action: 'Selected model ', modelName
		label: nil
		value: -1
		withError: nil;

		trackPageview: '/selected_model/', modelName
		withError: nil;

		dispatch.