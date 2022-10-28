/**
 * Třída City - dědí třídu Room.
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

public class City extends Room {

    public City(List<Room> otherRooms, Game game) {
        super("Město",
                "🏙",
                Arrays.asList(
                        new Item(
                                "Láhev",
                                false,
                                "Starej lahváč, nechci být další, kdo na něm zanechá DNA"
                        ),
                        new Item(
                                "Papír",
                                true,
                                ""
                        )
                ),
                null,
                otherRooms,
                ""
        );
    }
}
