public without sharing class HttpCalloutHelper {

    // USAGE:  HttpCalloutHelper.getResponse( 'callout:JSPA_REST_API', HttpCalloutHelper.GET
    //                        , new Map<String, String> { 'Content-Type' => 'application/json' }
    //                        , '{parameters...}' );

    public static final String GET = 'GET', PUT = 'PUT', xDELETE = 'DELETE', POST = 'POST';
    public static final String ACCEPT_HEADER = 'accept';
    public static final String CONTENT_TYPE_HEADER = 'content-type';
    public static final String X_API_KEY_HEADER = 'x-api-key';

    public static Map<String, Object> getResponse( String url, String method
                                                    , Map<String, String> headers, String body ) {
        Map<String, Object> responseMap = new Map<String, Object>();

        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint( url );
            req.setMethod( method );

            if( body != null ) {
                req.setBody( body );
            }

            if( headers != null ) {
                for( String key : headers.keySet() ) {
                    req.setHeader( key, headers.get( key ) );
                }
            }

            Http h = new Http();
            HttpResponse response = h.send( req );
            String responseStatus = response.getStatus();
            responseMap.put( 'Status', responseStatus );
            responseMap.put( 'StatusCode', response.getStatusCode() );
            String responseBody = response.getBody();
            responseMap.put( 'Body', responseBody );

            if( ! responseStatus.equalsIgnoreCase( 'OK' ) && ! responseStatus.equalsIgnoreCase( 'Created' ) ) {
                system.debug( 'Error= ' + responseStatus + ' - ' + responseBody );

                responseMap.put( 'Error', responseStatus + ' - ' + responseBody );
            }

            // if needing the response headers
            List<String> headerKeys = response.getHeaderKeys();
            if( headerKeys != null ) {
                for( String aKey : headerKeys ) {
                    responseMap.put( aKey, response.getHeader( aKey ) );
                }
            }

            return responseMap;

        } catch( Exception e ) {
            system.debug( e.getMessage() + ' - ' + e.getStackTraceString() );
            responseMap.put( 'Error', e.getMessage() );
            responseMap.put( 'Exception', e );
            return responseMap;
        }
    }

    public static Map<String, String> getDefaultRequestHeaders( String apiKey ) {
        Map<String, String> requestHeaders = new Map<String, String> {
            ACCEPT_HEADER => 'application/json'
            , CONTENT_TYPE_HEADER => 'application/json' // maybe should be ommitted for GET/DELETE
            , X_API_KEY_HEADER => apiKey
        };
        return requestHeaders;
    }

    public static Map<String, Object> parseJSONResponseBody( String theBody ) {
        Map<String, Object> parsedResponseBody = new Map<String, Object>();
        JSONParser theParser = JSON.createParser( theBody );
        JSONToken theToken = theParser.nextToken();
        String currentFieldName;
        while( theToken != null ) {
            // look for a field name first, then its value
            if( theToken != JSONToken.FIELD_NAME ) {
                theToken = theParser.nextToken();
                continue;
            }
            
            currentFieldName = theParser.getText();
            theParser.nextToken();
            
            // NOTE - future improvement:  handle nested arrays and objects
            if( theParser.getCurrentToken() == JSONToken.START_OBJECT ) {
	            // handle nested objects
	            Map<String, Object> nestedObject = new Map<String, Object>();
                theToken = theParser.nextToken();
                while( theToken != JSONToken.END_OBJECT ) {
                    // NOTE:  handles only one level of nesting and no nested arrays
                    String fieldName = theParser.getCurrentName();
                    theParser.nextToken();
                    nestedObject.put( fieldName, getObjectFromToken( theParser ) );
                    theToken = theParser.nextToken();
                }
                parsedResponseBody.put( currentFieldName, nestedObject );
            	theToken = theParser.nextToken();
                continue;
                
            } else if( theParser.getCurrentToken() == JSONToken.START_ARRAY ) {
                // TODO:  handle nested arrays
            }
            
            Object fieldValue = getObjectFromToken( theParser );
            parsedResponseBody.put( currentFieldName, fieldValue );

            theToken = theParser.nextToken();
        }

        return parsedResponseBody;
    }
    
    public static Object getObjectFromToken( JSONParser parser ) {
        switch on parser.getCurrentToken() {
            when VALUE_TRUE, VALUE_FALSE {
                return parser.getBooleanValue();
            }
            when VALUE_NUMBER_FLOAT, VALUE_NUMBER_INT {
                return parser.getDoubleValue();
            }
            when VALUE_STRING {
                return parser.getText();
            }
            when else {
                return null;
            }
        }
    }

    public static Map<String, Object> getParsedJSON( String theBody )  {
        // NOTE:  if JSON contains an array, this would be casted to List<Object>
        return (Map<String, Object>) JSON.deserializeUntyped( theBody );
    }
}