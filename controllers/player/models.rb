class Product
    attr_accessor :amount, :sku, :name
  
    def initialize(amount, sku, name)
      @amount = amount
      @sku = sku
      @name = name
    end

    def to_json
        {
          amount: @amount,
          sku: @sku,
          name: @name
        }
    end
end
  
class PublisherPayload
    attr_accessor :appChargePaymentId, :purchaseDateAndTimeUtc, :gameId, :playerId,
                  :authType, :bundleName, :bundleId, :sku, :priceInCents, :currency,
                  :action, :actionStatus, :products, :publisherToken
  
    def initialize(appChargePaymentId, purchaseDateAndTimeUtc, gameId, playerId,
                    bundleName, bundleId, sku, priceInCents, priceInDollar, currency, action, actionStatus,
                    products, publisherToken)
      @appChargePaymentId = appChargePaymentId
      @purchaseDateAndTimeUtc = purchaseDateAndTimeUtc
      @gameId = gameId
      @playerId = playerId
      @bundleName = bundleName
      @bundleId = bundleId
      @sku = sku
      @priceInCents = priceInCents
      @priceInDollar = priceInDollar
      @currency = currency
      @action = action
      @actionStatus = actionStatus
      @products = products
      @publisherToken = publisherToken
    end

    def to_json
        {
            :appChargePaymentId => appChargePaymentId,
            :purchaseDateAndTimeUtc => purchaseDateAndTimeUtc,
            :gameId => gameId,
            :playerId => playerId,
            :authType => authType,
            :bundleName => bundleName,
            :bundleId => bundleId,
            :sku => sku,
            :priceInCents => priceInCents,
            :currency => currency,
            :action => action,
            :actionStatus => actionStatus,
            :products => products,
            :publisherToken => publisherToken
            }
    end

    def initialize(hash_attributes)
        hash_attributes.each do |key, value|
            instance_variable_set("@#{key}", value)
        end
    end 
end

class PlayerUpdateBalanceResponse
    attr_accessor :publisherPurchaseId, :purchaseTime

    def initialize(publisherPurchaseId, purchaseTime)
        @publisherPurchaseId = publisherPurchaseId
        @purchaseTime = purchaseTime
    end

    def to_json
        {
            :publisherPurchaseId => @publisherPurchaseId,
            :purchaseTime => @purchaseTime
        }
    end
end