/**
 *  Třída Interaction - slouží k definici interakcí (zařizování).
 *
 *  Může se jich nacházet více v jedné místnosti
 *
 *  Tato třída je součástí jednoduché textové hry.
 *
 *@author     Martin Fanta
 *@version    1.0
 *@created    říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics.interactions;
import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;


public class Interaction {

    private String name;

    private boolean isAvailable;
    private String tooltip;
    private String statement;

    public Interaction(String name, boolean isAvailable, String tooltip, String... statement){
        this.name = name;
        this.isAvailable = isAvailable;
        this.tooltip = tooltip;
        this.statement = statement.length > 0 ? statement[0] : "";
    }

    /**
     * Metoda se volá před interakcí, slouží převážně pro Override s využitím individuální funkce.
     *
     *@param game Instance běžící hry
     *@return Vrací boolean, pokud lze spustit interakci (true), pokud ne (false)
     */
    public boolean beforePick(Game game){
        if(!isAvailable){
            Global.gamePrint(tooltip);
            return false;
        }
        Global.gamePrint(statement);
        return true;
    }

    /**
     * Metoda se volá po interakci, slouží převážně pro Override s využitím individuální funkce.
     *
     *@param game Instance běžící hry
     */
    public void afterPick(Game game){
        this.setAvailable(false);
        //Global.gamePrint("Zařídil jsi " + this + "✔");
    }

    /**
     * Metoda slouží jako getter pro název interakce.
     *
     *@return Vrací název String
     */
    public String getName() {
        return name;
    }

    /**
     * Metoda slouží jako getter pro tooltip interakce.
     *
     *@return Vrací tooltip String
     */
    public String getTooltip(){
        return tooltip;
    }

    /**
     * Metoda slouží jako getter pro isAvailable interakce.
     *
     *@return Vrací isAvailable Boolean
     */
    public boolean isAvailable() {
        return isAvailable;
    }

    /**
     * Metoda slouží jako setter pro isAvailable interakce.
     */
    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    /**
     * Metoda slouží jako setter pro tooltip interakce.
     */
    public void setTooltip(String tooltip){
        this.tooltip = tooltip;
    }

    /**
     * Metoda přepisuje toString na hodnotu jmena.
     *
     *@return Vrací name String
     */
    @Override
    public String toString() {
        return name;
    }
}
