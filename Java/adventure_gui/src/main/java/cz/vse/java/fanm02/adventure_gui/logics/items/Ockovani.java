/**
 * Třída Ockovani - dědí třídu Item.
 * pro více info viz třídu Item
 *
 * Tato třída je součástí jednoduché textové hry.
 *
 * @author Martin Fanta
 * @version 1.0
 * @created říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics.items;

import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.rooms.Room;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;

public class Ockovani extends Item {
    public Ockovani(){
        super("Očkování", true, "");
    }

    @Override
    public void afterPick(Game game) {
        Room cekarna = game.getCurrentRoom().getOtherRoomByName("Nemocnice").getOtherRoomByName("Čekárna");
        cekarna.removeInteraction(cekarna.getInteractionByName("Očkování"));

        game.setVaccination(true);
        game.getCurrentRoom().removeItem(this);

        Global.gamePrint("Nyní jsi očkovaný");
        Global.gamePrint("Zatím máš certifikát pouze v Tečce.. ");
        Global.gamePrint("Řada institucí ji ale vyžaduje převážně v tištěné formě..");
    }
}
