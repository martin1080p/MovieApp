/**
 * Třída FoceniAct - dědí třídu Interaction.
 * pro více info viz třídu Interaction
 *
 * Tato třída je součástí jednoduché textové hry.
 *
 * @author Martin Fanta
 * @version 1.0
 * @created říjen 2022
 */

package main.java.cz.vse.fanm02.adventure.main.logics.interactions;

import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Fotka;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;

public class FoceniAct extends Interaction {

    public FoceniAct() {
        super("Focení", true, "Stačí ti jedno focení..");
    }

    @Override
    public void afterPick(Game game) {
        game.addItemToRoom(game.getCurrentRoom(), new Fotka());
        Global.gamePrint("Byl jsi vyfocen a tvoje fotka leží na pultu..");
        Global.gamePrint("Předměty v místě: " + game.getCurrentRoom().getAllItemsText());

        super.afterPick(game);
    }
}
