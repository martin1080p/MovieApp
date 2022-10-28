/**
 * Třída Global - slouží k uchování globálních proměnných.
 * Do této třídy se může přistupovat odkudkoli
 *
 * Tato třída je součástí jednoduché textové hry.
 *
 * @author Martin Fanta
 * @version 1.0
 * @created říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics.utils;

import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class Global {
    public static boolean slowPrinting = true;
    public static boolean isPrinting;

    public Global() {
    }

    /**
     * Metoda vypíše textový řádek do konzole.
     *
     * @param text text pro vypsání
     */
    public static void println(String text) {
        System.out.println(text);
    }

    /**
     * Metoda vypíše text do konzole.
     *
     * @param text text pro vypsání
     */
    public static void print(String text) {
        System.out.print(text);
    }

    /**
     * Metoda slouží jako globální vypisovač pro hru. Veškerý output hry se děje přes tuto metodu.
     * Podporuje funkci slowPrinting, pro postupné vypisování.
     *
     * @param text text pro vypsání
     * @param timeout počet milisekund pro interval, v jakém se má vypsat další písmeno (pouze pokud je slowPrinting=true)
     */
    public static void gamePrint(String text, int... timeout) {

        if (slowPrinting) {
            try {
                isPrinting = true;
                for (int i = 0; i < text.length(); i++) {
                    if (text.charAt(i) == '$') {
                        TimeUnit.MILLISECONDS.sleep(timeout.length > 1 ? timeout[1] : 1000);
                        continue;
                    }
                    print(String.valueOf(text.charAt(i)));
                    TimeUnit.MILLISECONDS.sleep(timeout.length > 0 ? timeout[0] : 50);
                }
                print("\n");
                isPrinting = false;
            } catch (InterruptedException e) {
                isPrinting = false;
                throw new RuntimeException(e);
            }
        } else {
            println(text.replaceAll("\\$", ""));
        }
    }

    /**
     * Metoda vymaže dosavadní obsah konzole.
     * Zaleží na typu konzole, zda-li vymazávání obsahu podporuje.
     */
    public static void clearScreen() {
        System.out.print("\033[H\033[2J");
        System.out.flush();
    }

    /**
     * Metoda slouží pro normalizaci textu. Tzn. zbaví se diakritiky.
     *
     * @param text text pro normalizaci
     * @return Vrátí normalizovaný text
     */
    public static String normalizeText(String text) {

        List<String> patterns = Arrays.asList(
                "ě",
                "š",
                "č",
                "ř",
                "ž",
                "ý",
                "á",
                "í",
                "é",
                "ď",
                "ň",
                "ó",
                "ť",
                "ů",
                "ú");

        List<String> replaces = Arrays.asList(
                "e",
                "s",
                "c",
                "r",
                "z",
                "y",
                "a",
                "i",
                "e",
                "d",
                "n",
                "o",
                "t",
                "u",
                "u");

        for (int i = 0; i < patterns.size(); i++) {
            text = text.replaceAll(patterns.get(i), replaces.get(i));
        }

        return (text);
    }
}
