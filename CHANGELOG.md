> #### Before create pull request
> - You must specify one of the versions in the field **NEXT_VERSION_TYPE**
> - Also you need to indicate descriptions of changes between fields **NEXT_VERSION_DESCRIPTION_BEGIN** and **NEXT_VERSION_DESCRIPTION_END**
### NEXT_VERSION_TYPE=MAJOR|MINOR|PATCH
### NEXT_VERSION_DESCRIPTION_BEGIN
### NEXT_VERSION_DESCRIPTION_END

## [1.3.0] (22-12-2023)

* Update payment method via Sber

## [1.2.2] (29-09-2023)

* Fix unnecessary_non_null_assertion warnings in test

## [1.2.1] (28-09-2023)

* Add parameters for deploying to pub.dev

## [1.2.0] (27-09-2023)

* Add CI/CD configuration files

## [1.1.1]

* Fix SBP implementation readme. Fix and improve UI

## [1.1.0]

* Support new payment method — SBP

## [1.0.6]

* Fix crash with 3DS confirmation for Android Platform

## [1.0.5]

* Fix bug with return confirmation result for iOS platform

## [1.0.4]

* Added processing of Mintsifra certificates in webView to keep banking services working
* Moved the field for customizing the display of the YooKassa logo from TokenizationSettings to CustomizationSettings
* Made UI changes and updated profiling

## [1.0.3]

* Fixed iOS confirmation flow. Refactored TokenizationResult, now it's have SuccessTokenizationResult, ErrorTokenizationResult and CanceledTokenizationResult versions. Not to get token from TokenizationResult you need to check it's type:
var result = await YookassaPaymentsFlutter.tokenization(tokenizationModuleInputData);
if (result is SuccessTokenizationResult) {
    result.token
}

## [1.0.2]

* Made applePayID and moneyAuthClientId fields optional.

## [1.0.1]

* Formatted code. Added homepage and repo urls.

## [1.0.0]

* Initial development release.