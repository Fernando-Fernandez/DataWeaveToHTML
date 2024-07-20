public with sharing class GetExchangeRates {
    @InvocableMethod (label='Get Exchange Rates' 
                        description='Returns exchange rates for the given currency.' 
                        category='Integration')
    public static List<String> GetExchangeRates( List<String> currencyList ) {
        String endpoint = 'callout:Exchange_Rate_API/' + currencyList[ 0 ];

        Map<String, String> headers;
        String body;
        Map<String, Object> responseMap = HttpCalloutHelper.getResponse( 
                                        endpoint, HttpCalloutHelper.GET
                                        , headers, body );

        if( responseMap.containsKey( 'Error' ) ) {
            return new List<String> { (String) responseMap.get( 'Error' ) };
        }

        body = (String) responseMap.get( 'Body' );
        return new List<String> { body };
    }
}