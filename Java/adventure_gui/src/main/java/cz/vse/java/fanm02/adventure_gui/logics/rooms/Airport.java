/**
 * Třída Airport - dědí třídu Room.
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
import main.java.cz.vse.fanm02.adventure.main.logics.interactions.LetenkaAct;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;

import java.util.Arrays;
import java.util.List;

public class Airport extends Room {

    public Airport(List<Room> otherRooms, Game game) {
        super("Letiště",
                "✈",
                Arrays.asList(
                        new Item(
                                "Klíčenka",
                                true,
                                ""
                        )
                ),
                Arrays.asList(new LetenkaAct()),
                otherRooms,
                ""
        );
    }
}
