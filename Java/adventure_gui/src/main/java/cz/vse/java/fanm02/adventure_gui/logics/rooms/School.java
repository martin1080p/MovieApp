/**
 * Třída School - dědí třídu Room.
 *
 * Jedná se o předdefinovanou implementaci místnosti
 *
 * Pro více info viz třída Room
 *
 * Tato třída je součástí jednoduché textové hry.
 *
 * @author Martin Fanta
 * @version 1.0
 * @created říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics.rooms;

import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;

import java.util.Arrays;
import java.util.List;

public class School extends Room {
    public School(List<Room> otherRooms, Game game) {
        super("Škola",
                "📐",
                Arrays.asList(
                        new Item(
                                "Letak",
                                false,
                                "'Přihlas se do profesionálního fotbalového klubu i ty!' Pff.... sporty nedělám.."
                        )
                ),
                null,
                otherRooms,
                "");
    }
}
