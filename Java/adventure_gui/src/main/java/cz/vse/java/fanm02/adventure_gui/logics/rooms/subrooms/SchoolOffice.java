/**
 * Třída SchoolOffice - dědí třídu Room.
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

package main.java.cz.vse.fanm02.adventure.main.logics.rooms.subrooms;

import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.interactions.IsicAct;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;
import main.java.cz.vse.fanm02.adventure.main.logics.rooms.Room;

import java.util.Arrays;
import java.util.List;

public class SchoolOffice extends Room {

    public SchoolOffice(List<Room> otherRooms, Game game) {
        super("Kancelář",
                "🖥",
                Arrays.asList(
                        new Item(
                                "Počítač",
                                false,
                                "Opravdu na tom jedou Visty??? Tak to fakt nechci..."
                        )
                ),
                Arrays.asList(new IsicAct()),
                otherRooms,
                ""
        );
    }
}
