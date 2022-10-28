/**
 * Třída Embassy - dědí třídu Room.
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
import main.java.cz.vse.fanm02.adventure.main.logics.interactions.VizumAct;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;

import java.util.Arrays;
import java.util.List;

public class Embassy extends Room {
    public Embassy(List<Room> otherRooms, Game game) {
        super("Ambasáda",
                "📬",
                Arrays.asList(
                        new Item(
                                "Portrét",
                                false,
                                "'Nelson Mandela, prezident JAR, 1918-2013'\nBylo by cynické krást jeho obraz..",
                                ""
                        ),
                        new Item(
                                "Váza",
                                false,
                                "Jenom nějaká stará váza, ale vypadá docela těžce",
                                ""
                        )
                ),
                Arrays.asList(new VizumAct()),
                otherRooms,
                ""
        );
    }
}
