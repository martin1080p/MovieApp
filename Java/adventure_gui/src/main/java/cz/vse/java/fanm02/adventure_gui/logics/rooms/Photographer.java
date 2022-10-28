/**
 * Třída Photographer - dědí třídu Room.
 * <p>
 * Jedná se o předdefinovanou implementaci místnosti
 * <p>
 * Pro více info viz třída Room
 * <p>
 * Tato třída je součástí jednoduché textové hry.
 *
 * @author Martin Fanta
 * @version 1.0
 * @created říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics.rooms;

import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.interactions.FoceniAct;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Fotak;

import java.util.Arrays;
import java.util.List;

public class Photographer extends Room {

    public Photographer(List<Room> otherRooms, Game game) {
        super("Fotograf",
                "📷",
                Arrays.asList(new Fotak()),
                Arrays.asList(new FoceniAct()),
                otherRooms,
                ""
        );
    }


}
