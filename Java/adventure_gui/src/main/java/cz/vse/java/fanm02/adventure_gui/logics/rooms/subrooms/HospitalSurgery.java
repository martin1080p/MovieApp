/**
 *  Třída HospitalSurgery - dědí třídu Room.
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
import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Ockovani;
import main.java.cz.vse.fanm02.adventure.main.logics.rooms.Room;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;
import java.util.Arrays;
import java.util.List;

public class HospitalSurgery extends Room {

    public HospitalSurgery(List<Room> otherRooms, Game game){
        super(  "Ordinace",
                "💉",
                Arrays.asList(
                        new Ockovani(),
                        new Item(
                                "Kartotéka",
                                false,
                                "Asi bych do ní šmátrat neměl, čistě kvůli GDPR.."
                        ),
                        new Item(
                                "Bonbón",
                                true,
                                ""
                        )
                ),
                null,
                otherRooms,
                ""
                );
    }

    @Override
    public boolean beforeEnter(Game game) {
        if(game.getCurrentRoom() instanceof HospitalWaiting){
            Global.gamePrint("Nyní můžeš dostat očkování.. (příkaz vem)");
            return true;
        }
        Global.gamePrint("Nemůžeš bez čekání jen tak vtrhnout do ordinace, musíš jít do čekárny a říct, co potřebuješ..jdi");
        return false;
    }

    @Override
    public void afterEnter(Game game) {
        if(this.getOtherRooms().size() < 2){
            this.addOtherRoom(game.getCurrentRoom().getOtherRoomByName("Nemocnice").getOtherRoomByName("Čekárna"));
        }
    }
}
