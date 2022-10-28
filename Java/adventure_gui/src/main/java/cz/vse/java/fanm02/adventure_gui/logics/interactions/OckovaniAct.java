/**
 * Třída OckovaniAct - dědí třídu Interaction.
 * pro více info viz třídu Interaction
 *
 * Tato třída je součástí jednoduché textové hry.
 *
 * @author Martin Fanta
 * @version 1.0
 * @created říjen 2022
 */


package main.java.cz.vse.fanm02.adventure.main.logics.interactions;

import java.util.concurrent.TimeUnit;

import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;

public class OckovaniAct extends Interaction {
    public OckovaniAct() {
        super("Očkování", true, "");
    }

    @Override
    public void afterPick(Game game) {
        Global.gamePrint("Sestra ti řekla, ať chvíli počkáš, než tě pustí do ordinace..");
        Global.gamePrint("Chvíli počkej...");
        for (int i = 0; i < 6; i++) {
            System.out.print(".");
            try {
                TimeUnit.SECONDS.sleep(3);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }

        if (game.getCurrentRoom().getOtherRooms().size() < 2) {
            game.getCurrentRoom().addOtherRoom(game.getCurrentRoom().getOtherRoomByName("Nemocnice").getOtherRoomByName("Ordinace"));
        }

        Global.gamePrint("\nSestra tě zavolala..");
        Global.gamePrint("Nyní můžeš jít do ordinace..\n***\n");
        Global.gamePrint("Možné cesty: " + game.getAvailableRooms());

        super.afterPick(game);
    }
}
