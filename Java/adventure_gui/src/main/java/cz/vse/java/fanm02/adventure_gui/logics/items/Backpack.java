/**
 *  Třída Backpack - slouží k definici batohu, do kterého lze přidávat věci.
 *
 *  Ve hře se používá pouze jeden.
 *
 *  Tato třída je součástí jednoduché textové hry.
 *
 *@author     Martin Fanta
 *@version    1.0
 *@created    říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics.items;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;
import java.util.ArrayList;
import java.util.List;

public class Backpack {

    private int capacity;
    private List<Item> content;

    public Backpack(List<Item> content){
        this.capacity = 5;
        this.content = content;
    }

    /**
     * Metoda přidá věc (Item) do obsahu batohu.
     *
     * @param item věc pro přidání
     */
    public void putIn(Item item){
        List<Item> list = new ArrayList<>(content);
        list.add(item);
        this.content = list;
    }

    /**
     * Metoda zjistí, zda-li je daný item v batohu.
     * Najde se pomocí jména.
     *
     * @param name jméno věci (Item)
     * @return Vrací výsledek true (Item je v batohu), false (Item není v batohu)
     */
    public boolean containsItemByName(String name){
        for (Item item: this.content) {
            if(Global.normalizeText(item.getName().toLowerCase()).equals(Global.normalizeText(name.toLowerCase()))){
                return true;
            }
        }
        return false;
    }

    /**
     * Metoda odebere věc (Item) z obsahu batohu.
     *
     * @param item věc pro odebrání
     */
    public void removeItem(Item item){
            List<Item> list = new ArrayList<Item>(this.content);
            list.remove(item);
            this.content = list;
    }

    /**
     * Metoda zjistí, najde item v batohu.
     * Najde se pomocí jména.
     *
     * @param name jméno věci (Item)
     */
    public Item getItemByName(String name){
        for (Item item: this.content) {
            if(Global.normalizeText(item.getName().toLowerCase()).equals(Global.normalizeText(name.toLowerCase()))){
                return item;
            }
        }
        return null;
    }

    /**
     * Metoda slouží jako getter pro obsah batohu.
     *
     * @return Vrací věci (Item) obsažené v batohu.
     */
    public List<Item> getContent(){
        return this.content;
    }

    /**
     * Metoda slouží jako getter pro kapacitu batohu.
     *
     * @return Vrací kapacitu (int).
     */
    public int getCapacity() {
        return this.capacity;
    }

    /**
     * Metoda slouží pro zobrazení všech názvů věcí v batohu v podobě Stringu oddělenýma čárkama.
     *
     * @return Vrací seznam věcí v batohu.
     */
    public String getAvailableItems(){
        if(this.content.size() == 0)
            return "-";
        return this.content.toString().replace("[", "").replace("]", "");
    }
}
