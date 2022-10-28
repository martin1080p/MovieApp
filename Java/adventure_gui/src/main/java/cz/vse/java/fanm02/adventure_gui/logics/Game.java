/**
 * Třída Game - slouží k celkovému ovládání hry (příkazy, prvky).
 * Používá se pro rozpoznávání jednotlivých příkazů.
 *
 * Tato třída je součástí jednoduché textové hry.
 *
 * @author Martin Fanta
 * @version 1.0
 * @created říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics;

import main.java.cz.vse.fanm02.adventure.main.logics.interactions.Interaction;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Backpack;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Propiska;
import main.java.cz.vse.fanm02.adventure.main.logics.rooms.*;
import main.java.cz.vse.fanm02.adventure.main.logics.rooms.subrooms.HospitalSurgery;
import main.java.cz.vse.fanm02.adventure.main.logics.rooms.subrooms.HospitalWaiting;
import main.java.cz.vse.fanm02.adventure.main.logics.rooms.subrooms.SchoolOffice;
import main.java.cz.vse.fanm02.adventure.main.logics.rooms.subrooms.SchoolPrinter;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;

import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Game {

    private Room currentRoom;
    private boolean isRunning;
    private final Scanner scanner;
    private final Backpack backpack;
    private boolean vaccination;

    public Game() {
        isRunning = true;
        backpack = new Backpack(Arrays.asList(new Propiska()));
        scanner = new Scanner(System.in);
    }


    /**
     * Metoda slouží pro zahájení hry
     */
    public void start() {

        Room entryRoom = generateMap();
        printNapoveda();
        printPomoc();
        enterRoom(entryRoom, false);
    }

    /**
     * Metoda slouží pro vstup do místnosti
     *
     * @param room  místnost, do které chceme vstoupit
     * @param clear boolean zda-li chceme po každém vstupu "vyčistit" konzoli (záleží na typu terminalu, který využíváme)
     */
    public void enterRoom(Room room, boolean clear) {
        if (clear)
            Global.clearScreen();

        if (this.currentRoom == null || ((this.currentRoom.onExit(this, room)) && room.beforeEnter(this))) {
            this.currentRoom = room;
            room.afterEnter(this);
            Global.gamePrint(room.getOnEnterText());
        }
        printInfo();
    }

    /**
     * Metoda slouží pro přečtení vstupu od uživatele (input)
     */
    public void readInput() {
        if (!Global.isPrinting) {
            Global.print("> ");
            String input = scanner.nextLine();
            if (!input.equals(""))
                this.readCommand(input);
        }
    }

    /**
     * Metoda slouží k získání možných východů z aktuální místnosti v podobě String (oddělené čárkou).
     *
     * @return Vrací všechny dostupné cesty v aktuální místnosti
     */
    public String getAvailableRooms() {
        return this.currentRoom.getOtherRooms().toString().replace("[", "").replace("]", "");
    }


    /**
     * Metoda slouží k pokusu převést vstup od uživatele na konkrétní příkaz
     *
     * @param text vstup od uživatele (input)
     */
    private void readCommand(String text) {

        String command = text;
        String parameter = "";

        Pattern pattern = Pattern.compile("\s+");
        Matcher matcher = pattern.matcher(text);

        if (matcher.find()) {
            command = text.split("\s+")[0];
            parameter = text.split("\s+")[1];
        }

        switch (Global.normalizeText(command.toLowerCase())) {
            case "jdi":
                Room nextRoom = this.currentRoom.getOtherRoomByName(parameter);
                if (nextRoom == null) {
                    Global.gamePrint("Tahle místnost neexistuje, nebo se do ní teď nedostaneš..");
                    break;
                }
                enterRoom(nextRoom, true);
                break;
            case "vem":
                Item pickableItem = getPickableItemByName(parameter);
                pickUpItem(pickableItem);
                break;
            case "poloz":
                Item item = this.backpack.getItemByName(parameter);
                dropItem(item);
                break;
            case "zarid":
                Interaction pickableInteraction = getPickableInteractionByName(parameter);
                doInteraction(pickableInteraction);
                break;
            case "napoveda":
                printNapoveda();
                break;
            case "pomoc":
                printPomoc();
                break;
            case "info":
                printInfo();
                break;
            case "konec":
                endGame();
                break;
            default:
                Global.gamePrint("Tento příkaz neexistuje, použi příkaz 'pomoc'");
                break;
        }
    }

    /**
     * Metoda zjišťuje, zda-li má uživatel v batohu Letenku, Vízum a Pas.
     * Pokud má, vypíše gratulaci.
     */
    public void checkEnd() {
        if (this.getBackpack().containsItemByName("Letenka") &&
                this.getBackpack().containsItemByName("Vízum") &&
                this.getBackpack().containsItemByName("Pas")
        ) {
            Global.gamePrint("*************************");
            Global.gamePrint("vvv----GRATULUJU!----vvv");
            Global.gamePrint("Získal jsi všechny 3 věci");
            Global.gamePrint("Letenka, Pas, Vízum");
            endGame();
        }
    }

    /**
     * Metoda vypíše pomoc.
     * (seznam příkazů)
     */
    public void printPomoc() {
        Global.gamePrint("Příkazy:\njdi - přesun do jineho mista (např.: 'jdi město')\nvem - sebrat / aplikovat předmět (např.: 'vem fotka')\npoloz - položení předmětu z batohu (např.: 'poloz fotka')\nzarid - umožnujě interakci / něco zařídit (např.: 'zarid očkování')\ninfo - zobrazí botoh a dostupné věci v aktuálním místě (např.: 'info')\nnapoveda - zobrazí nápovědu (např.: 'napoveda')\nkonec - ukončí hru (např.: 'konec')");
    }

    /**
     * Metoda vypíše nápovědu.
     * (cíl hry)
     */
    public void printNapoveda() {
        Global.gamePrint("Nacházíš se v centru města, za týden odjíždíš na dovolenou.$\nZjistil jsi ale, že tvému dosavadnímu pasu vypršela platnost.$\nSpolu s pasem je potřeba si ještě zařídit vízum a letenku.\n\n$Pro výhru získej letenku, vízum a nový pas.\n\n*********************");
    }

    /**
     * Metoda vypíše info.
     * (Aktuální místnost, dostupné předměty, dostupné interakce, věci v batohu a možné cesty)
     */
    public void printInfo() {
        Global.gamePrint("Nacházíš se v: " + this.currentRoom + " " + this.currentRoom.getEmoji());
        Global.gamePrint("Předměty v místě: " + this.currentRoom.getAllItemsText());
        Global.gamePrint("Zde lze zařídit: " + this.currentRoom.getAllInteractionsText());
        Global.gamePrint("\nVeci v batohu: " + this.backpack.getAvailableItems());
        Global.gamePrint("\nMožné cesty: " + getAvailableRooms());
    }

    /**
     * Metoda ukončí hru.
     */
    public void endGame() {
        this.isRunning = false;
        Global.gamePrint("Konec hry...");
    }

    /**
     * Metoda vezme věc z místnosti a přidá ji do batohu.
     *
     * @param item věc, kterou chci vzít
     */
    public void pickUpItem(Item item) {
        if (item != null && item.beforePick(this)) {
            item.afterPick(this);
        } else
            Global.gamePrint("Nemůžeš vzít tento předmět");
    }

    /**
     * Metoda odloží věc z batohu do místnosti.
     *
     * @param item věc, kterou chci polozit
     */
    public void dropItem(Item item) {
        if (item != null) {
            this.backpack.removeItem(item);
            this.currentRoom.addItem(item);
            Global.gamePrint("Položil jsi " + item);
        } else
            Global.gamePrint("Tento předmět v batohu nemáš");
    }

    /**
     * Metoda zahájí danou interakci v místnosti.
     *
     * @param interaction interakce, kterou chci provést
     */
    public void doInteraction(Interaction interaction) {
        if (interaction != null && interaction.beforePick(this)) {
            interaction.afterPick(this);
        } else
            Global.gamePrint("Tohle teď zařídit nemůžeš");
    }

    /**
     * Metoda slouží k nalezení věci, kterou lze sebrat, podle jejího názvu.
     *
     * @param name název hledané věci
     * @return Vrací nalezenou věc (Item)
     */
    public Item getPickableItemByName(String name) {

        List<Item> items = this.currentRoom.getItems();

        if (items == null)
            return null;

        for (Item item : items) {
            if (Global.normalizeText(item.getName().toLowerCase()).equals(Global.normalizeText(name.toLowerCase()))) {
                if (item.isAvailable()) {
                    return item;
                }
                Global.gamePrint(item.getTooltip());
            }
        }
        return null;
    }

    /**
     * Metoda slouží k nalezení interakce, kterou lze dělat, podle jajího názvu.
     *
     * @param name název hledané interakce
     * @return Vrací nalezenou interakci (Interaction)
     */
    public Interaction getPickableInteractionByName(String name) {
        List<Interaction> interactions = this.currentRoom.getInteractions();

        for (Interaction interaction : interactions) {
            if (Global.normalizeText(interaction.getName().toLowerCase()).equals(Global.normalizeText(name.toLowerCase()))) {
                return interaction;
            }
        }
        return null;
    }

    /**
     * Metoda slouží jako getter k fieldu isRunning.
     *
     * @return Vrací boolean hodnotu isRunning
     */
    public boolean isRunning() {
        return isRunning;
    }

    /**
     * Metoda slouží jako getter k fieldu currentRoom.
     *
     * @return Vrací Room hodnotu currentRoom
     */
    public Room getCurrentRoom() {
        return currentRoom;
    }

    /**
     * Metoda slouží jako getter k fieldu backpack.
     *
     * @return Vrací Backpack hodnotu backpack
     */
    public Backpack getBackpack() {
        return backpack;
    }

    /**
     * Metoda slouží jako getter k fieldu vaccination.
     *
     * @return Vrací boolean hodnotu vaccination
     */
    public boolean isVaccination() {
        return vaccination;
    }

    /**
     * Metoda slouží jako setter k boolean fieldu vaccination.
     */
    public void setVaccination(boolean vaccination) {
        this.vaccination = vaccination;
    }

    /**
     * Metoda slouží k přidání věci do jiné než aktuální místnosti.
     *
     * @param room místnost, do které chceme přidat věc
     * @param item věc, kterou chceme přidat
     */
    public void addItemToRoom(Room room, Item item) {
        room.addItem(item);
    }

    /**
     * Metoda slouží k odebrání věci z jiné než aktuální místnosti.
     *
     * @param room místnost, ze které chceme odebrat věc
     * @param item věc, kterou chceme odebrat
     */
    public void removeItemFromRoom(Room room, Item item) {
        room.removeItem(item);
    }

    /**
     * Metoda slouží k přidání interakce do jiné než aktuální místnosti.
     *
     * @param room        místnost, do které chceme přidat interakci
     * @param interaction interakce, kterou chceme přidat
     */
    public void addInteractionToRoom(Room room, Interaction interaction) {
        room.addInteraction(interaction);
    }

    /**
     * Metoda slouží k odebrání interakce z jiné než aktuální místnosti.
     *
     * @param room        místnost, ze které chceme odebrat interakce
     * @param interaction interakce, kterou chceme odebrat
     */
    public void removeInteractionFromRoom(Room room, Interaction interaction) {
        room.removeInteraction(interaction);
    }

    /**
     * Metoda slouží ke generaci mapy hry
     *
     * @return Vrací rodičovskou místnost (Room)
     */
    public Room generateMap() {
        Room map = new City(Arrays.asList(
                new Photographer(null, this),
                new Magistrat(null, this),
                new Embassy(null, this),
                new Airport(null, this),
                new Hospital(Arrays.asList(
                        new HospitalSurgery(null, this),
                        new HospitalWaiting(null, this)
                ),
                        this),
                new School(Arrays.asList(
                        new SchoolOffice(null, this),
                        new SchoolPrinter(null, this)
                ),
                        this)
        ),
                this);

        return completeRooms(map, null);
    }


    /**
     * Metoda přidá do cest ke každým potomkům jejich bezprostředního rodiče
     * Pozor, metoda je rekurzivní!
     *
     * @param room       místnost, která má cesty, do kterých chceme tuto místnost přidat
     * @param parentRoom rodičkovská místnost room
     * @return Vrací rodičovskou místnost (Room)
     */
    private Room completeRooms(Room room, Room parentRoom) {

        if (parentRoom != null)
            room.addOtherRoom(parentRoom);

        if (!room.getOtherRooms().contains(room)) {
            for (Room otherRoom : room.getOtherRooms()) {
                if (otherRoom != parentRoom)
                    completeRooms(otherRoom, room);
            }
        }
        return room;
    }
}
