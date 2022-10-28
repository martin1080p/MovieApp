/**
 *  Třída HospitalWaiting - dědí třídu Room.
 *
 *  Jedná se o předdefinovanou implementaci místnosti
 *
 *  Pro více info viz třída Room
 *
 *  Tato třída je součástí jednoduché textové hry.
 *
 *@author     Martin Fanta
 *@version    1.0
 *@created    říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics.rooms.subrooms;
import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.interactions.OckovaniAct;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;
import main.java.cz.vse.fanm02.adventure.main.logics.rooms.Room;
import java.util.Arrays;
import java.util.List;

public class HospitalWaiting extends Room {

    public HospitalWaiting(List<Room> otherRooms, Game game){
        super(  "Čekárna",
                "⏰",
                Arrays.asList(
                        new Item(
                                "Židle",
                                false,
                                "Hm... celkem pohodlná židle, ale starším by se asi hodila víc.."
                        )
                ),
                Arrays.asList(new OckovaniAct()),
                otherRooms,
                ""
                );
    }
}
