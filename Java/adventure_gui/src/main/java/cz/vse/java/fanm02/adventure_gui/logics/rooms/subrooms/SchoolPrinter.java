/**
 * Třída SchoolPrinter - dědí třídu Room.
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
import main.java.cz.vse.fanm02.adventure.main.logics.interactions.CertifikatAct;
import main.java.cz.vse.fanm02.adventure.main.logics.rooms.Room;

import java.util.Arrays;
import java.util.List;

public class SchoolPrinter extends Room {

    public SchoolPrinter(List<Room> otherRooms, Game game) {
        super("Tiskárna",
                "🖨",
                null,
                Arrays.asList(new CertifikatAct()),
                otherRooms,
                ""
        );
    }
}
