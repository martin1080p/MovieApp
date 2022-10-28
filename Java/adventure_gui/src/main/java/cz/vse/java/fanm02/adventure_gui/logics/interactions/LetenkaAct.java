/**
 * Třída LetenkaAct - dědí třídu Interaction.
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
import main.java.cz.vse.fanm02.adventure.main.logics.items.Letenka;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;

public class LetenkaAct extends Interaction {
    public LetenkaAct() {
        super("Letenka",
                false,
                "Bez potvrzení o očkování tě do letadla nepustí, zkus ho nejdřív získat..",
                "Výborně, získal jsi letenku! (o palubní lístky se starat nemusíš)"
        );
    }


    private boolean used = false;

    @Override
    public boolean beforePick(Game game) {

        if (game.getBackpack().containsItemByName("Certifikát") && !used) {
            this.setAvailable(true);
            this.setTooltip("Letíš sám, nepotřebuješ další letenku..");
        }

        return super.beforePick(game);
    }

    @Override
    public void afterPick(Game game) {
        Letenka letenka = new Letenka();
        game.getCurrentRoom().addItem(letenka);
        used = true;
        super.afterPick(game);
        Global.gamePrint("Předměty v místě: " + game.getCurrentRoom().getAllItemsText());
    }
}
