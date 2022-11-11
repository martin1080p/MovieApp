package cz.vse.fanm02;

import java.util.Collection;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

public interface EvidenceLyzi {
    Collection<Lyze> seznam = new LinkedList<Lyze>();

    default boolean vlozLyze(Lyze lyze){
        for (Lyze l: seznam) {
            if(l.equals(lyze))
                return false;
        }
        seznam.add(lyze);
        return true;
    }

    public default Collection<Lyze> vratSeznam(){
        return seznam;
    }

    public default Collection<Lyze> vratSeznamVolnychLyzi(){
        Collection<Lyze> temp = new LinkedList<Lyze>();

        for (Lyze l: seznam) {
            if(l.getZakaznik() == null){
                temp.add(l);
            }
        }
        return temp;
    }

    public default Lyze vratLyze(int inventarniCislo){
        for (Lyze l: seznam) {
            if(l.getInventarniCislo() == inventarniCislo){
                return l;
            }
        }
        return null;
    }
}
