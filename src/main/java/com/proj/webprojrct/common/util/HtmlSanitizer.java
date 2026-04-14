package com.proj.webprojrct.common.util;
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;
public final class HtmlSanitizer {

    private HtmlSanitizer() {
    }
    public static String sanitize(String input) {
        if (input == null) {
            return null;
        }
        return Jsoup.clean(input, Safelist.none());
    }
}
