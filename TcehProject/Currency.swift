
import Foundation
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults


extension DefaultsKeys {
    static let baseCurrency = DefaultsKey<String?>("baseCurrency")
    static let userDefined = DefaultsKey<Bool?>("userDefined")
    static let currencyList = DefaultsKey<[String]?>("currencyList")
}



class Currency {

    private var _list: [String]

    var list: [String] {

        get {

            if let list = Defaults[.currencyList] {
                _list = list
                return _list
            } else {
                _list = ["RUB: Russian Ruble", "USD: United States Dollar", "EUR: European Euro", "Loading..."]
                Currency.loadCurrencies()
                return _list
            }

        }

        set {
            _list = newValue
            Defaults[.currencyList] = newValue
        }

    }

    private static let apiEndpoint = "http://apilayer.net/api/"
    private static let apiKey = "96c83b8075825e87ee1b9f9e78209af5"

    static var baseCurrency = "RUB" {

        didSet {
            Defaults[.baseCurrency] = Currency.baseCurrency
        }

    }

    static var userDefined = false {

        didSet {
            Defaults[.userDefined] = Currency.userDefined
        }

    }

    static let manager = Currency()

    init() {

        self._list = []

        if Defaults[.baseCurrency] == nil {
            Defaults[.baseCurrency] = "RUB"
            Defaults[.userDefined] = false
            Currency.loadCurrencies()

        } else if Defaults[.currencyList] == nil || Defaults[.currencyList]?.count < 5 {
            Currency.loadCurrencies()

        } else {
            Currency.baseCurrency = Defaults[.baseCurrency]!
            self.list = Defaults[.currencyList]!
        }

    }
    


    static func loadCurrencies() {

        let url = Currency.apiEndpoint + "list"

        let params = [
            "access_key": Currency.apiKey
        ]

        var currencies = [String]()

        Alamofire.request(.GET, url, parameters: params).responseJSON { response in

            if let value = response.result.value {

                let json = JSON(value)

                let jsonCurrencies = json["currencies"].dictionaryValue

                for (ticker, _) in jsonCurrencies {
                    currencies.append(ticker + ": " + (jsonCurrencies[ticker]!.string)!)
                }

                if currencies.count == 0 {
                    currencies.append("ERR: Error fetching currency list")
                }

                let currenciesSorted = currencies.sort()

                Currency.manager.list = currenciesSorted
                Defaults[.currencyList] = currenciesSorted

            }

        }

    }

}