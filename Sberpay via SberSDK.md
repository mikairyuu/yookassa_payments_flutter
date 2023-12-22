# Проведение платежа через SberSDK

Функциональность доступна ограниченному кругу наших клиентов, так как находится в тестировании. Чтобы попасть в число ранних пользователей необходимо связаться со своим менеджером и запросить доступ.

- [Настройка оплаты через SberPay с нуля](#чистая-настройка)
- [Переход со старой версии SberPay](#переход-на-новую-версию)

С помощью SDK можно провести и подтвердить платеж через актуальное приложение Сбербанка, если оно установленно, иначе с подтверждением по смс.

## <a name="чистая-настройка"></a> Настройка оплаты через SberPay с нуля

(!) Далее описание настройки метода `SberPay`, если ранее вы его не использовали.

В `TokenizationModuleInputData` необходимо передавать `applicationScheme` – схема для возврата в приложение после успешной оплаты с помощью `SberPay` в приложении Сбербанка.

Пример `applicationScheme`:

```dart
let tokenizationModuleInputData = TokenizationModuleInputData(
    ...
    applicationScheme: "examplescheme://"
```

## Чтобы провести платёж:

### 1. При создании `TokenizationModuleInputData` передайте значение `PaymentMethod.sberbank` в `tokenizationSettings`.

```dart
var tokenizationSettings = const TokenizationSettings(PaymentMethodTypes([
    PaymentMethod.sberbank
]));

var tokenizationModuleInputData =
          TokenizationModuleInputData(clientApplicationKey: "<Ключ для клиентских приложений>",
                                      title: "Космические объекты",
                                      subtitle: "Комета повышенной яркости, период обращения — 112 лет",
                                      amount: Amount(value: 999.9, currency: Currency.rub),
                                      shopId: "<Идентификатор магазина в ЮKassa)>",
                                      savePaymentMethod: SavePaymentMethod.on,
                                      tokenizationSettings: tokenizationSettings);
```

### 2. Запустите процесс токенизации, передав TokenizationModuleInputData

```dart
var result = await YookassaPaymentsFlutter.tokenization(tokenizationModuleInputData);
```

### 3. Получите токен

```dart
var result = await YookassaPaymentsFlutter.tokenization(tokenizationModuleInputData);
if (result is SuccessTokenizationResult) {
    var token = result.token;
    var paymentMethodType = result.paymentMethodType;
} else if (result is ErrorTokenizationResult) {
    // обработайте ошибку
}
```

### 4. [Создайте платеж](https://yookassa.ru/developers/api#create_payment) с токеном по API ЮKassa.

## Для подтверждения платежа через приложение Сбербанка:

### 1. Добавьте уникальную схему диплинка

Для **iOS** в `Info.plist` добавьте следующие строки:

```plistbase
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>${BUNDLE_ID}</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>examplescheme</string>
        </array>
    </dict>
</array>
```

Для **android** в ваш файл build.gradle в блок android.defaultConfig добавьте строку

```
android {
    defaultConfig {
        resValue "string", "ym_app_scheme", "exampleapp"
    }
}
```
или добавить в ваш strings.xml строку вида:
```
<resources>
    <string name="ym_app_scheme" translatable="false">exampleapp</string>
</resources>
```

где `examplescheme` - схема для открытия вашего приложения, которую вы указали в `applicationScheme` при создании `TokenizationModuleInputData`. Через эту схему будет открываться ваше приложение после успешной оплаты с помощью `SberPay`.

### 2. Для android подключите библиотеку профилирования формата .aar

Попросите у менеджера по подключению библиотеку профилирования формата .aar. Создайте папку libs в модуле где подключаете sdk и добавьте туда файл aar-файл. В build.gradle того же модуля в dependencies добавьте:
```groovy
dependencies {
    implementation fileTree(dir: "libs", include: ["*.aar"])
}
```

### 3. Добавить в `Info.plist` новые схемы для обращения в сервисам Сбера

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>sbolidexternallogin</string>
    <string>sberbankidexternallogin</string>   
</array>
```

и расширенные настройки для http-соединений к сервисам Сбера

```
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
    <key>gate1.spaymentsplus.ru</key>
    <dict>
       <key>NSExceptionAllowsInsecureHTTPLoads</key>
       <true/>
    </dict>
    <key>ift.gate2.spaymentsplus.ru</key>
    <dict>
       <key>NSExceptionAllowsInsecureHTTPLoads</key>
       <true/>
    </dict>
    <key>cms-res.online.sberbank.ru</key>
       <dict>
           <key>NSExceptionAllowsInsecureHTTPLoads</key>
           <true/>
       </dict>
    </dict>
</dict>
```

### 4. Подтверждение платежа. При необходимости система может запросить процесс подтверждения платежа, при котором пользователь подтверждает транзакцию с помощью сервисов Сбера. Ссылку вы получаете от бекенда Кассы после проведения платежа на шаге 4.

```dart
var clientApplicationKey = "<Ключ для клиентских приложений>";
var shopId = "<Идентификатор магазина в ЮKassa)>";

await YookassaPaymentsFlutter.confirmation(confirmationUrl, PaymentMethod.sbp, clientApplicationKey, shopId);
// обработайте результат подтверждения на следущей строке (после возврата управления)
```
Завершение процесса `YookassaPaymentsFlutter.confirmation` не несет информацию о том, что пользователь фактически подтвердил платеж (он мог его пропустить). После получения результата рекомендуем запросить статус платежа.



## <a name="переход-на-новую-версию"></a> Переход на новую версию SberPay

(!) Далее описание настройки новой версии метода `SberPay`, если ранее вы его уже использовали.

Сценарий оплаты через `Sberpay` теперь происходит не в мобильном приложения, а через встроенное Sber SDK.

### Список изменений для android:

Попросите у менеджера по подключению библиотеку формата `.aar`.
  Создайте папку libs в модуле где подключаете sdk и добавьте туда файл `B.aar`. В build.gradle того же модуля в dependencies добавьте:
```groovy
dependencies {
    implementation fileTree(dir: "libs", include: ["*.aar"])
}
```

Также необходимо в метод `YookassaPaymentsFlutter.confirmation` передать параметр `clientApplicationKey` - ключ для клиентских приложений из личного кабинета ЮKassa ([раздел Настройки — Ключи API](https://yookassa.ru/my/api-keys-settings));

```dart
var clientApplicationKey = "<Ключ для клиентских приложений>";
var shopId = "<Идентификатор магазина в ЮKassa)>";

await YookassaPaymentsFlutter.confirmation(confirmationUrl, PaymentMethod.sbp, clientApplicationKey, shopId);
```

### Список изменений для iOS:

1. В вашем файле `Info.plist` заменить схему для обращений в сервисам Сбера

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>sberpay</string> 
</array>
```
на обновленную версию
```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>sbolidexternallogin</string>
    <string>sberbankidexternallogin</string>   
</array>
```

2. Добавить расширенные настройки для http-соединений к сервисам Сбера

```
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
    <key>gate1.spaymentsplus.ru</key>
    <dict>
       <key>NSExceptionAllowsInsecureHTTPLoads</key>
       <true/>
    </dict>
    <key>ift.gate2.spaymentsplus.ru</key>
    <dict>
       <key>NSExceptionAllowsInsecureHTTPLoads</key>
       <true/>
    </dict>
    <key>cms-res.online.sberbank.ru</key>
       <dict>
           <key>NSExceptionAllowsInsecureHTTPLoads</key>
           <true/>
       </dict>
    </dict>
</dict>
```
