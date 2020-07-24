function output = googleTranslateAPI(foreignText,fromLang,toLang,yourKey)
%% Uses google API to make the translations
% Input : foreignText - Text to be translated
%         fromLang - Language of the text to be translated, use google
%         language tags. See GoogleTranslateAPI doccumentation.
%         toLang - Language to be translated to
%         yourKey - Personal API key
    import org.jsoup.*
    foreignText = char(java.net.URLEncoder.encode(foreignText,'UTF-8'));
    qryStr = ['https://translation.googleapis.com/language/translate/v2?',...
             'source=',fromLang,...
             '&target=',toLang,...
             '&key=',yourKey,...
             '&q=',foreignText];
    conn = Jsoup.connect(qryStr);
    conn = conn.timeout(20*1000);
    conn = conn.referrer("https://www.google.com");     
    conn = conn.followRedirects(true);
    conn = conn.userAgent("Chrome");
    conn = conn.ignoreContentType(true); % Ignore conent type should be set to 
                                 % true when extracting rss xml to 
                                 % avoid errors
    objectDOMStr = string(conn.get().toString);
    objectDOMStr = strrep(objectDOMStr,'&quot;','');
    output = strtrim(string(regexp(objectDOMStr,'translatedText:(.*?)}','tokens')));