/**
 * @description       : 
 * @author            : Bohdan Pyrih
 * @group             : 
 * @last modified on  : 05-15-2023
 * Example usage
    String question = 'What is the capital of France?';
    String response = ChatGPTClient.askQuestion(question);
    System.debug(response);
 **/
public with sharing class AIQ_ChatGPTClient {
    // private static final String OPENAI_API_KEY = 'YOUR_API_KEY';
    private static final String GPT_MODEL = '/text-davinci-003/completions';
    private static final Integer GPT_MAX_TOKENS = 2000;
    
    /**
     * @description       : Ask a question to the GPT-3 model
     * @param             : question - the question to ask
     * @return            : the answer to the question
     * @throws            :
    */
    @future(callout=true)
    public static void askQuestion(String question) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Chat_GPT' + GPT_MODEL);
        
        request.setMethod('POST');
        // request.setHeader('Authorization', 'Bearer ' + OPENAI_API_KEY);
        // request.setHeader('Content-Type', 'application/json');
        
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('prompt', question);
        requestBody.put('max_tokens', GPT_MAX_TOKENS); // Set the desired length of the response
        
        String requestBodyJson = JSON.serialize(requestBody);
        System.debug('requestBodyJson = ' + requestBodyJson);
        request.setTimeout(120000);
        request.setBody(requestBodyJson);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('response = ' + response.getBody());
        if (response.getStatusCode() == 200) {
            Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> choices = (List<Object>) responseBody.get('choices');
            if (!choices.isEmpty()) {
                Map<String, Object> choice = (Map<String, Object>) choices[0];
                String text = (String) choice.get('text');
                System.debug('text = ' + text);
            }
        }
        
    }
}