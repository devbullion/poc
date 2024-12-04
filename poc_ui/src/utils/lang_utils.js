export function getLangText(lang, textDict) {
    if(lang !=null && lang != "" && lang in textDict) 
        return textDict[lang];
    return "";
}