public with sharing class DataWeaveConversionHelper {
    public class DataWeaverParameter {
        @InvocableVariable( label='Input Data' required=true )
        public String inputData;
        @InvocableVariable( label='DataWeave Name' required=true )
        public String dataweaveName;
    }

    @InvocableMethod(label='Get Converted Payload' 
                    description='Returns payload converted via DataWeave.' 
                    category='Integration')
    public static List<String> getConvertedPayload( List<DataWeaverParameter> dwParamList ) {
        List<String> resultList = new List<String>();
        for( DataWeaverParameter dwParam : dwParamList ) {
            Map<String, Object> paramMap = 
                        new Map<String, Object>{ 'payload' => dwParam.inputData };
            DataWeave.Script dwScript = 
                        DataWeave.Script.createScript( dwParam.dataweaveName );
            
            DataWeave.Result result = dwScript.execute( paramMap );
            String jsonOutput = result.getValueAsString();
            resultList.add( jsonOutput );
        }

        return resultList;
        // String jsonOutput = result.getValueAsString();
        // return jsonOutput;
    }
}