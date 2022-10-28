/**
 * Třída Room - slouží k definici místnosti.
 * Tato třída uchovává různé Itemy a Interakce pro každou instanci.
 * Tato třída je součástí jednoduché textové hry.
 *
 * @author Martin Fanta
 * @version 1.0
 * @created říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics.rooms;

import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.interactions.Interaction;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Room {

    private final String name;

    private final String emoji;
    private List<Item> items;
    private List<Interaction> interactions;
    private List<Room> otherRooms;
    private final String onEnterText;

    public Room(String name, String emoji, List<Item> items, List<Interaction> interactions, List<Room> otherRooms, String onEnterText) {
        this.name = name;
        this.emoji = emoji;
        this.items = items;
        this.otherRooms = otherRooms;
        this.onEnterText = onEnterText;
        this.interactions = interactions;
    }

    /**
     * Metoda se volá před vstupem do instance Room, slouží převážně pro Override s využitím individuální funkce.
     *
     *@param game Instance běžící hry
     *@return Vrací boolean, pokud do místnosti lze vstoupit (true), pokud ne (false)
     */
    public boolean beforeEnter(Game game) {
        return true;
    }

    /**
     * Metoda se volá po vstupu do instance Room, slouží převážně pro Override s využitím individuální funkce.
     *
     * @param game Instance běžící hry
     */
    public void afterEnter(Game game) {
    }

    /**
     * Metoda se volá při výstupu z instance Room, slouží převážně pro Override s využitím individuální funkce.
     *
     *@param game Instance hry
     *@return Vrací boolean, pokud z místnosti lze vystoupit (true), pokud ne (false)
     */
    public boolean onExit(Game game, Room nextRoom) {
        return true;
    }


    /**
     * Metoda slouží jako getter pro field name.
     *
     * @return Vrací nazev místnosti (Room)
     */
    public String getName() {
        return name;
    }

    /**
     * Metoda slouží k získání místností (Room), do kterých lze jít z dané instance Room.
     *
     * @return Vrací list místností (Room)
     */
    public List<Room> getOtherRooms() {
        return otherRooms;
    }

    /**
     * Metoda slouží k získání vstupního textu dané instance Room.
     *
     * @return Vrací vstupní text
     */
    public String getOnEnterText() {
        return onEnterText;
    }

    /**
     * Metoda slouží k získání seznamu věcí v místnosti v podobě String (oddělené čárkou).
     *
     * @return Vrací všechny věci v místnosti
     */
    public String getAllItemsText() {
        if (this.items == null)
            return "-";
        return this.items.toString().replace("[", "").replace("]", "");
    }

    /**
     * Metoda slouží k získání seznamu interakcí v místnosti v podobě String (oddělené čárkou).
     *
     * @return Vrací všechny dostupné interakce v místnosti
     */
    public String getAllInteractionsText() {
        if (this.interactions == null)
            return "-";
        return this.interactions.toString().replace("[", "").replace("]", "");
    }


    /**
     * Metoda slouží k získání místnosti, do které můžu z dané Instance jít.
     * Vyhledávání probíhá prostřednictvím stringového parametru.
     *
     * @param name název, podle kterého chceme vyhledávat
     * @return Vrací vyhledanou místnost (instance Room)
     */
    public Room getOtherRoomByName(String name) {
        List<Room> rooms = this.getOtherRooms();

        for (Room room : rooms) {
            if (Global.normalizeText(room.getName().toLowerCase()).equals(Global.normalizeText(name.toLowerCase())))
                return room;
        }
        return null;
    }

    /**
     * Metoda slouží k interakce v dané instanci.
     * Vyhledávání probíhá prostřednictvím stringového parametru.
     *
     * @param name název, podle kterého chceme vyhledávat
     * @return Vrací vyhledanou interakci (instance Interaction)
     */
    public Interaction getInteractionByName(String name) {
        List<Interaction> interactions = this.getInteractions();

        for (Interaction interaction : interactions) {
            if (Global.normalizeText(interaction.getName().toLowerCase()).equals(Global.normalizeText(name.toLowerCase())))
                return interaction;
        }
        return null;
    }


    /**
     * Metoda slouží pro získání všech věcí (Item), které se v dané místnosti nachází
     *
     * @return Vrací list věcí (instancí Item)
     */
    public List<Item> getItems() {
        return this.items;
    }

    /**
     * Metoda slouží pro získání všech interakcí (Interaction), které se v dané místnosti nachází
     *
     * @return Vrací list interakcí (instancí Interaction)
     */
    public List<Interaction> getInteractions() {
        return this.interactions;
    }

    /**
     * Metoda přidává do dané místnosti novou věc (Item)
     *
     * @param item věc, kterou chceme přidat
     */
    public void addItem(Item item) {
        if (this.items != null) {
            List<Item> list = new ArrayList<Item>(this.items);
            list.add(item);
            this.items = list;
        } else {
            this.items = Arrays.asList(new Item[]{item});
        }
    }

    /**
     * Metoda odebírá z dané místnosti danou věc (Item)
     *
     * @param item věc, kterou chceme odebrat
     */
    public void removeItem(Item item) {
        List<Item> list = this.items != null ? new ArrayList<Item>(this.items) : Collections.<Item>emptyList();
        list.remove(item);
        this.items = list;
    }

    /**
     * Metoda přidává do dané místnosti novou interakci (Interaction)
     *
     * @param interaction interakci, kterou chceme přidat
     */
    public void addInteraction(Interaction interaction) {
        if (this.interactions != null) {
            List<Interaction> list = new ArrayList<Interaction>(this.interactions);
            list.add(interaction);
            this.interactions = list;
        } else {
            this.interactions = Arrays.asList(new Interaction[]{interaction});
        }
    }

    /**
     * Metoda odebírá z dané místnosti danou interakci (Interaction)
     *
     * @param interaction interakce, kterou chceme odebrat
     */
    public void removeInteraction(Interaction interaction) {
        List<Interaction> list = new ArrayList<Interaction>(this.interactions);
        list.remove(interaction);
        this.interactions = list;
    }

    /**
     * Metoda přidá do dané místnosti novou místnost, do které lze jít z instance místnosti (Room)
     *
     * @param room místnost, kterou chceme přidat
     */
    public void addOtherRoom(Room room) {
        if (this.otherRooms != null) {
            List<Room> list = new ArrayList<Room>(this.otherRooms);
            list.add(room);
            this.otherRooms = list;
        } else {
            this.otherRooms = Arrays.asList(new Room[]{room});
        }
    }

    /**
     * Metoda odebírá z dané místnosti místnost, do které šlo jít z instance místnosti (Room)
     * Resp. už se z instance do této místnosti nedostaneme.
     *
     * @param room místnost, kterou chceme odebrat
     */
    public void removeOtherRoom(Room room) {
        List<Room> list = new ArrayList<>(this.otherRooms);
        list.remove(room);
        this.otherRooms = list;
    }

    /**
     * Metoda slouží k získání fieldu emoji dané instance Room.
     *
     * @return Vrací emoji string
     */
    public String getEmoji() {
        return emoji;
    }

    /**
     * Metoda přepisuje toString.
     *
     * @return Vrací jmeno místnosti
     */
    @Override
    public String toString() {
        return name;
    }
}
