NSInteger caseInsensitiveNameCompare(id a, id b, void *context) {
    return [[a name] caseInsensitiveCompare:[b name]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    // Сортируем модели и складываем в массив
    _models = [[self.brand.models allObjects] sortedArrayUsingFunction:caseInsensitiveNameCompare context:NULL];

    for (AutoModel *model in _models) {
        _subgenerations[model.name] = [[model.subgenerations allObjects] sortedArrayUsingFunction:caseInsensitiveNameCompare context:NULL];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *modelName = [self.models[indexPath.section] name];
    NSArray *subs = self.subgenerations[modelName];
    AutoSubgeneration *subgeneration = subs[indexPath.row];

    CatalogueModificationViewController *controller = [[CatalogueModificationViewController alloc] init];
    controller.name = subgeneration.model.name;
    controller.generation = [NSString stringWithFormat:@"(%@, %@)", subgeneration.generation, subgeneration.years];
    controller.subgeneration = subgeneration;

    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self trackModelSelectionEventForModelWithName: modelName];
}



- (void)didFinishLoadingImage:(SYLoadScaleOperation *)operation {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(didFinishLoadingImage:) withObject:operation waitUntilDone:NO];
    }

    UITableViewCell *cell = [self.modelTableView cellForRowAtIndexPath:operation.indexPath];

    [self removeSpinnerFromImageView:cell.imageView];

    if (operation.loadedImage != nil) {
        cell.imageView.image = operation.loadedImage;
    } else {
        cell.imageView.image = _placeholderImage;
    }

    [cell setNeedsLayout];
}



- (void)didFailLoadingImage:(SYLoadScaleOperation *)operation {    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(didFailLoadingImage:) withObject:operation waitUntilDone:NO];
    }

    UITableViewCell *cell = [self.modelTableView cellForRowAtIndexPath:operation.indexPath];
    cell.imageView.image = _placeholderImage;
    [self removeSpinnerFromImageView:cell.imageView];
    [cell setNeedsLayout];
}



- (void)trackModelSelectionEventForModelWithName:(NSString *)modelName {
    [[GANTracker sharedTracker]
        trackEvent: @"Catalog"
        action: [NSString stringWithFormat: @"Selected model %@", modelName]
        label: nil
        value: -1
        withError: NULL];

    [[GANTracker sharedTracker]
        trackPageview: [NSString stringWithFormat:@"/selected_model/%@", modelName]
        withError: NULL];

    [[GANTracker sharedTracker] dispatch];
}