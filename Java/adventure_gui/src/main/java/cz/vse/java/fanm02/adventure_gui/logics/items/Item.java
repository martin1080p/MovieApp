/**
 *  Třída Item - slouží k definici věci, která lze i nelze přidat do batohu.
 *
 *  Může se jich nacházet více v jedné místnosti.
 *
 *  Tato třída je součástí jednoduché textové hry.
 *
 *@author     Martin Fanta
 *@version    1.0
 *@created    říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics.items;
import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;

public class Item {

    private String name;
    private String tooltip;
    private String statement;

    private boolean isAvailable;

    public Item(String name, boolean isInteractive, String tooltip, String... statement){
        this.name = name;
        this.isAvailable = isInteractive;
        this.tooltip = tooltip;
        this.statement = statement.length > 0 ? statement[0] : "";
    }


    /**
     * Metoda se volá před sebráním věci, slouží převážně pro Override s využitím individuální funkce.
     *
     *@param game Instance běžící hry
     *@return Vrací boolean, pokud věc lze sebrat (true), pokud ne (false)
     */
    public boolean beforePick(Game game){
        if(!isAvailable) {
            Global.gamePrint(tooltip);
            return false;
        }

        if(game.getBackpack().getContent().size() + 1 > game.getBackpack().getCapacity()){
            Global.gamePrint("Tento předmět už se ti do batahu nevejde, musíš něco odložit..");
            return false;
        }
        Global.gamePrint(statement);
        return true;
    }

    /**
     * Metoda se volá po sebrání věci, slouží převážně pro Override s využitím individuální funkce.
     *
     *@param game Instance běžící hry
     */
    public void afterPick(Game game){
        game.getCurrentRoom().removeItem(this);
        game.getBackpack().putIn(this);
        Global.gamePrint("Vzal jsi " + this);
        Global.gamePrint("Veci v batohu: " + game.getBackpack().getAvailableItems());

        game.checkEnd();
    }

    /**
     * Metoda slouží jako getter pro název věci.
     *
     *@return Vrací název String
     */
    public String getName() {
        return name;
    }

    /**
     * Metoda slouží jako getter pro tooltip věci.
     *
     *@return Vrací tooltip String
     */
    public String getTooltip(){
        return tooltip;
    }

    /**
     * Metoda slouží jako getter pro statement věci.
     *
     *@return Vrací statement String
     */
    public String getStatement(){ return statement; }

    /**
     * Metoda slouží jako getter pro isAvailable věci.
     *
     *@return Vrací isAvailable Boolean
     */
    public boolean isAvailable() {
        return isAvailable;
    }

    /**
     * Metoda přepisuje toString na hodnotu jmena.
     *
     *@return Vrací name String
     */
    @Override
    public String toString(){
        return this.name;
    }


}
